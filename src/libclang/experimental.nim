## Module status: unfinished, presume not working

import libclang
import utils
import unsigned
{.deadCodeElim: on.} # required as some procedures missing (at least on my version)

# TODOs
# - replace cstring in wrapped procedures
# - helper procedures for array access
# - fix order order dependent stuff, eg clang_disposeTokens(tu,...)
#   must be called before clang_disposeTranslationUnit(tu)
# - getTranslationUnit returns a reference we may already have (there may be others) - double free
# - some procedures should return a result instead of using an OUT param
# - reduce length of object names. One possibility is CXStringWrapper -> CXWString


type 
  CXStringWrapper* = ref object 
    data: CXString

proc finalizeCXString(a: CXStringWrapper) = 
  if isNil(a.data.data.pointer): 
    return 
  disposeString(a.data)

proc unWrap*(a: CXStringWrapper): CXString = 
  a.data

proc `$`(a: CXStringWrapper): string =
  let cxstring = a.unwrap()
  $getCString(cxstring)

proc newCXStringWrapper*(data: CXString): CXStringWrapper = 
  new(result, finalizeCXString)
  result.data = data

proc `data`*(a: CXStringWrapper): type a.data.data {.inline.} = 
  a.data.data

proc `data =`*(a: CXStringWrapper; newVal: type a.data.data) {.inline.} = 
  a.data.data = newVal

proc `private_flags`*(a: CXStringWrapper): type a.data.private_flags {.inline.} = 
  a.data.private_flags

proc `private_flags =`*(a: CXStringWrapper; newVal: type a.data.private_flags) {.
    inline.} = 
  a.data.private_flags = newVal

type 
  CXVirtualFileOverlayWrapper* = ref object 
    data: CXVirtualFileOverlay

proc finalizeCXVirtualFileOverlay(a: CXVirtualFileOverlayWrapper) = 
  if isNil(a.data.pointer): 
    return 
  dispose(a.data)

proc unWrap*(a: CXVirtualFileOverlayWrapper): CXVirtualFileOverlay = 
  a.data

proc newCXVirtualFileOverlayWrapper*(data: CXVirtualFileOverlay): CXVirtualFileOverlayWrapper = 
  new(result, finalizeCXVirtualFileOverlay)
  result.data = data

type 
  CXModuleMapDescriptorWrapper* = ref object 
    data: CXModuleMapDescriptor

proc finalizeCXModuleMapDescriptor(a: CXModuleMapDescriptorWrapper) = 
  if isNil(a.data.pointer): 
    return 
  dispose(a.data)

proc unWrap*(a: CXModuleMapDescriptorWrapper): CXModuleMapDescriptor = 
  a.data

proc newCXModuleMapDescriptorWrapper*(data: CXModuleMapDescriptor): CXModuleMapDescriptorWrapper = 
  new(result, finalizeCXModuleMapDescriptor)
  result.data = data

#note: all translation units must be freed before we can free this
type 
  CXIndexWrapper* = ref object 
    data: CXIndex

proc finalizeCXIndex(a: CXIndexWrapper) = 
  if isNil(a.data.pointer): 
    return 
  disposeIndex(a.data)

proc unWrap*(a: CXIndexWrapper): CXIndex = 
  a.data

proc newCXIndexWrapper*(data: CXIndex): CXIndexWrapper = 
  new(result, finalizeCXIndex)
  result.data = data


# must be kept alive until all translation units have been freed
type 
  CXIndexActionWrapper* = ref object 
    data: CXIndexAction

proc finalizeCXIndexAction(a: CXIndexActionWrapper) = 
  if isNil(a.data.pointer): 
    return 
  dispose(a.data)

proc unWrap*(a: CXIndexActionWrapper): CXIndexAction = 
  a.data

proc newCXIndexActionWrapper*(data: CXIndexAction): CXIndexActionWrapper = 
  new(result, finalizeCXIndexAction)
  result.data = data


type 
  CXTranslationUnitWrapper* = ref object 
    data: CXTranslationUnit
    index: CXIndexWrapper # to keep it alive
    indexAction: CXIndexActionWrapper

proc finalizeCXTranslationUnit(a: CXTranslationUnitWrapper) = 
  if isNil(a.data.pointer): 
    return 
  disposeTranslationUnit(a.data)

proc unWrap*(a: CXTranslationUnitWrapper): CXTranslationUnit = 
  a.data

proc newCXTranslationUnitWrapper*(index: CXIndexWrapper, indexAction: CXIndexActionWrapper,data: CXTranslationUnit): CXTranslationUnitWrapper = 
  ## You must supply a CXIndex, so that this translation doesn;t outlive it's index.
  new(result, finalizeCXTranslationUnit)
  result.data = data
  result.index = index
  result.indexAction = indexAction

type 
  CXSourceRangeListWrapper* = ref object 
    data: ptr CXSourceRangeList

proc finalizeCXSourceRangeList(a: CXSourceRangeListWrapper) = 
  if isNil(a.data.pointer): 
    return 
  disposeSourceRangeList(a.data)

