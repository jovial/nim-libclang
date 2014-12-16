## Module status: unfinished, presume not working

import libclang
import utils
import unsigned
{.deadCodeElim: on.} # required as some procedures missing (at least on my version)

# TODOs
# - replace cstring in wrapped procedures
# - helper procedures for array access (template?)
# - check order order dependent stuff, eg clang_disposeTokens(tu,...)
#   must be called before clang_disposeTranslationUnit(tu)
# - getTranslationUnit returns a reference we may already have (there may be others) - double free (commented out for now)
# - some procedures should return a result instead of using an OUT param
# - make wrapper names consistent. Should wrappers holding arrays have Array in the name? i.e CXWPlatformAvailability, CXWCursor
# - get rid of var params when value not modified
# - convert openarray to seq so we can have default value?

type 
  CXWString* = ref object 
    data: CXString

proc finalizeCXString(a: CXWString) = 
  if isNil(a.data.data.pointer): 
    return 
  disposeString(a.data)

proc unWrap*(a: CXWString): CXString = 
  a.data

proc `$`*(a: CXWString): string =
  let cxstring = a.unwrap()
  $getCString(cxstring)

proc newCXWString*(data: CXString): CXWString = 
  new(result, finalizeCXString)
  result.data = data

proc `data`*(a: CXWString): type a.data.data {.inline.} = 
  a.data.data

proc `data =`*(a: CXWString; newVal: type a.data.data) {.inline.} = 
  a.data.data = newVal

proc `private_flags`*(a: CXWString): type a.data.private_flags {.inline.} = 
  a.data.private_flags

proc `private_flags =`*(a: CXWString; newVal: type a.data.private_flags) {.
    inline.} = 
  a.data.private_flags = newVal

type 
  CXWVirtualFileOverlay* = ref object 
    data: CXVirtualFileOverlay

proc finalizeCXVirtualFileOverlay(a: CXWVirtualFileOverlay) = 
  if isNil(a.data.pointer): 
    return 
  dispose(a.data)

proc unWrap*(a: CXWVirtualFileOverlay): CXVirtualFileOverlay = 
  a.data

proc newCXWVirtualFileOverlay*(data: CXVirtualFileOverlay): CXWVirtualFileOverlay = 
  new(result, finalizeCXVirtualFileOverlay)
  result.data = data

type 
  CXWModuleMapDescriptor* = ref object 
    data: CXModuleMapDescriptor

proc finalizeCXModuleMapDescriptor(a: CXWModuleMapDescriptor) = 
  if isNil(a.data.pointer): 
    return 
  dispose(a.data)

proc unWrap*(a: CXWModuleMapDescriptor): CXModuleMapDescriptor = 
  a.data

proc newCXWModuleMapDescriptor*(data: CXModuleMapDescriptor): CXWModuleMapDescriptor = 
  new(result, finalizeCXModuleMapDescriptor)
  result.data = data

#note: all translation units must be freed before we can free this
type 
  CXWIndex* = ref object 
    data: CXIndex

proc finalizeCXIndex(a: CXWIndex) = 
  if isNil(a.data.pointer): 
    return 
  disposeIndex(a.data)

proc unWrap*(a: CXWIndex): CXIndex = 
  a.data

proc newCXWIndex*(data: CXIndex): CXWIndex = 
  new(result, finalizeCXIndex)
  result.data = data


# must be kept alive until all translation units have been freed
type 
  CXWIndexAction* = ref object 
    data: CXIndexAction

proc finalizeCXIndexAction(a: CXWIndexAction) = 
  if isNil(a.data.pointer): 
    return 
  dispose(a.data)

proc unWrap*(a: CXWIndexAction): CXIndexAction = 
  a.data

proc newCXWIndexAction*(data: CXIndexAction): CXWIndexAction = 
  new(result, finalizeCXIndexAction)
  result.data = data


type 
  CXWTranslationUnit* = ref object 
    data: CXTranslationUnit
    index: CXWIndex # to keep it alive
    indexAction: CXWIndexAction

proc finalizeCXTranslationUnit(a: CXWTranslationUnit) = 
  if isNil(a.data.pointer): 
    return 
  disposeTranslationUnit(a.data)

proc unWrap*(a: CXWTranslationUnit): CXTranslationUnit = 
  a.data

proc newCXWTranslationUnit*(index: CXWIndex, indexAction: CXWIndexAction,data: CXTranslationUnit): CXWTranslationUnit = 
  ## You must supply a CXIndex, so that this translation doesn;t outlive it's index.
  new(result, finalizeCXTranslationUnit)
  result.data = data
  result.index = index
  result.indexAction = indexAction

type 
  CXWSourceRangeList* = ref object 
    data: ptr CXSourceRangeList

proc finalizeCXSourceRangeList(a: CXWSourceRangeList) = 
  if isNil(a.data.pointer): 
    return 
  disposeSourceRangeList(a.data)

