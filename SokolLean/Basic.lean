def hello := "world"

namespace SokolLean

/-- Opaque handle for `Acc*` living on the C heap. -/
opaque AccP : NonemptyType
def Acc := AccP.type

/-- Bind the C function -/
@[extern "add_two"]       opaque addTwo  : UInt32 -> UInt32 -> UInt32
@[extern "lean_acc_init"] opaque accInit : IO Unit
@[extern "lean_acc_new"]  opaque accNew  : IO Acc
@[extern "lean_acc_add"]  opaque accAdd  : Acc → UInt32 → IO Unit

/-- Borrowed handle; no refcount token transfer. -/
@[extern "lean_acc_mean"] opaque accMean : @& Acc → IO Float
@[extern "lean_acc_free"] opaque accFree : Acc → IO Unit

end SokolLean