proc unWrap*(a: CXSourceRangeListWrapper): ptr CXSourceRangeList = 
  a.data

proc newCXSourceRangeListWrapper*(data: ptr CXSourceRangeList): CXSourceRangeListWrapper = 
  new(result, finalizeCXSourceRangeList)
  result.data = data

proc `count`*(a: CXSourceRangeListWrapper): type a.data[].count {.inline.} = 
  a.data[].count

proc `count =`*(a: CXSourceRangeListWrapper; newVal: type a.data[].count) {.
    inline.} = 
  a.data[].count = newVal

proc `ranges`*(a: CXSourceRangeListWrapper): type a.data[].ranges {.inline.} = 
  a.data[].ranges

proc `ranges =`*(a: CXSourceRangeListWrapper; newVal: type a.data[].ranges) {.
    inline.} = 
  a.data[].ranges = newVal

type 
  CXDiagnosticWrapper* = ref object 
    data: CXDiagnostic

proc finalizeCXDiagnostic(a: CXDiagnosticWrapper) = 
  if isNil(a.data.pointer): 
    return 
  disposeDiagnostic(a.data)

proc unWrap*(a: CXDiagnosticWrapper): CXDiagnostic = 
  a.data

proc newCXDiagnosticWrapper*(data: CXDiagnostic): CXDiagnosticWrapper = 
  new(result, finalizeCXDiagnostic)
  result.data = data

type 
  CXDiagnosticSetWrapper* = ref object 
    data: CXDiagnosticSet

proc finalizeCXDiagnosticSet(a: CXDiagnosticSetWrapper) = 
  if isNil(a.data.pointer): 
    return 
  disposeDiagnosticSet(a.data)

proc unWrap*(a: CXDiagnosticSetWrapper): CXDiagnosticSet = 
  a.data

proc newCXDiagnosticSetWrapper*(data: CXDiagnosticSet): CXDiagnosticSetWrapper = 
  new(result, finalizeCXDiagnosticSet)
  result.data = data

type 
  CXTUResourceUsageWrapper* = ref object 
    data: CXTUResourceUsage

proc finalizeCXTUResourceUsage(a: CXTUResourceUsageWrapper) = 
  if isNil(a.data.data.pointer): 
    return 
  disposeCXTUResourceUsage(a.data)

proc unWrap*(a: CXTUResourceUsageWrapper): CXTUResourceUsage = 
  a.data

proc newCXTUResourceUsageWrapper*(data: CXTUResourceUsage): CXTUResourceUsageWrapper = 
  new(result, finalizeCXTUResourceUsage)
  result.data = data

proc `data`*(a: CXTUResourceUsageWrapper): type a.data.data {.inline.} = 
  a.data.data

proc `data =`*(a: CXTUResourceUsageWrapper; newVal: type a.data.data) {.inline.} = 
  a.data.data = newVal

proc `numEntries`*(a: CXTUResourceUsageWrapper): type a.data.numEntries {.inline.} = 
  a.data.numEntries

proc `numEntries =`*(a: CXTUResourceUsageWrapper; newVal: type a.data.numEntries) {.
    inline.} = 
  a.data.numEntries = newVal

proc `entries`*(a: CXTUResourceUsageWrapper): type a.data.entries {.inline.} = 
  a.data.entries

proc `entries =`*(a: CXTUResourceUsageWrapper; newVal: type a.data.entries) {.
    inline.} = 
  a.data.entries = newVal



#TODO: better name - foreign array / Cursors / CursorArray?   
type 
  CXCursorWrapper* = ref object 
    data: ptr CXCursor
    size: cuint

proc unWrap*(a: CXCursorWrapper): ptr CXCursor = 
  a.data

proc `kind`*(a: CXCursorWrapper): type CXCursorKind {.inline.} = 
  a.unWrap()[].kind

proc `kind =`*(a: CXCursorWrapper; newVal: CXCursorKind) {.inline.} = 
  a.unWrap()[].kind = newVal

proc `xdata`*(a: CXCursorWrapper): cint {.inline.} = 
  a.unWrap()[].xdata

proc `xdata =`*(a: CXCursorWrapper; newVal: cint) {.inline.} = 
  a.unWrap()[].xdata = newVal

proc `data`*(a: CXCursorWrapper): array[3, pointer] {.inline.} = 
  a.unWrap()[].data

proc `data =`*(a: CXCursorWrapper; newVal: array[3, pointer]) {.inline.} = 
  a.unWrap()[].data = newVal

proc finalizeCXCursor(a: CXCursorWrapper) = 
  if isNil(a.data.pointer): 
    return 
  disposeOverriddenCursors(a.data)


proc newCXCursorWrapper*(data: ptr CXCursor, len: cuint): CXCursorWrapper = 
  new(result, finalizeCXCursor)
  result.data = data
  result.size = len

proc len*(a: CXCursorWrapper): cuint =
  return a.size


proc toSeq*(a: CXCursorWrapper): seq[CXCursor] =
  var temp = initCArray(a.data,a.len)
  result = newSeq[CXCursor](a.len.int)
  for i in 0.. a.len.int:
    result[i] = temp[i]

