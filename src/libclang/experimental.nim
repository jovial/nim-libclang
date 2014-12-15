## Module status: unfinished, presume not working

import libclang
{.deadCodeElim: on.} # required as some procedures missing (at least on my version)

# TODOs
# - replace cstring in wrapped procedures
# - helper procedures for array access
# - fix order order dependent stuff, eg clang_disposeTokens(tu,...)
# must be called before clang_disposeTranslationUnit(tu)
#     -- known bad: IndexWrapper


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

#FIXME: all translation units must be freed before we can free this
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

type 
  CXTranslationUnitWrapper* = ref object 
    data: CXTranslationUnit

proc finalizeCXTranslationUnit(a: CXTranslationUnitWrapper) = 
  if isNil(a.data.pointer): 
    return 
  disposeTranslationUnit(a.data)

proc unWrap*(a: CXTranslationUnitWrapper): CXTranslationUnit = 
  a.data

proc newCXTranslationUnitWrapper*(data: CXTranslationUnit): CXTranslationUnitWrapper = 
  new(result, finalizeCXTranslationUnit)
  result.data = data

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

type NotImplError* = object of Exception

# acts as marker
type CXCursorWrapper = ref object of RootObj

method unWrap(CXCursorWrapper): ptr CXCursor =
  raise newException(NotImplError, "you must implement this method in subtypes")
  
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
   
type 
  CXCursorDisposeWrapper* = ref object of CXCursorWrapper
    data: ptr CXCursor

proc finalizeCXCursor(a: CXCursorDisposeWrapper) = 
  if isNil(a.data.pointer): 
    return 
  disposeOverriddenCursors(a.data)

method unWrap*(a: CXCursorDisposeWrapper): ptr CXCursor = 
  a.data

proc newCXCursorDisposeWrapper*(data: ptr CXCursor): CXCursorDisposeWrapper = 
  new(result, finalizeCXCursor)
  result.data = data


type 
  CXCursorConcreteWrapper* = ref object of CXCursorWrapper
    data: CXCursor

method unWrap*(a: CXCursorConcreteWrapper): ptr CXCursor = 
  a.data.addr

proc newCXCursorWrapper*(data: CXCursor): CXCursorConcreteWrapper = 
  new(result)
  result.data = data
  
type 
  Cursor* = ref object of CXCursorWrapper
    data: ptr CXCursor

method unWrap*(a: Cursor): ptr CXCursor = 
  a.data

proc newCXCursorWrapper*(data: ptr CXCursor): Cursor = 
  new(result)
  result.data = data
  
type 
  CursorArray* = ref object of CXCursorWrapper
    data: seq[CXCursor]

method unWrap*(a: CursorArray): ptr CXCursor = 
  a.data[0].addr

proc newCXCursorWrapper*(numTokens: cuint): CursorArray = 
  new(result)
  result.data = newSeq[CXCursor](numTokens.int)


type 
  CXPlatformAvailabilityWrapper* = ref object 
    data: ptr CXPlatformAvailability

proc finalizeCXPlatformAvailability(a: CXPlatformAvailabilityWrapper) = 
  if isNil(a.data.pointer): 
    return 
  disposeCXPlatformAvailability(a.data)

proc unWrap*(a: CXPlatformAvailabilityWrapper): ptr CXPlatformAvailability = 
  a.data

proc newCXPlatformAvailabilityWrapper*(data: ptr CXPlatformAvailability): CXPlatformAvailabilityWrapper = 
  new(result, finalizeCXPlatformAvailability)
  result.data = data

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

proc getCString*(string: CXStringWrapper): cstring = 
  return libclang.getCString(string.data)

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
    source_filename: cstring; num_clang_command_line_args: cint; 
    command_line_args: cstringArray; num_unsaved_files: cuint; 
    unsaved_files: var CXUnsavedFile): CXTranslationUnitWrapper = 
  return newCXTranslationUnitWrapper(libclang.createTranslationUnitFromSourceFile(
      CIdx.data, source_filename, num_clang_command_line_args, 
      command_line_args, num_unsaved_files, addr(unsaved_files)))

proc createTranslationUnit*(CIdx: CXIndexWrapper; ast_filename: cstring): CXTranslationUnitWrapper = 
  return newCXTranslationUnitWrapper(libclang.createTranslationUnit(CIdx.data, 
      ast_filename))

