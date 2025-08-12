def hello := "world"

namespace SokolLean

@[extern "lean_set_clear_color"]   opaque setClearColor : Float → Float → Float → Float → IO Unit
@[extern "lean_sapp_request_quit"] opaque sappRequestQuit : IO Unit
@[extern "lean_sapp_run"]          opaque sappRun : IO Unit

end SokolLean