converter CXCursorstoSeq(a: CXCursorWrapper): seq[CXCursor] =
  toSeq(a)


type 
  CXPlatformAvailabilityWrapper* = ref object 
    data: ptr CXPlatformAvailability
    size: cint
    model: seq[CXPlatformAvailability]

proc finalizeCXPlatformAvailability(a: CXPlatformAvailabilityWrapper) = 
  if isNil(a.data.pointer): 
    return 
  disposeCXPlatformAvailability(a.data)

proc unWrap*(a: CXPlatformAvailabilityWrapper): ptr CXPlatformAvailability = 
  a.data

proc newCXPlatformAvailabilityWrapper*(data: ptr CXPlatformAvailability, len: cint): CXPlatformAvailabilityWrapper = 
  new(result, finalizeCXPlatformAvailability)
  result.data = data
  result.size = len

proc newCXPlatformAvailabilityWrapper*(len: cint): CXPlatformAvailabilityWrapper = 
  new(result, finalizeCXPlatformAvailability)
  result.model = newSeq[CXPlatformAvailability](len)
  result.data = result.model[0].addr
  result.size = len

proc len*(a: CXPlatformAvailabilityWrapper): cint =
  return a.size


proc `Platform`*(a: CXPlatformAvailabilityWrapper): type a.data[].Platform {.
    inline.} = 
  a.data[].Platform

proc `Platform =`*(a: CXPlatformAvailabilityWrapper; 
                   newVal: type a.data[].Platform) {.inline.} = 
  a.data[].Platform = newVal

proc `Introduced`*(a: CXPlatformAvailabilityWrapper): type a.data[].Introduced {.
    inline.} = 
  a.data[].Introduced

proc `Introduced =`*(a: CXPlatformAvailabilityWrapper; 
                     newVal: type a.data[].Introduced) {.inline.} = 
  a.data[].Introduced = newVal

proc `Deprecated`*(a: CXPlatformAvailabilityWrapper): type a.data[].Deprecated {.
    inline.} = 
  a.data[].Deprecated

proc `Deprecated =`*(a: CXPlatformAvailabilityWrapper; 
                     newVal: type a.data[].Deprecated) {.inline.} = 
  a.data[].Deprecated = newVal

proc `Obsoleted`*(a: CXPlatformAvailabilityWrapper): type a.data[].Obsoleted {.
    inline.} = 
  a.data[].Obsoleted

proc `Obsoleted =`*(a: CXPlatformAvailabilityWrapper; 
                    newVal: type a.data[].Obsoleted) {.inline.} = 
  a.data[].Obsoleted = newVal

proc `Unavailable`*(a: CXPlatformAvailabilityWrapper): type a.data[].Unavailable {.
    inline.} = 
  a.data[].Unavailable

proc `Unavailable =`*(a: CXPlatformAvailabilityWrapper; 
                      newVal: type a.data[].Unavailable) {.inline.} = 
  a.data[].Unavailable = newVal

proc `Message`*(a: CXPlatformAvailabilityWrapper): type a.data[].Message {.
    inline.} = 
  a.data[].Message

proc `Message =`*(a: CXPlatformAvailabilityWrapper; 
                  newVal: type a.data[].Message) {.inline.} = 
  a.data[].Message = newVal

type 
  CXCursorSetWrapper* = ref object 
    data: CXCursorSet

proc finalizeCXCursorSet(a: CXCursorSetWrapper) = 
  if isNil(a.data.pointer): 
    return 
  disposeCXCursorSet(a.data)

proc unWrap*(a: CXCursorSetWrapper): CXCursorSet = 
  a.data

proc newCXCursorSetWrapper*(data: CXCursorSet): CXCursorSetWrapper = 
  new(result, finalizeCXCursorSet)
  result.data = data

type 
  CXTokenWrapper* = ref object 
    data: ptr CXToken
    numTokens: cuint
    tu: CXTranslationUnitWrapper

proc finalizeCXToken(a: CXTokenWrapper) = 
  if isNil(a.data.pointer): 
    return 
  disposeTokens(a.tu.unwrap(),a.data,a.numTokens)

proc unWrap*(a: CXTokenWrapper): ptr CXToken = 
  a.data

proc newCXTokenWrapper*(tu: CXTranslationUnitWrapper, data: ptr CXToken, numTokens: cuint): CXTokenWrapper = 
  new(result, finalizeCXToken)
  result.data = data
  result.tu = tu
  result.numTokens = numTokens

proc `int_data`*(a: CXTokenWrapper): type a.data[].int_data {.inline.} = 
  a.data[].int_data

proc `int_data =`*(a: CXTokenWrapper; newVal: type a.data[].int_data) {.inline.} = 
  a.data[].int_data = newVal

proc `ptr_data`*(a: CXTokenWrapper): type a.data[].ptr_data {.inline.} = 
  a.data[].ptr_data

proc `ptr_data =`*(a: CXTokenWrapper; newVal: type a.data[].ptr_data) {.inline.} = 
  a.data[].ptr_data = newVal

type 
  CXCodeCompleteResultsWrapper* = ref object 
    data: ptr CXCodeCompleteResults