proc unWrap*(a: CXWSourceRangeList): ptr CXSourceRangeList = 
  a.data

proc newCXWSourceRangeList*(data: ptr CXSourceRangeList): CXWSourceRangeList = 
  new(result, finalizeCXSourceRangeList)
  result.data = data

proc `count`*(a: CXWSourceRangeList): type a.data[].count {.inline.} = 
  a.data[].count

proc `count =`*(a: CXWSourceRangeList; newVal: type a.data[].count) {.
    inline.} = 
  a.data[].count = newVal

proc `ranges`*(a: CXWSourceRangeList): type a.data[].ranges {.inline.} = 
  a.data[].ranges

proc `ranges =`*(a: CXWSourceRangeList; newVal: type a.data[].ranges) {.
    inline.} = 
  a.data[].ranges = newVal

type 
  CXWDiagnostic* = ref object 
    data: CXDiagnostic

proc finalizeCXDiagnostic(a: CXWDiagnostic) = 
  if isNil(a.data.pointer): 
    return 
  disposeDiagnostic(a.data)

proc unWrap*(a: CXWDiagnostic): CXDiagnostic = 
  a.data

proc newCXWDiagnostic*(data: CXDiagnostic): CXWDiagnostic = 
  new(result, finalizeCXDiagnostic)
  result.data = data

type 
  CXWDiagnosticSet* = ref object 
    data: CXDiagnosticSet

proc finalizeCXDiagnosticSet(a: CXWDiagnosticSet) = 
  if isNil(a.data.pointer): 
    return 
  disposeDiagnosticSet(a.data)

proc unWrap*(a: CXWDiagnosticSet): CXDiagnosticSet = 
  a.data

proc newCXWDiagnosticSet*(data: CXDiagnosticSet): CXWDiagnosticSet = 
  new(result, finalizeCXDiagnosticSet)
  result.data = data

type 
  CXWTUResourceUsage* = ref object 
    data: CXTUResourceUsage

proc finalizeCXTUResourceUsage(a: CXWTUResourceUsage) = 
  if isNil(a.data.data.pointer): 
    return 
  disposeCXTUResourceUsage(a.data)

proc unWrap*(a: CXWTUResourceUsage): CXTUResourceUsage = 
  a.data

proc newCXWTUResourceUsage*(data: CXTUResourceUsage): CXWTUResourceUsage = 
  new(result, finalizeCXTUResourceUsage)
  result.data = data

proc `data`*(a: CXWTUResourceUsage): type a.data.data {.inline.} = 
  a.data.data

proc `data =`*(a: CXWTUResourceUsage; newVal: type a.data.data) {.inline.} = 
  a.data.data = newVal

proc `numEntries`*(a: CXWTUResourceUsage): type a.data.numEntries {.inline.} = 
  a.data.numEntries

proc `numEntries =`*(a: CXWTUResourceUsage; newVal: type a.data.numEntries) {.
    inline.} = 
  a.data.numEntries = newVal

proc `entries`*(a: CXWTUResourceUsage): type a.data.entries {.inline.} = 
  a.data.entries

proc `entries =`*(a: CXWTUResourceUsage; newVal: type a.data.entries) {.
    inline.} = 
  a.data.entries = newVal



#TODO: better name - foreign array / Cursors / CursorArray?   
type 
  CXWCursor* = ref object 
    data: ptr CXCursor
    size: cuint

proc unWrap*(a: CXWCursor): ptr CXCursor = 
  a.data

proc `kind`*(a: CXWCursor): type CXCursorKind {.inline.} = 
  a.unWrap()[].kind

proc `kind =`*(a: CXWCursor; newVal: CXCursorKind) {.inline.} = 
  a.unWrap()[].kind = newVal

proc `xdata`*(a: CXWCursor): cint {.inline.} = 
  a.unWrap()[].xdata

proc `xdata =`*(a: CXWCursor; newVal: cint) {.inline.} = 
  a.unWrap()[].xdata = newVal

proc `data`*(a: CXWCursor): array[3, pointer] {.inline.} = 
  a.unWrap()[].data

proc `data =`*(a: CXWCursor; newVal: array[3, pointer]) {.inline.} = 
  a.unWrap()[].data = newVal

proc finalizeCXCursor(a: CXWCursor) = 
  if isNil(a.data.pointer): 
    return 
  disposeOverriddenCursors(a.data)


proc newCXWCursor*(data: ptr CXCursor, len: cuint): CXWCursor = 
  new(result, finalizeCXCursor)
  result.data = data
  result.size = len

proc len*(a: CXWCursor): cuint =
  return a.size


proc toSeq*(a: CXWCursor): seq[CXCursor] =
  var temp = initCArray(a.data,a.len)
  result = newSeq[CXCursor](a.len.int)
  for i in 0.. <a.len.int:
    result[i] = temp[i]

converter CXCursorstoSeq(a: CXWCursor): seq[CXCursor] =
  toSeq(a)


