def hello := "world"

namespace SokolLean

/-- Bind the C function -/
@[extern "add_two"]
opaque addTwo : UInt32 -> UInt32 -> UInt32

end SokolLean