proc finalizeCXCodeCompleteResults(a: CXCodeCompleteResultsWrapper) = 
  if isNil(a.data.pointer): 
    return 
  disposeCodeCompleteResults(a.data)

proc unWrap*(a: CXCodeCompleteResultsWrapper): ptr CXCodeCompleteResults = 
  a.data

proc newCXCodeCompleteResultsWrapper*(data: ptr CXCodeCompleteResults): CXCodeCompleteResultsWrapper = 
  new(result, finalizeCXCodeCompleteResults)
  result.data = data

proc `Results`*(a: CXCodeCompleteResultsWrapper): type a.data[].Results {.inline.} = 
  a.data[].Results

proc `Results =`*(a: CXCodeCompleteResultsWrapper; newVal: type a.data[].Results) {.
    inline.} = 
  a.data[].Results = newVal

proc `NumResults`*(a: CXCodeCompleteResultsWrapper): type a.data[].NumResults {.
    inline.} = 
  a.data[].NumResults

proc `NumResults =`*(a: CXCodeCompleteResultsWrapper; 
                     newVal: type a.data[].NumResults) {.inline.} = 
  a.data[].NumResults = newVal

type 
  CXRemappingWrapper* = ref object 
    data: CXRemapping

proc finalizeCXRemapping(a: CXRemappingWrapper) = 
  if isNil(a.data.pointer): 
    return 
  dispose(a.data)

proc unWrap*(a: CXRemappingWrapper): CXRemapping = 
  a.data

proc newCXRemappingWrapper*(data: CXRemapping): CXRemappingWrapper = 
  new(result, finalizeCXRemapping)
  result.data = data


proc getCString*(string: CXStringWrapper): string = 
  return $libclang.getCString(string.data)

proc createCXVirtualFileOverlay*(options: cuint): CXVirtualFileOverlayWrapper = 
  return newCXVirtualFileOverlayWrapper(libclang.createCXVirtualFileOverlay(
      options))

proc addFileMapping*(a2: CXVirtualFileOverlayWrapper; virtualPath: cstring; 
                     realPath: cstring): CXErrorCode = 
  return libclang.addFileMapping(a2.data, virtualPath, realPath)

proc setCaseSensitivity*(a2: CXVirtualFileOverlayWrapper; caseSensitive: cint): CXErrorCode = 
  return libclang.setCaseSensitivity(a2.data, caseSensitive)

proc writeToBuffer*(a2: CXVirtualFileOverlayWrapper; options: cuint; 
                    out_buffer_ptr: cstringArray; out_buffer_size: var cuint): CXErrorCode = 
  return libclang.writeToBuffer(a2.data, options, out_buffer_ptr, 
                                addr(out_buffer_size))

proc createCXModuleMapDescriptor*(options: cuint): CXModuleMapDescriptorWrapper = 
  return newCXModuleMapDescriptorWrapper(
      libclang.createCXModuleMapDescriptor(options))

proc setFrameworkModuleName*(a2: CXModuleMapDescriptorWrapper; name: cstring): CXErrorCode = 
  return libclang.setFrameworkModuleName(a2.data, name)

proc setUmbrellaHeader*(a2: CXModuleMapDescriptorWrapper; name: cstring): CXErrorCode = 
  return libclang.setUmbrellaHeader(a2.data, name)

proc writeToBuffer*(a2: CXModuleMapDescriptorWrapper; options: cuint; 
                    out_buffer_ptr: cstringArray; out_buffer_size: var cuint): CXErrorCode = 
  return libclang.writeToBuffer(a2.data, options, out_buffer_ptr, 
                                addr(out_buffer_size))

proc createIndex*(excludeDeclarationsFromPCH: cint; displayDiagnostics: cint): CXIndexWrapper = 
  return newCXIndexWrapper(libclang.createIndex(excludeDeclarationsFromPCH, 
      displayDiagnostics))

proc setGlobalOptions*(a2: CXIndexWrapper; options: cuint) = 
  libclang.setGlobalOptions(a2.data, options)

proc getGlobalOptions*(a2: CXIndexWrapper): cuint = 
  return libclang.getGlobalOptions(a2.data)

proc getFileName*(SFile: CXFile): CXStringWrapper = 
  return newCXStringWrapper(libclang.getFileName(SFile))

proc isFileMultipleIncludeGuarded*(tu: CXTranslationUnitWrapper; file: CXFile): cuint = 
  return libclang.isFileMultipleIncludeGuarded(tu.data, file)

proc getFile*(tu: CXTranslationUnitWrapper; file_name: cstring): CXFile = 
  return libclang.getFile(tu.data, file_name)

proc getLocation*(tu: CXTranslationUnitWrapper; file: CXFile; line: cuint; 
                  column: cuint): CXSourceLocation = 
  return libclang.getLocation(tu.data, file, line, column)

proc getLocationForOffset*(tu: CXTranslationUnitWrapper; file: CXFile; 
                           offset: cuint): CXSourceLocation = 
  return libclang.getLocationForOffset(tu.data, file, offset)