type 
  CXWPlatformAvailability* = ref object 
    data: ptr CXPlatformAvailability
    size: cint
    model: seq[CXPlatformAvailability]

proc finalizeCXPlatformAvailability(a: CXWPlatformAvailability) = 
  if isNil(a.data.pointer): 
    return 
  disposeCXPlatformAvailability(a.data)

proc unWrap*(a: CXWPlatformAvailability): ptr CXPlatformAvailability = 
  a.data

proc newCXWPlatformAvailability*(data: ptr CXPlatformAvailability, len: cint): CXWPlatformAvailability = 
  new(result, finalizeCXPlatformAvailability)
  result.data = data
  result.size = len

proc newCXWPlatformAvailability*(len: cint): CXWPlatformAvailability = 
  new(result, finalizeCXPlatformAvailability)
  result.model = newSeq[CXPlatformAvailability](len)
  result.data = result.model[0].addr
  result.size = len

proc len*(a: CXWPlatformAvailability): cint =
  return a.size


proc `Platform`*(a: CXWPlatformAvailability): type a.data[].Platform {.
    inline.} = 
  a.data[].Platform

proc `Platform =`*(a: CXWPlatformAvailability; 
                   newVal: type a.data[].Platform) {.inline.} = 
  a.data[].Platform = newVal

proc `Introduced`*(a: CXWPlatformAvailability): type a.data[].Introduced {.
    inline.} = 
  a.data[].Introduced

proc `Introduced =`*(a: CXWPlatformAvailability; 
                     newVal: type a.data[].Introduced) {.inline.} = 
  a.data[].Introduced = newVal

proc `Deprecated`*(a: CXWPlatformAvailability): type a.data[].Deprecated {.
    inline.} = 
  a.data[].Deprecated

proc `Deprecated =`*(a: CXWPlatformAvailability; 
                     newVal: type a.data[].Deprecated) {.inline.} = 
  a.data[].Deprecated = newVal

proc `Obsoleted`*(a: CXWPlatformAvailability): type a.data[].Obsoleted {.
    inline.} = 
  a.data[].Obsoleted

proc `Obsoleted =`*(a: CXWPlatformAvailability; 
                    newVal: type a.data[].Obsoleted) {.inline.} = 
  a.data[].Obsoleted = newVal

proc `Unavailable`*(a: CXWPlatformAvailability): type a.data[].Unavailable {.
    inline.} = 
  a.data[].Unavailable

proc `Unavailable =`*(a: CXWPlatformAvailability; 
                      newVal: type a.data[].Unavailable) {.inline.} = 
  a.data[].Unavailable = newVal

proc `Message`*(a: CXWPlatformAvailability): type a.data[].Message {.
    inline.} = 
  a.data[].Message

proc `Message =`*(a: CXWPlatformAvailability; 
                  newVal: type a.data[].Message) {.inline.} = 
  a.data[].Message = newVal

type 
  CXWCursorSet* = ref object 
    data: CXCursorSet

proc finalizeCXCursorSet(a: CXWCursorSet) = 
  if isNil(a.data.pointer): 
    return 
  disposeCXCursorSet(a.data)

proc unWrap*(a: CXWCursorSet): CXCursorSet = 
  a.data

proc newCXWCursorSet*(data: CXCursorSet): CXWCursorSet = 
  new(result, finalizeCXCursorSet)
  result.data = data

#TODO: better name: CXWTokenArrayArray
type 
  CXWTokenArray* = ref object 
    data: ptr CXToken
    numTokens: cuint
    tu: CXWTranslationUnit

proc finalizeCXToken(a: CXWTokenArray) = 
  if isNil(a.data.pointer): 
    return 
  disposeTokens(a.tu.unwrap(),a.data,a.numTokens)

proc unWrap*(a: CXWTokenArray): ptr CXToken = 
  a.data

proc newCXWTokenArray*(tu: CXWTranslationUnit, data: ptr CXToken, numTokens: cuint): CXWTokenArray = 
  new(result, finalizeCXToken)
  result.data = data
  result.tu = tu
  result.numTokens = numTokens

proc len*(a: CXWTokenArray): cuint =
  return a.numTokens

proc toSeq*(a: CXWTokenArray): seq[CXToken] =
  var temp = initCArray(a.data,a.len)
  result = newSeq[CXToken](a.len.int)
  for i in 0.. <a.len.int:
    result[i] = temp[i]

converter CXWTokenArraytoSeq(a: CXWTokenArray): seq[CXToken] =
  toSeq(a)


type 
  CXWCodeCompleteResults* = ref object 
    data: ptr CXCodeCompleteResults

proc finalizeCXCodeCompleteResults(a: CXWCodeCompleteResults) = 
  if isNil(a.data.pointer): 
    return 
  disposeCodeCompleteResults(a.data)

proc unWrap*(a: CXWCodeCompleteResults): ptr CXCodeCompleteResults = 
  a.data