proc createTranslationUnit2*(CIdx: CXIndexWrapper; ast_filename: cstring; 
                             out_TU: CXTranslationUnitWrapper): CXErrorCode = 
  return libclang.createTranslationUnit2(CIdx.data, ast_filename, 
      addr(out_TU.data))

proc parseTranslationUnit*(CIdx: CXIndexWrapper; source_filename: cstring; 
                           command_line_args: cstringArray; 
                           num_command_line_args: cint; 
                           unsaved_files: var CXUnsavedFile; 
                           num_unsaved_files: cuint; options: cuint): CXTranslationUnitWrapper = 
  return newCXTranslationUnitWrapper(libclang.parseTranslationUnit(CIdx.data, 
      source_filename, command_line_args, num_command_line_args, 
      addr(unsaved_files), num_unsaved_files, options))

proc parseTranslationUnit2*(CIdx: CXIndexWrapper; source_filename: cstring; 
                            command_line_args: cstringArray; 
                            num_command_line_args: cint; 
                            unsaved_files: var CXUnsavedFile; 
                            num_unsaved_files: cuint; options: cuint; 
                            out_TU: CXTranslationUnitWrapper): CXErrorCode = 
  return libclang.parseTranslationUnit2(CIdx.data, source_filename, 
                                        command_line_args, 
                                        num_command_line_args, 
                                        addr(unsaved_files), num_unsaved_files, 
                                        options, addr(out_TU.data))

proc defaultSaveOptions*(TU: CXTranslationUnitWrapper): cuint = 
  return libclang.defaultSaveOptions(TU.data)

proc saveTranslationUnit*(TU: CXTranslationUnitWrapper; FileName: cstring; 
                          options: cuint): cint = 
  return libclang.saveTranslationUnit(TU.data, FileName, options)

proc defaultReparseOptions*(TU: CXTranslationUnitWrapper): cuint = 
  return libclang.defaultReparseOptions(TU.data)

proc reparseTranslationUnit*(TU: CXTranslationUnitWrapper; 
                             num_unsaved_files: cuint; 
                             unsaved_files: var CXUnsavedFile; options: cuint): cint = 
  return libclang.reparseTranslationUnit(TU.data, num_unsaved_files, 
      addr(unsaved_files), options)

proc getCXTUResourceUsage*(TU: CXTranslationUnitWrapper): CXTUResourceUsageWrapper = 
  return newCXTUResourceUsageWrapper(libclang.getCXTUResourceUsage(TU.data))

proc getNullCursor*(): CXCursorWrapper = 
  return newCXCursorWrapper(libclang.getNullCursor())

proc getTranslationUnitCursor*(a2: CXTranslationUnitWrapper): CXCursorWrapper = 
  return newCXCursorWrapper(libclang.getTranslationUnitCursor(a2.data))

proc equalCursors*(a2: CXCursorWrapper; a3: CXCursorWrapper): cuint = 
  let a2U = a2.unWrap()
  let a3U = a3.unWrap()
  return libclang.equalCursors(a2U[], a3U[])

proc isNull*(cursor: CXCursorWrapper): cint =
  let cU = cursor.unWrap() 
  return libclang.isNull(cU[])

proc hashCursor*(a2: CXCursorWrapper): cuint =
  let cU = a2.unWrap()  
  return libclang.hashCursor(cU[])

proc getCursorKind*(a2: CXCursorWrapper): CXCursorKind =
  let cU = a2.unWrap()  
  return libclang.getCursorKind(cU[])

proc getCursorLinkage*(cursor: CXCursorWrapper): CXLinkageKind =
  let cU = cursor.unWrap()  
  return libclang.getCursorLinkage(cU[])

proc getCursorAvailability*(cursor: CXCursorWrapper): CXAvailabilityKind =
  let cU = cursor.unWrap()   
  return libclang.getCursorAvailability(cU[])

proc getCursorPlatformAvailability*(cursor: CXCursorWrapper; 
                                    always_deprecated: var cint; 
                                    deprecated_message: CXStringWrapper; 
                                    always_unavailable: var cint; 
                                    unavailable_message: CXStringWrapper; 
    availability: CXPlatformAvailabilityWrapper; availability_size: cint): cint =
  let cU = cursor.unWrap()    
  return libclang.getCursorPlatformAvailability(cU[], 
      addr(always_deprecated), addr(deprecated_message.data), 
      addr(always_unavailable), addr(unavailable_message.data), 
      availability.data, availability_size)

proc getCursorLanguage*(cursor: CXCursorWrapper): CXLanguageKind =
  let cU = cursor.unWrap() 
  return libclang.getCursorLanguage(cU[])