proc getPresumedLocation*(location: CXSourceLocation; filename: CXStringWrapper; 
                          line: var cuint; column: var cuint) = 
  libclang.getPresumedLocation(location, addr(filename.data), addr(line), 
                               addr(column))

proc getSkippedRanges*(tu: CXTranslationUnitWrapper; file: CXFile): CXSourceRangeListWrapper = 
  return newCXSourceRangeListWrapper(libclang.getSkippedRanges(tu.data, file))

proc getNumDiagnosticsInSet*(Diags: CXDiagnosticSetWrapper): cuint = 
  return libclang.getNumDiagnosticsInSet(Diags.data)

proc getDiagnosticInSet*(Diags: CXDiagnosticSetWrapper; Index: cuint): CXDiagnosticWrapper = 
  return newCXDiagnosticWrapper(libclang.getDiagnosticInSet(Diags.data, Index))

proc loadDiagnostics*(file: cstring; error: var CXLoadDiag_Error; 
                      errorString: CXStringWrapper): CXDiagnosticSetWrapper = 
  return newCXDiagnosticSetWrapper(libclang.loadDiagnostics(file, addr(error), 
      addr(errorString.data)))

proc getChildDiagnostics*(D: CXDiagnosticWrapper): CXDiagnosticSetWrapper = 
  return newCXDiagnosticSetWrapper(libclang.getChildDiagnostics(D.data))

proc getNumDiagnostics*(Unit: CXTranslationUnitWrapper): cuint = 
  return libclang.getNumDiagnostics(Unit.data)

proc getDiagnostic*(Unit: CXTranslationUnitWrapper; Index: cuint): CXDiagnosticWrapper = 
  return newCXDiagnosticWrapper(libclang.getDiagnostic(Unit.data, Index))

proc getDiagnosticSetFromTU*(Unit: CXTranslationUnitWrapper): CXDiagnosticSetWrapper = 
  return newCXDiagnosticSetWrapper(libclang.getDiagnosticSetFromTU(Unit.data))

proc formatDiagnostic*(Diagnostic: CXDiagnosticWrapper; Options: cuint): CXStringWrapper = 
  return newCXStringWrapper(libclang.formatDiagnostic(Diagnostic.data, Options))

proc getDiagnosticSeverity*(a2: CXDiagnosticWrapper): CXDiagnosticSeverity = 
  return libclang.getDiagnosticSeverity(a2.data)

proc getDiagnosticLocation*(a2: CXDiagnosticWrapper): CXSourceLocation = 
  return libclang.getDiagnosticLocation(a2.data)

proc getDiagnosticSpelling*(a2: CXDiagnosticWrapper): CXStringWrapper = 
  return newCXStringWrapper(libclang.getDiagnosticSpelling(a2.data))

proc getDiagnosticOption*(Diag: CXDiagnosticWrapper; Disable: CXStringWrapper): CXStringWrapper = 
  return newCXStringWrapper(libclang.getDiagnosticOption(Diag.data, 
      addr(Disable.data)))

proc getDiagnosticCategory*(a2: CXDiagnosticWrapper): cuint = 
  return libclang.getDiagnosticCategory(a2.data)

proc getDiagnosticCategoryName*(Category: cuint): CXStringWrapper = 
  return newCXStringWrapper(libclang.getDiagnosticCategoryName(Category))

proc getDiagnosticCategoryText*(a2: CXDiagnosticWrapper): CXStringWrapper = 
  return newCXStringWrapper(libclang.getDiagnosticCategoryText(a2.data))

proc getDiagnosticNumRanges*(a2: CXDiagnosticWrapper): cuint = 
  return libclang.getDiagnosticNumRanges(a2.data)

proc getDiagnosticRange*(Diagnostic: CXDiagnosticWrapper; Range: cuint): CXSourceRange = 
  return libclang.getDiagnosticRange(Diagnostic.data, Range)

proc getDiagnosticNumFixIts*(Diagnostic: CXDiagnosticWrapper): cuint = 
  return libclang.getDiagnosticNumFixIts(Diagnostic.data)

proc getDiagnosticFixIt*(Diagnostic: CXDiagnosticWrapper; FixIt: cuint; 
                         ReplacementRange: var CXSourceRange): CXStringWrapper = 
  return newCXStringWrapper(libclang.getDiagnosticFixIt(Diagnostic.data, FixIt, 
      addr(ReplacementRange)))

proc getTranslationUnitSpelling*(CTUnit: CXTranslationUnitWrapper): CXStringWrapper = 
  return newCXStringWrapper(libclang.getTranslationUnitSpelling(CTUnit.data))

proc createTranslationUnitFromSourceFile*(CIdx: CXIndexWrapper; 
    source_filename: string; 
    command_line_args: openarray[string];  
    unsaved_files: var openarray[CXUnsavedFile]): CXTranslationUnitWrapper = 
  var num_unsaved_files: cuint = unsaved_files.len.cuint
  var cmd_line = allocCstringArray(command_line_args)
  var num_command_line_args: cint = command_line_args.len.cint
  result = newCXTranslationUnitWrapper(CIdx, nil, libclang.createTranslationUnitFromSourceFile(
      CIdx.data, source_filename, num_command_line_args, 
      cmd_line, num_unsaved_files, addr(unsaved_files[0])))
  deallocCStringArray(cmd_line)

