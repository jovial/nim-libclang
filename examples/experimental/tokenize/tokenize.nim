import os
import libclang
import unsigned
import strutils
import libclang/experimental as exp

  
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

proc showAllTokens(tu: CXWTranslationUnit, tokensWrapped: CXWTokenArray) =
  echo "==showTokens=="
  echo "Numtokens: $1" % [$tokensWrapped.len]
  var tokens = tokensWrapped.toSeq
  for i in 0..tokens.high:
    var token = tokens[i]
    let kind = getTokenKind(token)
    let spell = getTokenSpelling(tu, token)
    let loc = getTokenLocation(tu, token)
    
    var file: CXFile
    var line, column, offset: cuint
    getFileLocation(loc, file, line, column, offset)
    let filename = exp.getFileName(file)
    
    echo "Token $1" % [$i]
    echo " Text: $1" % [$spell]
    echo " Kind: $1" % [getTokenKindSpelling(kind)]
    
    echo " Location $1:$2:$3:$4" % [$filename, $line, $column, $offset]
    echo ""
    

proc getFilerange(tu: CXWTranslationUnit, filename: string): CXSourceRange =
  let file = getFile(tu, filename)
  var fileSize: int64 = -1
  fileSize = getFileSize(filename)
  doAssert fileSize > -1
  let topLoc = getLocationForOffset(tu,file,0)
  let lastLoc = getLocationForOffset(tu,file,fileSize.cuint)
  if exp.equalLocations(topLoc, getNullLocation()) or
     exp.equalLocations(lastLoc, getNullLocation()):
    echo "cannot retrieve locations"
    quit(-1)
  
  let srcRange = getRange(topLoc,lastLoc)
  if exp.isNull(srcRange):
    echo "cannot retrieve range"
    quit(-1)
  
  return srcRange 
  

proc main: int =
  if paramCount() < 1:
    echo "usage: Tokenize filename [options ...]"
    quit(-1)

  echo exp.getClangVersion()
  let allArgs = commandLineParams()
  var filename = allArgs[0]
  var args = allArgs[1..allArgs.high]
  #TODO: shouldn't need files, but cannot use default param 
  var files = newSeq[CXUnsavedFile](0)
  let index = exp.createIndex(1,1)
  let tu = exp.parseTranslationUnit(index,filename,args,files)
  
  let srcRange = getFilerange(tu,filename)
  var tokens = tokenize(tu,srcRange)
  showAllTokens(tu,tokens)
  
when isMainModule:
  let ret = main()
  GC_fullcollect() # try and induce a seg fault to test finalisers are running in correct order
  quit ret
