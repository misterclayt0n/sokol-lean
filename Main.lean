import SokolLean

open SokolLean

def main : IO Unit := do
  let mut discard ← setClearColor 0.2 0.45 0.75 1.0
  discard ← sappRun
