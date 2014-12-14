import os
import libclang
import unsigned
import strutils

template withFile(f, fn, mode: expr, actions: stmt): stmt {.immediate.} =
  var f: File
  if open(f, fn, mode):
    try:
      actions
    finally:
      close(f)
  else:
    quit("cannot open: " & fn)

proc showClangVersion() =
  var version = getClangVersion()
  var verString = getCString(version);
  echo verString
  disposeString(version)
  
proc getTokenKindSpelling(kind: CXTokenKind): string =  
  case kind:
  of CXTokenKind.Punctuation:
    return "Punctuation"
  of CXTokenKind.Keyword:
    return "Keyword"
  of CXTokenKind.Identifier:
    return "Identifier"
  of CXTokenKind.Literal:
    return "Literal"
  of CXTokenKind.Comment:
    return "Comment"
  else:
    return "Unknown"


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


#type 
#  CArray[T] = ref object
#    data: ptr T

#proc `[]`[T](a: CArray[T], index: cuint): T =
#  let mem = cast[int](a.data) + index.int64 * sizeof(T)
#  let point = cast[ptr T](mem)
#  point[]
    
    
proc showAllTokens(tu: CXTranslationUnit, tokens: ptr CXToken, numTokens: cuint) =
  echo "==showTokens=="
  echo "Numtokens: $1" % [$numTokens]
  for i in 0.cuint.. <numTokens:
    #let tkArr = CArray[CXToken](data: tokens)
    let tkArr = initCArray(tokens,numTokens)
    var token = tkArr[i]
    let kind = getTokenKind(token)
    let spell = getTokenSpelling(tu, token)
    let loc = getTokenLocation(tu, token)
    
    var file: CXFile
    var line, column, offset: cuint
    getFileLocation(loc, file.addr, line.addr, column.addr, offset.addr)
    let filename = getFileName(file)
    
    echo "Token $1" % [$i]
    echo " Text: $1" % [$getCstring(spell)]
    echo " Kind: $1" % [getTokenKindSpelling(kind)]
    
    echo " Location $1:$2:$3:$4" % [$getCstring(filename), $line, $column, $offset]
    echo ""
    
    disposeString(fileName)
    disposeString(spell)
    

proc getFilerange(tu: CXTranslationUnit, filename: cstring): CXSourceRange =
  let file = getFile(tu, filename)
  var fileSize: int64 = -1
  withFile(f,$filename,fmRead):
    fileSize = getFileSize(f)
  doAssert fileSize > -1
  let topLoc = getLocationForOffset(tu,file,0)
  let lastLoc = getLocationForOffset(tu,file,fileSize.cuint)
  if equalLocations(topLoc, getNullLocation()) != 0 or
     equalLocations(lastLoc, getNullLocation()) != 0:
    echo "cannot retrieve locations"
    quit(-1)
  
  let srcRange = getRange(topLoc,lastLoc)
  if isNull(srcRange) != 0:
    echo "cannot retrieve range"
    quit(-1)
  
  return srcRange
  

proc main: int =
  if paramCount() < 1:
    echo "usage: Tokenize filename [options ...]"
    quit(-1)

  show_clang_version()
  let allArgs = commandLineParams()
  let filename = allArgs[0]
  let args = allocCStringArray(allArgs[1..allArgs.high])
  let paramCount = (allArgs.len -1).cint
  
  let index = createIndex(1,1)
  let tu = parseTranslationUnit(index,filename.cstring,args,paramCount, nil, 0, 0)
  if tu.pointer == nil:
    echo "cannot parse translation unit"
    return 1
  
  let srcRange = getFilerange(tu,filename)
  var tokens: ptr CXToken
  var numTokens: cuint
  tokenize(tu,srcRange,tokens.addr,numTokens.addr)
  showAllTokens(tu,tokens,numTokens)
  disposeTranslationUnit(tu)
  disposeIndex(index)
  deallocCStringArray(args)
   
  
when isMainModule:
  quit main()