proc getTranslationUnit*(a2: CXCursorWrapper): CXTranslationUnitWrapper =
  let cU = a2.unWrap() 
  return newCXTranslationUnitWrapper(libclang.getTranslationUnit(cu[]))

proc createCXCursorSet*(): CXCursorSetWrapper = 
  return newCXCursorSetWrapper(libclang.createCXCursorSet())

proc contains*(cset: CXCursorSetWrapper; cursor: CXCursorWrapper): cuint =
  let cU = cursor.unWrap() 
  return libclang.contains(cset.data, cU[])

proc insert*(cset: CXCursorSetWrapper; cursor: CXCursorWrapper): cuint =
  let cU = cursor.unWrap() 
  return libclang.insert(cset.data, cU[])

proc getCursorSemanticParent*(cursor: CXCursorWrapper): CXCursorWrapper =
  let cU = cursor.unWrap() 
  return newCXCursorWrapper(libclang.getCursorSemanticParent(cU[]))

proc getCursorLexicalParent*(cursor: CXCursorWrapper): CXCursorWrapper =
  let cU = cursor.unWrap() 
  return newCXCursorWrapper(libclang.getCursorLexicalParent(cU[]))

proc getOverriddenCursors*(cursor: CXCursorWrapper; 
                           num_overridden: var cuint): CXCursorWrapper =
  result = newCXCursorDisposeWrapper(nil)
  var overU = result.unWrap()
  let cU = cursor.unWrap() 
  libclang.getOverriddenCursors(cU[], overU.addr, 
                                addr(num_overridden))

proc getIncludedFile*(cursor: CXCursorWrapper): CXFile = 
  let cU = cursor.unWrap()
  return libclang.getIncludedFile(cU[])

proc getCursor*(a2: CXTranslationUnitWrapper; a3: CXSourceLocation): CXCursorWrapper = 
  return newCXCursorWrapper(libclang.getCursor(a2.data, a3))

proc getCursorLocation*(a2: CXCursorWrapper): CXSourceLocation =
  let cU = a2.unWrap() 
  return libclang.getCursorLocation(cU[])

proc getCursorExtent*(a2: CXCursorWrapper): CXSourceRange =
  let cU = a2.unWrap()  
  return libclang.getCursorExtent(cU[])

proc getCursorType*(C: CXCursorWrapper): CXType =
  let cU = C.unWrap()  
  return libclang.getCursorType(cU[])

proc getTypeSpelling*(CT: CXType): CXStringWrapper = 
  return newCXStringWrapper(libclang.getTypeSpelling(CT))

proc getTypedefDeclUnderlyingType*(C: CXCursorWrapper): CXType =
  let cU = C.unWrap()  
  return libclang.getTypedefDeclUnderlyingType(cU[])

proc getEnumDeclIntegerType*(C: CXCursorWrapper): CXType = 
  let cU = C.unWrap() 
  return libclang.getEnumDeclIntegerType(cU[])

proc getEnumConstantDeclValue*(C: CXCursorWrapper): clonglong = 
  let cU = C.unWrap() 
  return libclang.getEnumConstantDeclValue(cU[])

proc getEnumConstantDeclUnsignedValue*(C: CXCursorWrapper): culonglong = 
  let cU = C.unWrap() 
  return libclang.getEnumConstantDeclUnsignedValue(cU[])

proc getFieldDeclBitWidth*(C: CXCursorWrapper): cint = 
  let cU = C.unWrap() 
  return libclang.getFieldDeclBitWidth(cU[])

proc getNumArguments*(C: CXCursorWrapper): cint = 
  let cU = C.unWrap() 
  return libclang.getNumArguments(cU[])

proc getArgument*(C: CXCursorWrapper; i: cuint): CXCursorWrapper = 
  let cU = C.unWrap() 
  return newCXCursorWrapper(libclang.getArgument(cU[], i))

#could not import: clang_Cursor_getNumTemplateArguments
proc getNumTemplateArguments*(C: CXCursorWrapper): cint = 
  let cU = C.unWrap() 
  return libclang.getNumTemplateArguments(cU[])

proc getTemplateArgumentKind*(C: CXCursorWrapper; I: cuint): CXTemplateArgumentKind = 
  let cU = C.unWrap() 
  return libclang.getTemplateArgumentKind(cU[], I)

proc getTemplateArgumentType*(C: CXCursorWrapper; I: cuint): CXType = 
  let cU = C.unWrap() 
  return libclang.getTemplateArgumentType(cU[], I)