proc newCXWCodeCompleteResults*(data: ptr CXCodeCompleteResults): CXWCodeCompleteResults = 
  new(result, finalizeCXCodeCompleteResults)
  result.data = data

proc `Results`*(a: CXWCodeCompleteResults): type a.data[].Results {.inline.} = 
  a.data[].Results

proc `Results =`*(a: CXWCodeCompleteResults; newVal: type a.data[].Results) {.
    inline.} = 
  a.data[].Results = newVal

proc `NumResults`*(a: CXWCodeCompleteResults): type a.data[].NumResults {.
    inline.} = 
  a.data[].NumResults

proc `NumResults =`*(a: CXWCodeCompleteResults; 
                     newVal: type a.data[].NumResults) {.inline.} = 
  a.data[].NumResults = newVal

type 
  CXWRemapping* = ref object 
    data: CXRemapping

proc finalizeCXRemapping(a: CXWRemapping) = 
  if isNil(a.data.pointer): 
    return 
  dispose(a.data)

proc unWrap*(a: CXWRemapping): CXRemapping = 
  a.data

proc newCXWRemapping*(data: CXRemapping): CXWRemapping = 
  new(result, finalizeCXRemapping)
  result.data = data


proc getCString*(string: CXWString): string = 
  return $libclang.getCString(string.data)

proc createCXVirtualFileOverlay*(options: cuint): CXWVirtualFileOverlay = 
  return newCXWVirtualFileOverlay(libclang.createCXVirtualFileOverlay(
      options))

proc addFileMapping*(a2: CXWVirtualFileOverlay; virtualPath: cstring; 
                     realPath: cstring): CXErrorCode = 
  return libclang.addFileMapping(a2.data, virtualPath, realPath)

proc setCaseSensitivity*(a2: CXWVirtualFileOverlay; caseSensitive: cint): CXErrorCode = 
  return libclang.setCaseSensitivity(a2.data, caseSensitive)

proc writeToBuffer*(a2: CXWVirtualFileOverlay; options: cuint; 
                    out_buffer_ptr: cstringArray; out_buffer_size: var cuint): CXErrorCode = 
  return libclang.writeToBuffer(a2.data, options, out_buffer_ptr, 
                                addr(out_buffer_size))

proc createCXModuleMapDescriptor*(options: cuint): CXWModuleMapDescriptor = 
  return newCXWModuleMapDescriptor(
      libclang.createCXModuleMapDescriptor(options))

proc setFrameworkModuleName*(a2: CXWModuleMapDescriptor; name: cstring): CXErrorCode = 
  return libclang.setFrameworkModuleName(a2.data, name)

proc setUmbrellaHeader*(a2: CXWModuleMapDescriptor; name: cstring): CXErrorCode = 
  return libclang.setUmbrellaHeader(a2.data, name)

proc writeToBuffer*(a2: CXWModuleMapDescriptor; options: cuint; 
                    out_buffer_ptr: cstringArray; out_buffer_size: var cuint): CXErrorCode = 
  return libclang.writeToBuffer(a2.data, options, out_buffer_ptr, 
                                addr(out_buffer_size))

proc createIndex*(excludeDeclarationsFromPCH: cint; displayDiagnostics: cint): CXWIndex = 
  return newCXWIndex(libclang.createIndex(excludeDeclarationsFromPCH, 
      displayDiagnostics))

proc setGlobalOptions*(a2: CXWIndex; options: cuint) = 
  libclang.setGlobalOptions(a2.data, options)

proc getGlobalOptions*(a2: CXWIndex): cuint = 
  return libclang.getGlobalOptions(a2.data)

proc getFileName*(SFile: CXFile): CXWString = 
  return newCXWString(libclang.getFileName(SFile))

proc isFileMultipleIncludeGuarded*(tu: CXWTranslationUnit; file: CXFile): cuint = 
  return libclang.isFileMultipleIncludeGuarded(tu.data, file)

proc getFile*(tu: CXWTranslationUnit; file_name: cstring): CXFile = 
  return libclang.getFile(tu.data, file_name)

proc getLocation*(tu: CXWTranslationUnit; file: CXFile; line: cuint; 
                  column: cuint): CXSourceLocation = 
  return libclang.getLocation(tu.data, file, line, column)

proc getLocationForOffset*(tu: CXWTranslationUnit; file: CXFile; 
                           offset: cuint): CXSourceLocation = 
  return libclang.getLocationForOffset(tu.data, file, offset)

proc getPresumedLocation*(location: CXSourceLocation; filename: CXWString; 
                          line: var cuint; column: var cuint) = 
  libclang.getPresumedLocation(location, addr(filename.data), addr(line), 
                               addr(column))

proc getSkippedRanges*(tu: CXWTranslationUnit; file: CXFile): CXWSourceRangeList = 
  return newCXWSourceRangeList(libclang.getSkippedRanges(tu.data, file))

