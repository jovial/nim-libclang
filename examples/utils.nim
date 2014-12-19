import streams
import libclang

type CArrayRaw*{.unchecked.}[T] = array[0..0, T]
type CArrayUnsafe*[T] = ptr CArrayRaw[T]

type CArray*[T] =
  object
    when not defined(release):
      size: int
    mem: CArrayUnsafe[T]

proc initCArray*[T](p: CArrayUnsafe[T], k: int): CArray[T] =
  when defined(release):
    CArray[T](mem: p)
  else:
    CArray[T](mem: p, size: k)

proc initCArray*[T](a: var openarray[T], k: int): CArray[T] =
  initCArray(cast[CArrayUnsafe[T]](addr(a)), k)

proc initCArray*[T](a: ptr T, k: cuint): CArray[T] =
  initCArray(cast[CArrayUnsafe[T]](a), k.int)

proc `[]`*[T](p: CArray[T], k: cuint|int): T =
  when not defined(release):
    assert k.int < p.size
  result = p.mem[k]

proc `[]=`*[T](p: CArray[T], k: cuint|int, val: T) =
  when not defined(release):
    assert k.int < p.size
  p.mem[k] = val
  
template withFile*(f, fn, mode: expr, actions: stmt): stmt {.immediate.} =
  var f: File
  if open(f, fn, mode):
    try:
      actions
    finally:
      close(f)
  else:
    quit("cannot open: " & fn)
    
proc writeClangVersion*(stream: Stream) =
  var version = getClangVersion()
  var verString = getCString(version);
  stream.writeLn($verString)
  disposeString(version)