proc getTemplateArgumentValue*(C: CXCursorWrapper; I: cuint): clonglong = 
  let cU = C.unWrap() 
  return libclang.getTemplateArgumentValue(cU[], I)

proc getTemplateArgumentUnsignedValue*(C: CXCursorWrapper; I: cuint): culonglong = 
  let cU = C.unWrap() 
  return libclang.getTemplateArgumentUnsignedValue(cu[], I)

proc getTypeDeclaration*(T: CXType): CXCursorWrapper = 
  return newCXCursorWrapper(libclang.getTypeDeclaration(T))

proc getDeclObjCTypeEncoding*(C: CXCursorWrapper): CXStringWrapper = 
  let cU = C.unWrap() 
  return newCXStringWrapper(libclang.getDeclObjCTypeEncoding(cU[]))

proc getTypeKindSpelling*(K: CXTypeKind): CXStringWrapper = 
  return newCXStringWrapper(libclang.getTypeKindSpelling(K))

proc getCursorResultType*(C: CXCursorWrapper): CXType =
  let cU = C.unWrap()  
  return libclang.getCursorResultType(cU[])

proc isBitField*(C: CXCursorWrapper): cuint = 
  let cU = C.unWrap() 
  return libclang.isBitField(cU[])

proc isVirtualBase*(a2: CXCursorWrapper): cuint =
  let cU = a2.unWrap()  
  return libclang.isVirtualBase(cU[])

proc getCXXAccessSpecifier*(a2: CXCursorWrapper): CX_CXXAccessSpecifier = 
  let cU = a2.unWrap()  
  return libclang.getCXXAccessSpecifier(cU[])

proc getStorageClass*(a2: CXCursorWrapper): CX_StorageClass =
  let cU = a2.unWrap()   
  return libclang.getStorageClass(cU[])

proc getNumOverloadedDecls*(cursor: CXCursorWrapper): cuint = 
  let cU = cursor.unWrap()  
  return libclang.getNumOverloadedDecls(cU[])

proc getOverloadedDecl*(cursor: CXCursorWrapper; index: cuint): CXCursorWrapper = 
  let cU = cursor.unWrap()
  return newCXCursorWrapper(libclang.getOverloadedDecl(cU[], index))

proc getIBOutletCollectionType*(a2: CXCursorWrapper): CXType =
  let cU = a2.unWrap() 
  return libclang.getIBOutletCollectionType(cU[])

proc visitChildren*(parent: CXCursorWrapper; visitor: CXCursorVisitor; 
                    client_data: CXClientData): cuint = 
  let parentU = parent.unWrap()
  return libclang.visitChildren(parentU[], visitor, client_data)

proc getCursorUSR*(a2: CXCursorWrapper): CXStringWrapper = 
  let cU = a2.unWrap()
  return newCXStringWrapper(libclang.getCursorUSR(cU[]))

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

proc getCursorSpelling*(a2: CXCursorWrapper): CXStringWrapper =
  let cU = a2.unWrap() 
  return newCXStringWrapper(libclang.getCursorSpelling(cU[]))

proc getSpellingNameRange*(a2: CXCursorWrapper; pieceIndex: cuint; 
                           options: cuint): CXSourceRange =
  let cU = a2.unWrap()                          
  return libclang.getSpellingNameRange(cU[], pieceIndex, options)

proc getCursorDisplayName*(a2: CXCursorWrapper): CXStringWrapper = 
  let cU = a2.unWrap()
  return newCXStringWrapper(libclang.getCursorDisplayName(cU[]))

proc getCursorReferenced*(a2: CXCursorWrapper): CXCursorWrapper =
  let cU = a2.unWrap() 
  return newCXCursorWrapper(libclang.getCursorReferenced(cU[]))

proc getCursorDefinition*(a2: CXCursorWrapper): CXCursorWrapper = 
  let cU = a2.unWrap()
  return newCXCursorWrapper(libclang.getCursorDefinition(cU[]))

proc isCursorDefinition*(a2: CXCursorWrapper): cuint =
  let cU = a2.unWrap() 
  return libclang.isCursorDefinition(cU[])

proc getCanonicalCursor*(a2: CXCursorWrapper): CXCursorWrapper = 
  let cU = a2.unWrap()
  return newCXCursorWrapper(libclang.getCanonicalCursor(cU[]))