proc getNumDiagnosticsInSet*(Diags: CXWDiagnosticSet): cuint = 
  return libclang.getNumDiagnosticsInSet(Diags.data)

proc getDiagnosticInSet*(Diags: CXWDiagnosticSet; Index: cuint): CXWDiagnostic = 
  return newCXWDiagnostic(libclang.getDiagnosticInSet(Diags.data, Index))

proc loadDiagnostics*(file: cstring; error: var CXLoadDiag_Error; 
                      errorString: CXWString): CXWDiagnosticSet = 
  return newCXWDiagnosticSet(libclang.loadDiagnostics(file, addr(error), 
      addr(errorString.data)))

proc getChildDiagnostics*(D: CXWDiagnostic): CXWDiagnosticSet = 
  return newCXWDiagnosticSet(libclang.getChildDiagnostics(D.data))

proc getNumDiagnostics*(Unit: CXWTranslationUnit): cuint = 
  return libclang.getNumDiagnostics(Unit.data)

proc getDiagnostic*(Unit: CXWTranslationUnit; Index: cuint): CXWDiagnostic = 
  return newCXWDiagnostic(libclang.getDiagnostic(Unit.data, Index))

proc getDiagnosticSetFromTU*(Unit: CXWTranslationUnit): CXWDiagnosticSet = 
  return newCXWDiagnosticSet(libclang.getDiagnosticSetFromTU(Unit.data))

proc formatDiagnostic*(Diagnostic: CXWDiagnostic; Options: cuint): CXWString = 
  return newCXWString(libclang.formatDiagnostic(Diagnostic.data, Options))

proc getDiagnosticSeverity*(a2: CXWDiagnostic): CXDiagnosticSeverity = 
  return libclang.getDiagnosticSeverity(a2.data)

proc getDiagnosticLocation*(a2: CXWDiagnostic): CXSourceLocation = 
  return libclang.getDiagnosticLocation(a2.data)

proc getDiagnosticSpelling*(a2: CXWDiagnostic): CXWString = 
  return newCXWString(libclang.getDiagnosticSpelling(a2.data))

proc getDiagnosticOption*(Diag: CXWDiagnostic; Disable: CXWString): CXWString = 
  return newCXWString(libclang.getDiagnosticOption(Diag.data, 
      addr(Disable.data)))

proc getDiagnosticCategory*(a2: CXWDiagnostic): cuint = 
  return libclang.getDiagnosticCategory(a2.data)

proc getDiagnosticCategoryName*(Category: cuint): CXWString = 
  return newCXWString(libclang.getDiagnosticCategoryName(Category))

proc getDiagnosticCategoryText*(a2: CXWDiagnostic): CXWString = 
  return newCXWString(libclang.getDiagnosticCategoryText(a2.data))

proc getDiagnosticNumRanges*(a2: CXWDiagnostic): cuint = 
  return libclang.getDiagnosticNumRanges(a2.data)

proc getDiagnosticRange*(Diagnostic: CXWDiagnostic; Range: cuint): CXSourceRange = 
  return libclang.getDiagnosticRange(Diagnostic.data, Range)

proc getDiagnosticNumFixIts*(Diagnostic: CXWDiagnostic): cuint = 
  return libclang.getDiagnosticNumFixIts(Diagnostic.data)

proc getDiagnosticFixIt*(Diagnostic: CXWDiagnostic; FixIt: cuint; 
                         ReplacementRange: var CXSourceRange): CXWString = 
  return newCXWString(libclang.getDiagnosticFixIt(Diagnostic.data, FixIt, 
      addr(ReplacementRange)))

proc getTranslationUnitSpelling*(CTUnit: CXWTranslationUnit): CXWString = 
  return newCXWString(libclang.getTranslationUnitSpelling(CTUnit.data))

proc createTranslationUnitFromSourceFile*(CIdx: CXWIndex; 
    source_filename: string; 
    command_line_args: openarray[string];  
    unsaved_files: var openarray[CXUnsavedFile]): CXWTranslationUnit = 
  var num_unsaved_files: cuint = unsaved_files.len.cuint
  var cmd_line = allocCstringArray(command_line_args)
  var num_command_line_args: cint = command_line_args.len.cint
  result = newCXWTranslationUnit(CIdx, nil, libclang.createTranslationUnitFromSourceFile(
      CIdx.data, source_filename, num_command_line_args, 
      cmd_line, num_unsaved_files, addr(unsaved_files[0])))
  deallocCStringArray(cmd_line)

proc createTranslationUnit*(CIdx: CXWIndex; ast_filename: string): CXWTranslationUnit = 
  return newCXWTranslationUnit(CIDx, nil, libclang.createTranslationUnit(CIdx.data, 
      ast_filename))

proc createTranslationUnit2*(CIdx: CXWIndex; ast_filename: string; 
                             out_TU: CXWTranslationUnit): CXErrorCode = 
  return libclang.createTranslationUnit2(CIdx.data, ast_filename, 
      addr(out_TU.data))

