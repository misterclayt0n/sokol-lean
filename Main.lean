import SokolLean

open SokolLean

def main : IO Unit :=
  let r := addTwo 40 2
  IO.println s!"add_two(40, 2) = {r.toNat}"
