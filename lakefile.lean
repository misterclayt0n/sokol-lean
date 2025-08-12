import Lake
open System Lake DSL

package «sokol-lean» where
  version := v!"0.1.0"

lean_lib SokolLean

@[default_target] 
lean_exe «sokol-lean» where
  root := `Main
  moreLinkArgs :=
    if System.Platform.isWindows then
      #["-luser32", "-lshell32", "-lgdi32", "-ld3d11", "-ldxgi"]
    else if System.Platform.isOSX then
      #["-framework","Metal","-framework","Cocoa","-framework","QuartzCore"]
    else
      #["-lX11","-lXi","-lXcursor","-lGL","-ldl","-lpthread"]  -- Penguim/X11 + GL.

/-- Location of vendored sokol headers. -/
def sokolDir (pkg : NPackage _package.name) := pkg.dir / "c" / "sokol"

/-- Compile the sokol shim. -/
target «c.sokol.o» (pkg : NPackage _package.name) : FilePath := do
  let src := pkg.dir / "c" / "sokol_shim.c"
  let o   := pkg.irDir / "c" / "sokol_shim.o"
  let job ← inputBinFile src
  -- Only the include path here; the SOKOL_* macros are defined in the .c file.
  buildO o job #["-I", (sokolDir pkg).toString] #[] 

/-- Bundle into a static lib; Lake auto-links extern_libs into exes/shared libs. -/
extern_lib «sokol_clib» (pkg : NPackage _package.name) := do
  let name := nameToStaticLib "sokol_clib"
  let o ← fetch <| pkg.target ``«c.sokol.o»
  buildStaticLib (pkg.staticLibDir / name) #[o]