proc createTranslationUnit*(CIdx: CXIndexWrapper; ast_filename: string): CXTranslationUnitWrapper = 
  return newCXTranslationUnitWrapper(CIDx, nil, libclang.createTranslationUnit(CIdx.data, 
      ast_filename))

proc createTranslationUnit2*(CIdx: CXIndexWrapper; ast_filename: string; 
                             out_TU: CXTranslationUnitWrapper): CXErrorCode = 
  return libclang.createTranslationUnit2(CIdx.data, ast_filename, 
      addr(out_TU.data))

proc parseTranslationUnit*(CIdx: CXIndexWrapper; source_filename: string; 
                           command_line_args: openarray[string]; 
                           unsaved_files: var openarray[CXUnsavedFile]; 
                           options: cuint): CXTranslationUnitWrapper =
  var num_unsaved_files: cuint = unsaved_files.len.cuint
  var cmd_line = allocCstringArray(command_line_args)
  var num_command_line_args: cint = command_line_args.len.cint 
  result = newCXTranslationUnitWrapper(CIdx, nil,libclang.parseTranslationUnit(CIdx.data, 
      source_filename, cmd_line, num_command_line_args, 
      addr(unsaved_files[0]), num_unsaved_files, options))
  deallocCStringArray(cmd_line)

proc parseTranslationUnit2*(CIdx: CXIndexWrapper; source_filename: string; 
                            command_line_args: openarray[string]; 
                            unsaved_files: var openarray[CXUnsavedFile]; 
                            options: cuint; 
                            out_TU: CXTranslationUnitWrapper): CXErrorCode = 
  var num_unsaved_files: cuint = unsaved_files.len.cuint
  var cmd_line = allocCstringArray(command_line_args)
  var num_command_line_args: cint = command_line_args.len.cint
  result = libclang.parseTranslationUnit2(CIdx.data, source_filename, 
                                        cmd_line, 
                                        num_command_line_args, 
                                        addr(unsaved_files[0]), num_unsaved_files, 
                                        options, addr(out_TU.data))
  deallocCStringArray(cmd_line)

proc defaultSaveOptions*(TU: CXTranslationUnitWrapper): cuint = 
  return libclang.defaultSaveOptions(TU.data)

proc saveTranslationUnit*(TU: CXTranslationUnitWrapper; FileName: cstring; 
                          options: cuint): cint = 
  return libclang.saveTranslationUnit(TU.data, FileName, options)

proc defaultReparseOptions*(TU: CXTranslationUnitWrapper): cuint = 
  return libclang.defaultReparseOptions(TU.data)

proc reparseTranslationUnit*(TU: CXTranslationUnitWrapper; 
                             unsaved_files: var openarray[CXUnsavedFile]; options: cuint): cint = 
  var num_unsaved_files: cuint = unsaved_files.len.cuint
  return libclang.reparseTranslationUnit(TU.data, num_unsaved_files, 
      addr(unsaved_files[0]), options)

proc getCXTUResourceUsage*(TU: CXTranslationUnitWrapper): CXTUResourceUsageWrapper = 
  return newCXTUResourceUsageWrapper(libclang.getCXTUResourceUsage(TU.data))

proc getTranslationUnitCursor*(a2: CXTranslationUnitWrapper): CXCursor = 
  return libclang.getTranslationUnitCursor(a2.data)

proc getCursorPlatformAvailability*(cursor: CXCursor; 
                                    always_deprecated: var cint; 
                                    deprecated_message: CXStringWrapper; 
                                    always_unavailable: var cint; 
                                    unavailable_message: CXStringWrapper; 
    availability: CXPlatformAvailabilityWrapper): cint = 
  let availability_size:cint = availability.len
  return libclang.getCursorPlatformAvailability(cursor, addr(always_deprecated), 
      addr(deprecated_message.data), addr(always_unavailable), 
      addr(unavailable_message.data), availability.data, availability_size)

#FIXME: this probably returns a reference that we already have?!
#proc getTranslationUnit*(a2: CXCursor): CXTranslationUnitWrapper =
#  return newCXTranslationUnitWrapper(nil, nil,libclang.getTranslationUnit(a2))


proc createCXCursorSet*(): CXCursorSetWrapper = 
  return newCXCursorSetWrapper(libclang.createCXCursorSet())

proc contains*(cset: CXCursorSetWrapper; cursor: CXCursor): cuint = 
  return libclang.contains(cset.data, cursor)

proc insert*(cset: CXCursorSetWrapper; cursor: CXCursor): cuint = 
  return libclang.insert(cset.data, cursor)

proc getCursor*(a2: CXTranslationUnitWrapper; a3: CXSourceLocation): CXCursor = 
  return libclang.getCursor(a2.data, a3)

proc getTypeSpelling*(CT: CXType): CXStringWrapper = 
  return newCXStringWrapper(libclang.getTypeSpelling(CT))

