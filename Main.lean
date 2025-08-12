import SokolLean

open SokolLean

def main : IO Unit := do
  let mut discard ← accInit          -- register external class once
  let a ← accNew
  for n in [1:6] do          -- 1..5
    discard ← accAdd a (UInt32.ofNat n)
  let m ← accMean a
  IO.println s!"mean(1..5) = {m}"
  -- optional deterministic cleanup (finalizer would also handle it eventually)
  discard ← accFree a