proc parseTranslationUnit*(CIdx: CXWIndex; source_filename: string; 
                           command_line_args: openarray[string]; 
                           unsaved_files: var openarray[CXUnsavedFile] = newSeq[CXUnsavedFile](0); 
                           options: cuint = 0): CXWTranslationUnit =
  var num_unsaved_files: cuint = unsaved_files.len.cuint
  var cmd_line = allocCstringArray(command_line_args)
  var num_command_line_args: cint = command_line_args.len.cint
  var files_ptr = if unsaved_files.len > 0: addr(unsaved_files[0]) else: nil 
  result = newCXWTranslationUnit(CIdx, nil,libclang.parseTranslationUnit(CIdx.data, 
      source_filename, cmd_line, num_command_line_args, 
      files_ptr, num_unsaved_files, options))
  if result.unWrap.pointer == nil:
    raise newException(ValueError, "cannot parse translation unit")
  deallocCStringArray(cmd_line)

proc parseTranslationUnit2*(CIdx: CXWIndex; source_filename: string; 
                            command_line_args: openarray[string]; 
                            unsaved_files: var openarray[CXUnsavedFile]; 
                            options: cuint; 
                            out_TU: CXWTranslationUnit): CXErrorCode = 
  var num_unsaved_files: cuint = unsaved_files.len.cuint
  var cmd_line = allocCstringArray(command_line_args)
  var num_command_line_args: cint = command_line_args.len.cint
  result = libclang.parseTranslationUnit2(CIdx.data, source_filename, 
                                        cmd_line, 
                                        num_command_line_args, 
                                        addr(unsaved_files[0]), num_unsaved_files, 
                                        options, addr(out_TU.data))
  deallocCStringArray(cmd_line)

proc defaultSaveOptions*(TU: CXWTranslationUnit): cuint = 
  return libclang.defaultSaveOptions(TU.data)

proc saveTranslationUnit*(TU: CXWTranslationUnit; FileName: cstring; 
                          options: cuint): cint = 
  return libclang.saveTranslationUnit(TU.data, FileName, options)

proc defaultReparseOptions*(TU: CXWTranslationUnit): cuint = 
  return libclang.defaultReparseOptions(TU.data)

proc reparseTranslationUnit*(TU: CXWTranslationUnit; 
                             unsaved_files: var openarray[CXUnsavedFile]; options: cuint): cint = 
  var num_unsaved_files: cuint = unsaved_files.len.cuint
  return libclang.reparseTranslationUnit(TU.data, num_unsaved_files, 
      addr(unsaved_files[0]), options)

proc getCXTUResourceUsage*(TU: CXWTranslationUnit): CXWTUResourceUsage = 
  return newCXWTUResourceUsage(libclang.getCXTUResourceUsage(TU.data))

proc getTranslationUnitCursor*(a2: CXWTranslationUnit): CXCursor = 
  return libclang.getTranslationUnitCursor(a2.data)

proc getCursorPlatformAvailability*(cursor: CXCursor; 
                                    always_deprecated: var cint; 
                                    deprecated_message: CXWString; 
                                    always_unavailable: var cint; 
                                    unavailable_message: CXWString; 
    availability: CXWPlatformAvailability): cint = 
  let availability_size:cint = availability.len
  return libclang.getCursorPlatformAvailability(cursor, addr(always_deprecated), 
      addr(deprecated_message.data), addr(always_unavailable), 
      addr(unavailable_message.data), availability.data, availability_size)

#FIXME: this probably returns a reference that we already have?!
#proc getTranslationUnit*(a2: CXCursor): CXWTranslationUnit =
#  return newCXWTranslationUnit(nil, nil,libclang.getTranslationUnit(a2))


proc createCXCursorSet*(): CXWCursorSet = 
  return newCXWCursorSet(libclang.createCXCursorSet())

proc contains*(cset: CXWCursorSet; cursor: CXCursor): cuint = 
  return libclang.contains(cset.data, cursor)

proc insert*(cset: CXWCursorSet; cursor: CXCursor): cuint = 
  return libclang.insert(cset.data, cursor)

proc getCursor*(a2: CXWTranslationUnit; a3: CXSourceLocation): CXCursor = 
  return libclang.getCursor(a2.data, a3)

proc getTypeSpelling*(CT: CXType): CXWString = 
  return newCXWString(libclang.getTypeSpelling(CT))

proc getDeclObjCTypeEncoding*(C: CXCursor): CXWString = 
  return newCXWString(libclang.getDeclObjCTypeEncoding(C))

proc getTypeKindSpelling*(K: CXTypeKind): CXWString = 
  return newCXWString(libclang.getTypeKindSpelling(K))

proc getCursorUSR*(a2: CXCursor): CXWString = 
  return newCXWString(libclang.getCursorUSR(a2))

proc objCClass*(class_name: cstring): CXWString = 
  return newCXWString(libclang.objCClass(class_name))

