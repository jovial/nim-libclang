import "../utils"
import os
import streams
import libclang
import strutils
import unsigned


proc showSpell(cursor: CXCursor) =
  let spell = getCursorSpelling(cursor)
  echo "  Text: $1" % [$getCString(spell)]
  disposeString(spell)
  
proc showType(cursor: CXCursor) =
  assert isNull(cursor) == 0
  let typ = getCursorType(cursor)
  let typeName = getTypeSpelling(typ)
  let typeKind = typ.kind
  let typeKindName = getTypeKindSpelling(typeKind)
  echo "  Type: $1" % [$getCstring(typeName)]
  echo "  TypeKind: $1" % [$getCstring(typeKindName)]
  disposeString(typeName)
  disposeString(typeKindName)
  
proc showLinkage(cursor: CXCursor) =
  let linkage = getCursorLinkage(cursor)
  var linkageName: string
  case linkage:
  of CXLinkageKind.Invalid: linkageName = "Invalid"
  of CXLinkageKind.NoLinkage: linkageName = "NoLinkage"
  of CXLinkageKind.Internal: linkageName = "Internal"
  of CXLinkageKind.UniqueExternal: linkageName = "UniqueExternal"
  of CXLinkageKind.External: linkageName = "External"
  else: linkageName = "Unknown"
  
proc showParent(cursor: CXCursor, parent: CXCursor) =
  let semaParent = getCursorSemanticParent(cursor)
  let lexParent = getCursorLexicalParent(cursor)
  let parentName = getCursorSpelling(parent)
  let semaParentName = getCursorSpelling(semaParent)
  let lexParentName = getCursorSpelling(lexParent)
  echo "  Parent: parent:$1 semantic:$2 lexical:$3" % 
    [$getCstring(parentName), $getCString(semaParentName), $getCString(lexParentName)]
  disposeString(parentName)
  disposeString(semaParentName)
  disposeString(lexParentName)

proc showLocation(cursor: CXCursor) =
  let loc = getCursorLocation(cursor)
  var file: CXFile
  var line, column, offset: cuint
  getSpellingLocation(loc,file.addr,line.addr,column.addr,offset.addr)
  let fileName = getFileName(file)
  echo "  Location: $1:$2:$3:$4" % [$getCstring(filename), $line, $column, $offset]
  disposeString(fileName)

proc showCursorKind(cursor: CXCursor) =
  let curKind = getCursorKind(cursor)
  let curKindName = getCursorKindSpelling(curKind)
  var typ: string
  if isAttribute(curKind) != 0: typ = "Attribute"
  elif isDeclaration(curKind) != 0: typ = "Declaration"
  elif isExpression(curKind) != 0: typ = "Expression"
  elif isInvalid(curKind) != 0: typ = "Invalid"
  elif isPreProcessing(curKind) != 0: typ = "PreProcessing"
  elif isReference(curKind) != 0: typ = "Reference"
  elif isStatement(curKind) != 0: typ = "Statement"
  elif isTranslationUnit(curKind) != 0: typ = "TranslationUnit"
  elif isUnexposed(curKind) != 0: typ = "Unexposed"
  else: typ = "Unknown"
  
  echo "  CursorKind: $1" % [$getCString(curKindName)]
  echo "  CursorKindType $1" % [typ]
  disposeString(curKindName)  


proc showIncludedFile(cursor: CXCursor) =
  let included = getIncludedFile(cursor)
  if (included.pointer == nil): return
  let includedFileName = getFileName(included)
  echo "  included file: $1" % [$getCString(includedFileName)]
  disposeString(includedFileName)

proc showUsr(cursor: CXCursor) =
  let usr = getCursorUSR(cursor)
  echo "  USR: $1" % [$getCString(usr)]
  disposeString(usr)

proc visitChildrenCallback(cursor: CXCursor, parent: CXCursor, 
  clientData: CXClientData): CXChildVisitResult {.cdecl.} =
  let level = cast[ptr cuint](client_data)[]
  echo "  Level: $1" % [$level]
  showSpell(cursor)
  showLinkage(cursor)
  showCursorKind(cursor)
  showType(cursor)
  showParent(cursor, parent)
  showLocation(cursor)
  showUsr(cursor)
  showIncludedFile(cursor)
  echo ""
  
  var next = level + 1
  discard visitChildren(cursor,visitChildrenCallback,CXClientData(next.addr));
  return CXChildVisitResult.Continue
   
proc main: int =
  if paramCount() < 1:
    echo "usage: astvisitor filename"
    return -1

  stdout.newFileStream.writeClangVersion()
  let allArgs = commandLineParams()
  let filename = allArgs[0]
  let args = allocCStringArray(allArgs[1..allArgs.high])
  let paramCount = (allArgs.len -1).cint
  
  # create index w/ excludeDeclsFromPCH = 1, displayDiagnostics=1.
  let index = createIndex(1,1)
  let tu = createTranslationUnit(index,filename.cstring)
  if tu.pointer == nil:
    echo "cannot create translation unit"
    return 1
  
  var level: cuint = 0
  let cursor = getTranslationUnitCursor(tu)
  discard visitChildren(cursor,visitChildrenCallback, CXClientData(level.addr))
  
  disposeTranslationUnit(tu)
  disposeIndex(index)
  deallocCStringArray(args)
   
  
when isMainModule:
  quit main()