proc getDeclObjCTypeEncoding*(C: CXCursor): CXStringWrapper = 
  return newCXStringWrapper(libclang.getDeclObjCTypeEncoding(C))

proc getTypeKindSpelling*(K: CXTypeKind): CXStringWrapper = 
  return newCXStringWrapper(libclang.getTypeKindSpelling(K))

proc getCursorUSR*(a2: CXCursor): CXStringWrapper = 
  return newCXStringWrapper(libclang.getCursorUSR(a2))

proc objCClass*(class_name: cstring): CXStringWrapper = 
  return newCXStringWrapper(libclang.objCClass(class_name))

proc objCCategory*(class_name: cstring; category_name: cstring): CXStringWrapper = 
  return newCXStringWrapper(libclang.objCCategory(class_name, category_name))

proc objCProtocol*(protocol_name: cstring): CXStringWrapper = 
  return newCXStringWrapper(libclang.objCProtocol(protocol_name))

proc objCIvar*(name: cstring; classUSR: CXStringWrapper): CXStringWrapper = 
  return newCXStringWrapper(libclang.objCIvar(name, classUSR.data))

proc objCMethod*(name: cstring; isInstanceMethod: cuint; 
                 classUSR: CXStringWrapper): CXStringWrapper = 
  return newCXStringWrapper(libclang.objCMethod(name, isInstanceMethod, 
      classUSR.data))

proc objCProperty*(property: cstring; classUSR: CXStringWrapper): CXStringWrapper = 
  return newCXStringWrapper(libclang.objCProperty(property, classUSR.data))

proc getCursorSpelling*(a2: CXCursor): CXStringWrapper = 
  return newCXStringWrapper(libclang.getCursorSpelling(a2))

proc getCursorDisplayName*(a2: CXCursor): CXStringWrapper = 
  return newCXStringWrapper(libclang.getCursorDisplayName(a2))

proc getRawCommentText*(C: CXCursor): CXStringWrapper = 
  return newCXStringWrapper(libclang.getRawCommentText(C))

proc getBriefCommentText*(C: CXCursor): CXStringWrapper = 
  return newCXStringWrapper(libclang.getBriefCommentText(C))

proc getMangling*(a2: CXCursor): CXStringWrapper = 
  return newCXStringWrapper(libclang.getMangling(a2))

proc getModuleForFile*(a2: CXTranslationUnitWrapper; a3: CXFile): CXModule = 
  return libclang.getModuleForFile(a2.data, a3)

proc getName*(Module: CXModule): CXStringWrapper = 
  return newCXStringWrapper(libclang.getName(Module))

proc getFullName*(Module: CXModule): CXStringWrapper = 
  return newCXStringWrapper(libclang.getFullName(Module))

proc getNumTopLevelHeaders*(a2: CXTranslationUnitWrapper; Module: CXModule): cuint = 
  return libclang.getNumTopLevelHeaders(a2.data, Module)

proc getTopLevelHeader*(a2: CXTranslationUnitWrapper; Module: CXModule; 
                        Index: cuint): CXFile = 
  return libclang.getTopLevelHeader(a2.data, Module, Index)


proc getTokenSpelling*(a2: CXTranslationUnitWrapper; a3: CXToken): CXStringWrapper = 
  return newCXStringWrapper(libclang.getTokenSpelling(a2.data, a3))

proc getTokenLocation*(a2: CXTranslationUnitWrapper; a3: CXToken): CXSourceLocation = 
  return libclang.getTokenLocation(a2.data, a3)

proc getTokenExtent*(a2: CXTranslationUnitWrapper; a3: CXToken): CXSourceRange = 
  return libclang.getTokenExtent(a2.data, a3)

proc tokenize*(TU: CXTranslationUnitWrapper; Range: CXSourceRange): CXTokenWrapper = 
  result = newCXTokenWrapper(TU, nil, 0)
  libclang.tokenize(TU.data, Range, addr(result.data), addr(result.numTokens))

proc annotateTokens*(Tokens: CXTokenWrapper): seq[CXCursor] =
  result = newSeq[CXCursor](Tokens.numTokens.int)
  libclang.annotateTokens(Tokens.tu.data, Tokens.data, Tokens.numTokens, 
                          result[0].addr)

proc getCursorKindSpelling*(Kind: CXCursorKind): CXStringWrapper = 
  return newCXStringWrapper(libclang.getCursorKindSpelling(Kind))

proc getCompletionChunkText*(completion_string: CXCompletionString; 
                             chunk_number: cuint): CXStringWrapper = 
  return newCXStringWrapper(libclang.getCompletionChunkText(completion_string, 
      chunk_number))

proc getCompletionAnnotation*(completion_string: CXCompletionString; 
                              annotation_number: cuint): CXStringWrapper = 
  return newCXStringWrapper(libclang.getCompletionAnnotation(completion_string, 
      annotation_number))

proc getCompletionParent*(completion_string: CXCompletionString): CXStringWrapper =
  # kind is deprecated, always pass nil 
  return newCXStringWrapper(libclang.getCompletionParent(completion_string, 
      nil))