proc objCCategory*(class_name: cstring; category_name: cstring): CXWString = 
  return newCXWString(libclang.objCCategory(class_name, category_name))

proc objCProtocol*(protocol_name: cstring): CXWString = 
  return newCXWString(libclang.objCProtocol(protocol_name))

proc objCIvar*(name: cstring; classUSR: CXWString): CXWString = 
  return newCXWString(libclang.objCIvar(name, classUSR.data))

proc objCMethod*(name: cstring; isInstanceMethod: cuint; 
                 classUSR: CXWString): CXWString = 
  return newCXWString(libclang.objCMethod(name, isInstanceMethod, 
      classUSR.data))

proc objCProperty*(property: cstring; classUSR: CXWString): CXWString = 
  return newCXWString(libclang.objCProperty(property, classUSR.data))

proc getCursorSpelling*(a2: CXCursor): CXWString = 
  return newCXWString(libclang.getCursorSpelling(a2))

proc getCursorDisplayName*(a2: CXCursor): CXWString = 
  return newCXWString(libclang.getCursorDisplayName(a2))

proc getRawCommentText*(C: CXCursor): CXWString = 
  return newCXWString(libclang.getRawCommentText(C))

proc getBriefCommentText*(C: CXCursor): CXWString = 
  return newCXWString(libclang.getBriefCommentText(C))

proc getMangling*(a2: CXCursor): CXWString = 
  return newCXWString(libclang.getMangling(a2))

proc getModuleForFile*(a2: CXWTranslationUnit; a3: CXFile): CXModule = 
  return libclang.getModuleForFile(a2.data, a3)

proc getName*(Module: CXModule): CXWString = 
  return newCXWString(libclang.getName(Module))

proc getFullName*(Module: CXModule): CXWString = 
  return newCXWString(libclang.getFullName(Module))

proc getNumTopLevelHeaders*(a2: CXWTranslationUnit; Module: CXModule): cuint = 
  return libclang.getNumTopLevelHeaders(a2.data, Module)

proc getTopLevelHeader*(a2: CXWTranslationUnit; Module: CXModule; 
                        Index: cuint): CXFile = 
  return libclang.getTopLevelHeader(a2.data, Module, Index)


proc getTokenSpelling*(a2: CXWTranslationUnit; a3: CXToken): CXWString = 
  return newCXWString(libclang.getTokenSpelling(a2.data, a3))

proc getTokenLocation*(a2: CXWTranslationUnit; a3: CXToken): CXSourceLocation = 
  return libclang.getTokenLocation(a2.data, a3)

proc getTokenExtent*(a2: CXWTranslationUnit; a3: CXToken): CXSourceRange = 
  return libclang.getTokenExtent(a2.data, a3)

proc tokenize*(TU: CXWTranslationUnit; Range: CXSourceRange): CXWTokenArray = 
  result = newCXWTokenArray(TU, nil, 0)
  libclang.tokenize(TU.data, Range, addr(result.data), addr(result.numTokens))

proc annotateTokens*(Tokens: CXWTokenArray): seq[CXCursor] =
  result = newSeq[CXCursor](Tokens.numTokens.int)
  libclang.annotateTokens(Tokens.tu.data, Tokens.data, Tokens.numTokens, 
                          result[0].addr)

proc getCursorKindSpelling*(Kind: CXCursorKind): CXWString = 
  return newCXWString(libclang.getCursorKindSpelling(Kind))

proc getCompletionChunkText*(completion_string: CXCompletionString; 
                             chunk_number: cuint): CXWString = 
  return newCXWString(libclang.getCompletionChunkText(completion_string, 
      chunk_number))

proc getCompletionAnnotation*(completion_string: CXCompletionString; 
                              annotation_number: cuint): CXWString = 
  return newCXWString(libclang.getCompletionAnnotation(completion_string, 
      annotation_number))

proc getCompletionParent*(completion_string: CXCompletionString): CXWString =
  # kind is deprecated, always pass nil 
  return newCXWString(libclang.getCompletionParent(completion_string, 
      nil))

proc getCompletionBriefComment*(completion_string: CXCompletionString): CXWString = 
  return newCXWString(libclang.getCompletionBriefComment(completion_string))

proc codeCompleteAt*(TU: CXWTranslationUnit; complete_filename: cstring; 
                     complete_line: cuint; complete_column: cuint; 
                     unsaved_files: var openarray[CXUnsavedFile];  
                     options: cuint): CXWCodeCompleteResults = 
  var num_unsaved_files: cuint = unsaved_files.len.cuint
  return newCXWCodeCompleteResults(libclang.codeCompleteAt(TU.data, 
      complete_filename, complete_line, complete_column, addr(unsaved_files[0]), 
      num_unsaved_files, options))

proc codeCompleteGetNumDiagnostics*(Results: CXWCodeCompleteResults): cuint = 
  return libclang.codeCompleteGetNumDiagnostics(Results.data)

