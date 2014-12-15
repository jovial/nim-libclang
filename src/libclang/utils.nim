type CArrayRaw*{.unchecked.}[T] = array[0..0, T]
type CArrayUnsafe*[T] = ptr CArrayRaw[T]

type CArray*[T] =
  object
    when not defined(release):
      size: int
    mem: CArrayUnsafe[T]

proc initCArray*[T](p: CArrayUnsafe[T], k: SomeOrdinal): CArray[T] =
  when defined(release):
    CArray[T](mem: p)
  else:
    CArray[T](mem: p, size: k.int)

proc initCArray*[T](a: var openarray[T], k: SomeOrdinal): CArray[T] =
  initCArray(cast[CArrayUnsafe[T]](addr(a)), k.int)

proc initCArray*[T](a: ptr T, k: SomeOrdinal): CArray[T] =
  initCArray(cast[CArrayUnsafe[T]](a), k.int)

proc `[]`*[T](p: CArray[T], k: SomeOrdinal): T =
  when not defined(release):
    assert k.int < p.size
  result = p.mem[k]

proc `[]=`*[T](p: CArray[T], k: SomeOrdinal, val: T) =
  when not defined(release):
    assert k.int < p.size
  p.mem[k] = val


  
  
  