proc getCompletionBriefComment*(completion_string: CXCompletionString): CXStringWrapper = 
  return newCXStringWrapper(libclang.getCompletionBriefComment(completion_string))

proc codeCompleteAt*(TU: CXTranslationUnitWrapper; complete_filename: cstring; 
                     complete_line: cuint; complete_column: cuint; 
                     unsaved_files: var openarray[CXUnsavedFile];  
                     options: cuint): CXCodeCompleteResultsWrapper = 
  var num_unsaved_files: cuint = unsaved_files.len.cuint
  return newCXCodeCompleteResultsWrapper(libclang.codeCompleteAt(TU.data, 
      complete_filename, complete_line, complete_column, addr(unsaved_files[0]), 
      num_unsaved_files, options))

proc codeCompleteGetNumDiagnostics*(Results: CXCodeCompleteResultsWrapper): cuint = 
  return libclang.codeCompleteGetNumDiagnostics(Results.data)

proc codeCompleteGetDiagnostic*(Results: CXCodeCompleteResultsWrapper; 
                                Index: cuint): CXDiagnosticWrapper = 
  return newCXDiagnosticWrapper(libclang.codeCompleteGetDiagnostic(
      Results.data, Index))

proc codeCompleteGetContexts*(Results: CXCodeCompleteResultsWrapper): culonglong = 
  return libclang.codeCompleteGetContexts(Results.data)

proc codeCompleteGetContainerKind*(Results: CXCodeCompleteResultsWrapper; 
                                   IsIncomplete: var cuint): CXCursorKind = 
  return libclang.codeCompleteGetContainerKind(Results.data, 
      addr(IsIncomplete))

proc codeCompleteGetContainerUSR*(Results: CXCodeCompleteResultsWrapper): CXStringWrapper = 
  return newCXStringWrapper(libclang.codeCompleteGetContainerUSR(
      Results.data))

proc codeCompleteGetObjCSelector*(Results: CXCodeCompleteResultsWrapper): CXStringWrapper = 
  return newCXStringWrapper(libclang.codeCompleteGetObjCSelector(
      Results.data))

proc getClangVersion*(): CXStringWrapper = 
  return newCXStringWrapper(libclang.getClangVersion())

proc getInclusions*(tu: CXTranslationUnitWrapper; visitor: CXInclusionVisitor; 
                    client_data: CXClientData) = 
  libclang.getInclusions(tu.data, visitor, client_data)

proc getRemappings*(path: string): CXRemappingWrapper = 
  return newCXRemappingWrapper(libclang.getRemappings(path))

proc getRemappingsFromFileList*(filePaths: cstringArray; numFiles: cuint): CXRemappingWrapper = 
  return newCXRemappingWrapper(libclang.getRemappingsFromFileList(filePaths, 
      numFiles))

proc getNumFiles*(a2: CXRemappingWrapper): cuint = 
  return libclang.getNumFiles(a2.data)

proc getFilenames*(a2: CXRemappingWrapper; index: cuint; 
                   original: CXStringWrapper; transformed: CXStringWrapper) = 
  libclang.getFilenames(a2.data, index, addr(original.data), 
                        addr(transformed.data))

proc findIncludesInFile*(TU: CXTranslationUnitWrapper; file: CXFile; 
                         visitor: CXCursorAndRangeVisitor): CXResult = 
  return libclang.findIncludesInFile(TU.data, file, visitor)

proc createIndexAction*(CIdx: CXIndexWrapper): CXIndexActionWrapper = 
  return newCXIndexActionWrapper(libclang.createIndexAction(CIdx.data))

proc indexSourceFile*(a2: CXIndexActionWrapper; client_data: CXClientData; 
                      index_callbacks: var openarray[IndexerCallbacks]; 
                      index_options: cuint; 
                      source_filename: string; command_line_args: openarray[string]; 
                      unsaved_files: var openarray[CXUnsavedFile]; 
                      TU_options: cuint): CXTranslationUnitWrapper =
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
  result = newCXTranslationUnitWrapper(nil, a2, temp)

proc indexTranslationUnit*[T](a2: CXIndexActionWrapper; client_data: ptr T; 
                           index_callbacks: var openarray[IndexerCallbacks]; 
                           index_options: cuint; 
                           a7: CXTranslationUnitWrapper) = 
  var index_callbacks_size = index_callbacks.len.cuint
  var client_data_raw = client_data.CXClientData
  let retVal = libclang.indexTranslationUnit(a2.data, client_data_raw, 
                                       addr(index_callbacks[0]), 
                                       index_callbacks_size, index_options, 
                                       a7.data)
  if retval != 0:
    raise newException(ValueError, "compiler could not index translation unit without unrecoverable errors")


proc getOverriddenCursors*(cursor: CXCursor): CXCursorWrapper =
  var num_overridden: cuint
  var overriden: ptr CXCursor
  libclang.getOverriddenCursors(cursor, overriden.addr, 
                                addr(num_overridden))
  result = newCXCursorWrapper(overriden,num_overridden)

when isMainModule:
  echo getClangVersion()
  