proc codeCompleteGetDiagnostic*(Results: CXWCodeCompleteResults; 
                                Index: cuint): CXWDiagnostic = 
  return newCXWDiagnostic(libclang.codeCompleteGetDiagnostic(
      Results.data, Index))

proc codeCompleteGetContexts*(Results: CXWCodeCompleteResults): culonglong = 
  return libclang.codeCompleteGetContexts(Results.data)

proc codeCompleteGetContainerKind*(Results: CXWCodeCompleteResults; 
                                   IsIncomplete: var cuint): CXCursorKind = 
  return libclang.codeCompleteGetContainerKind(Results.data, 
      addr(IsIncomplete))

proc codeCompleteGetContainerUSR*(Results: CXWCodeCompleteResults): CXWString = 
  return newCXWString(libclang.codeCompleteGetContainerUSR(
      Results.data))

proc codeCompleteGetObjCSelector*(Results: CXWCodeCompleteResults): CXWString = 
  return newCXWString(libclang.codeCompleteGetObjCSelector(
      Results.data))

proc getClangVersion*(): CXWString = 
  return newCXWString(libclang.getClangVersion())

proc getInclusions*(tu: CXWTranslationUnit; visitor: CXInclusionVisitor; 
                    client_data: CXClientData) = 
  libclang.getInclusions(tu.data, visitor, client_data)

proc getRemappings*(path: string): CXWRemapping = 
  return newCXWRemapping(libclang.getRemappings(path))

proc getRemappingsFromFileList*(filePaths: cstringArray; numFiles: cuint): CXWRemapping = 
  return newCXWRemapping(libclang.getRemappingsFromFileList(filePaths, 
      numFiles))

proc getNumFiles*(a2: CXWRemapping): cuint = 
  return libclang.getNumFiles(a2.data)

proc getFilenames*(a2: CXWRemapping; index: cuint; 
                   original: CXWString; transformed: CXWString) = 
  libclang.getFilenames(a2.data, index, addr(original.data), 
                        addr(transformed.data))

proc findIncludesInFile*(TU: CXWTranslationUnit; file: CXFile; 
                         visitor: CXCursorAndRangeVisitor): CXResult = 
  return libclang.findIncludesInFile(TU.data, file, visitor)

proc createIndexAction*(CIdx: CXWIndex): CXWIndexAction = 
  return newCXWIndexAction(libclang.createIndexAction(CIdx.data))

proc indexSourceFile*(a2: CXWIndexAction; client_data: CXClientData; 
                      index_callbacks: var openarray[IndexerCallbacks]; 
                      index_options: cuint; 
                      source_filename: string; command_line_args: openarray[string]; 
                      unsaved_files: var openarray[CXUnsavedFile]; 
                      TU_options: cuint): CXWTranslationUnit =
  var temp: CXTranslationUnit 
  var cmd_line = allocCstringArray(command_line_args)
  var index_callbacks_size = index_callbacks.len.cuint
  var num_unsaved_files: cuint = unsaved_files.len.cuint
  let retval = libclang.indexSourceFile(a2.data, client_data, addr(index_callbacks[0]), 
                                  index_callbacks_size, index_options, 
                                  source_filename, cmd_line, 
                                  command_line_args.len.cint, addr(unsaved_files[0]), 
                                  num_unsaved_files, addr(temp), 
                                  TU_options)
  deallocCStringArray(cmd_line)
  if retval != 0:
    raise newException(ValueError, "compiler could not index source file without unrecoverable errors")
  result = newCXWTranslationUnit(nil, a2, temp)

proc indexTranslationUnit*[T](a2: CXWIndexAction; client_data: ptr T; 
                           index_callbacks: var openarray[IndexerCallbacks]; 
                           index_options: cuint; 
                           a7: CXWTranslationUnit) = 
  var index_callbacks_size = index_callbacks.len.cuint
  var client_data_raw = client_data.CXClientData
  let retVal = libclang.indexTranslationUnit(a2.data, client_data_raw, 
                                       addr(index_callbacks[0]), 
                                       index_callbacks_size, index_options, 
                                       a7.data)
  if retval != 0:
    raise newException(ValueError, "compiler could not index translation unit without unrecoverable errors")


proc getOverriddenCursors*(cursor: CXCursor): CXWCursor =
  var num_overridden: cuint
  var overriden: ptr CXCursor
  libclang.getOverriddenCursors(cursor, overriden.addr, 
                                addr(num_overridden))
  result = newCXWCursor(overriden,num_overridden)
  
  
##### start not wrapped, but return value changed #####

proc equalLocations*(loc1: CXSourceLocation; loc2: CXSourceLocation): bool =
  result = libclang.equalLocations(loc1,loc2) != 0

proc isNull*(range: CXSourceRange): bool =
  result = libclang.isNull(range) != 0  
  

when isMainModule:
  echo getClangVersion()
  
