import Lake
open System Lake DSL

package «sokol-lean» where
  version := v!"0.1.0"

lean_lib SokolLean
@[default_target] lean_exe «sokol-lean» where
  root := `Main

target «c.test.o» (pkg : NPackage _package.name) : FilePath := do
  let src := pkg.dir / "c" / "test.c"
  let o   := pkg.irDir / "c" / "test.o"
  let srcJob ←  inputBinFile src
  buildO o srcJob

target «c.accum.o» (pkg : NPackage _package.name) : FilePath := do
  let src := pkg.dir / "c" / "accum.c"
  let o   := pkg.irDir / "c" / "accum.o"
  let job ← inputBinFile src
  buildO o job
  
extern_lib «c_add» (pkg : NPackage _package.name) := do
  let name := nameToStaticLib "c_add"
  let o1 ←  fetch <| pkg.target ``«c.test.o»
  let o2 ←  fetch <| pkg.target ``«c.accum.o»
  buildStaticLib (pkg.staticLibDir / name) #[o1, o2]