proc getObjCSelectorIndex*(a2: CXCursorWrapper): cint =
  let cU = a2.unWrap() 
  return libclang.getObjCSelectorIndex(cU[])

proc isDynamicCall*(C: CXCursorWrapper): cint =
  let cU = C.unWrap() 
  return libclang.isDynamicCall(cU[])

proc getReceiverType*(C: CXCursorWrapper): CXType = 
  let cU = C.unWrap() 
  return libclang.getReceiverType(cU[])

proc getObjCPropertyAttributes*(C: CXCursorWrapper; reserved: cuint): cuint = 
  let cU = C.unWrap() 
  return libclang.getObjCPropertyAttributes(cU[], reserved)

proc getObjCDeclQualifiers*(C: CXCursorWrapper): cuint = 
  let cU = C.unWrap() 
  return libclang.getObjCDeclQualifiers(cU[])

proc isObjCOptional*(C: CXCursorWrapper): cuint = 
  let cU = C.unWrap() 
  return libclang.isObjCOptional(cU[])

proc isVariadic*(C: CXCursorWrapper): cuint = 
  let cU = C.unWrap() 
  return libclang.isVariadic(cU[])

proc getCommentRange*(C: CXCursorWrapper): CXSourceRange = 
  let cU = C.unWrap() 
  return libclang.getCommentRange(cU[])

proc getRawCommentText*(C: CXCursorWrapper): CXStringWrapper = 
  let cU = C.unWrap() 
  return newCXStringWrapper(libclang.getRawCommentText(cU[]))

proc getBriefCommentText*(C: CXCursorWrapper): CXStringWrapper =
  let cU = C.unWrap()  
  return newCXStringWrapper(libclang.getBriefCommentText(cU[]))

proc getMangling*(a2: CXCursorWrapper): CXStringWrapper =
  let cU = a2.unWrap()  
  return newCXStringWrapper(libclang.getMangling(cU[]))

proc getModule*(C: CXCursorWrapper): CXModule = 
  let cU = C.unWrap() 
  return libclang.getModule(cU[])

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

proc isPureVirtual*(C: CXCursorWrapper): cuint = 
  let cU = C.unWrap() 
  return libclang.isPureVirtual(cU[])

proc isStatic*(C: CXCursorWrapper): cuint =
  let cU = C.unWrap()  
  return libclang.isStatic(cU[])

proc isVirtual*(C: CXCursorWrapper): cuint = 
  let cU = C.unWrap() 
  return libclang.isVirtual(cU[])

proc isConst*(C: CXCursorWrapper): cuint = 
  let cU = C.unWrap() 
  return libclang.isConst(cU[])

proc getTemplateCursorKind*(C: CXCursorWrapper): CXCursorKind = 
  let cU = C.unWrap() 
  return libclang.getTemplateCursorKind(cU[])

proc getSpecializedCursorTemplate*(C: CXCursorWrapper): CXCursorWrapper = 
  let cU = C.unWrap() 
  return newCXCursorWrapper(libclang.getSpecializedCursorTemplate(cU[]))

proc getCursorReferenceNameRange*(C: CXCursorWrapper; NameFlags: cuint; 
                                  PieceIndex: cuint): CXSourceRange =
  let cU = C.unWrap()                                  
  return libclang.getCursorReferenceNameRange(cU[], NameFlags, PieceIndex)

proc getTokenKind*(a2: CXTokenWrapper): CXTokenKind = 
  return libclang.getTokenKind(a2.data[])

proc getTokenSpelling*(a2: CXTranslationUnitWrapper; a3: CXTokenWrapper): CXStringWrapper = 
  return newCXStringWrapper(libclang.getTokenSpelling(a2.data, a3.data[]))

proc getTokenLocation*(a2: CXTranslationUnitWrapper; a3: CXTokenWrapper): CXSourceLocation = 
  return libclang.getTokenLocation(a2.data, a3.data[])

proc getTokenExtent*(a2: CXTranslationUnitWrapper; a3: CXTokenWrapper): CXSourceRange = 
  return libclang.getTokenExtent(a2.data, a3.data[])

proc tokenize*(TU: CXTranslationUnitWrapper; Range: CXSourceRange): CXTokenWrapper = 
  result = newCXTokenWrapper(TU, nil, 0)
  libclang.tokenize(TU.data, Range, addr(result.data), addr(result.numTokens))

proc annotateTokens*(Tokens: CXTokenWrapper): CXCursorWrapper =
  result = newCXCursorWrapper(Tokens.numTokens)
  let cU = result.unWrap()
  libclang.annotateTokens(Tokens.tu.data, Tokens.data, Tokens.numTokens, 
                          cU)

proc getCursorKindSpelling*(Kind: CXCursorKind): CXStringWrapper = 
  return newCXStringWrapper(libclang.getCursorKindSpelling(Kind))

proc getDefinitionSpellingAndExtent*(a2: CXCursorWrapper; 
                                     startBuf: cstringArray; 
                                     endBuf: cstringArray; startLine: var cuint; 
                                     startColumn: var cuint; endLine: var cuint; 
                                     endColumn: var cuint) = 
  let cU = a2.unwrap()                                   
  libclang.getDefinitionSpellingAndExtent(cU[], startBuf, endBuf, 
      addr(startLine), addr(startColumn), addr(endLine), addr(endColumn))

proc getCompletionChunkText*(completion_string: CXCompletionString; 
                             chunk_number: cuint): CXStringWrapper = 
  return newCXStringWrapper(libclang.getCompletionChunkText(completion_string, 
      chunk_number))

proc getCompletionAnnotation*(completion_string: CXCompletionString; 
                              annotation_number: cuint): CXStringWrapper = 
  return newCXStringWrapper(libclang.getCompletionAnnotation(completion_string, 
      annotation_number))

proc getCompletionParent*(completion_string: CXCompletionString; 
                          kind: var CXCursorKind): CXStringWrapper = 
  return newCXStringWrapper(libclang.getCompletionParent(completion_string, 
      addr(kind)))

proc getCompletionBriefComment*(completion_string: CXCompletionString): CXStringWrapper = 
  return newCXStringWrapper(libclang.getCompletionBriefComment(completion_string))

proc getCursorCompletionString*(cursor: CXCursorWrapper): CXCompletionString =
  let cU = cursor.unWrap() 
  return libclang.getCursorCompletionString(cU[])

proc codeCompleteAt*(TU: CXTranslationUnitWrapper; complete_filename: cstring; 
                     complete_line: cuint; complete_column: cuint; 
                     unsaved_files: var CXUnsavedFile; num_unsaved_files: cuint; 
                     options: cuint): CXCodeCompleteResultsWrapper = 
  return newCXCodeCompleteResultsWrapper(libclang.codeCompleteAt(TU.data, 
      complete_filename, complete_line, complete_column, addr(unsaved_files), 
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

proc getRemappings*(path: cstring): CXRemappingWrapper = 
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

proc findReferencesInFile*(cursor: CXCursorWrapper; file: CXFile; 
                           visitor: CXCursorAndRangeVisitor): CXResult = 
  let cU = cursor.unWrap()
  return libclang.findReferencesInFile(cU[], file, visitor)

proc findIncludesInFile*(TU: CXTranslationUnitWrapper; file: CXFile; 
                         visitor: CXCursorAndRangeVisitor): CXResult = 
  return libclang.findIncludesInFile(TU.data, file, visitor)

proc createIndexAction*(CIdx: CXIndexWrapper): CXIndexActionWrapper = 
  return newCXIndexActionWrapper(libclang.createIndexAction(CIdx.data))

proc indexSourceFile*(a2: CXIndexActionWrapper; client_data: CXClientData; 
                      index_callbacks: var IndexerCallbacks; 
                      index_callbacks_size: cuint; index_options: cuint; 
                      source_filename: cstring; command_line_args: cstringArray; 
                      num_command_line_args: cint; 
                      unsaved_files: var CXUnsavedFile; 
                      num_unsaved_files: cuint; 
                      out_TU: CXTranslationUnitWrapper; TU_options: cuint): cint = 
  return libclang.indexSourceFile(a2.data, client_data, addr(index_callbacks), 
                                  index_callbacks_size, index_options, 
                                  source_filename, command_line_args, 
                                  num_command_line_args, addr(unsaved_files), 
                                  num_unsaved_files, addr(out_TU.data), 
                                  TU_options)

proc indexTranslationUnit*(a2: CXIndexActionWrapper; client_data: CXClientData; 
                           index_callbacks: var IndexerCallbacks; 
                           index_callbacks_size: cuint; index_options: cuint; 
                           a7: CXTranslationUnitWrapper): cint = 
  return libclang.indexTranslationUnit(a2.data, client_data, 
                                       addr(index_callbacks), 
                                       index_callbacks_size, index_options, 
                                       a7.data)

when isMainModule:
  echo getClangVersion()
  
