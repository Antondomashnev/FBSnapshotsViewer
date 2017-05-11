// Generated using Sourcery 0.5.9 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable file_length
fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return compare(lValue, rValue)
    case (nil, nil):
        return true
    default:
        return false
    }
}

fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}

// MARK: - AutoEquatable for classes, protocols, structs
// MARK: - DerivedDataFolder AutoEquatable
extension DerivedDataFolder: Equatable {} 
internal func == (lhs: DerivedDataFolder, rhs: DerivedDataFolder) -> Bool {
    guard lhs.path == rhs.path else { return false }
    guard lhs.type == rhs.type else { return false }
    return true
}
// MARK: - TestResultDisplayInfo AutoEquatable
extension TestResultDisplayInfo: Equatable {} 
internal func == (lhs: TestResultDisplayInfo, rhs: TestResultDisplayInfo) -> Bool {
    guard lhs.referenceImageURL == rhs.referenceImageURL else { return false }
    guard compareOptionals(lhs: lhs.diffImageURL, rhs: rhs.diffImageURL, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.failedImageURL, rhs: rhs.failedImageURL, compare: ==) else { return false }
    guard lhs.testName == rhs.testName else { return false }
    guard lhs.canBeViewedInKaleidoscope == rhs.canBeViewedInKaleidoscope else { return false }
    guard lhs.testResult == rhs.testResult else { return false }
    return true
}

// MARK: - AutoEquatable for Enums
// MARK: - AppleInterfaceMode AutoEquatable
extension AppleInterfaceMode: Equatable {}
internal func == (lhs: AppleInterfaceMode, rhs: AppleInterfaceMode) -> Bool {
    switch (lhs, rhs) {
    case (.light, .light): 
         return true 
    case (.dark, .dark): 
         return true 
    default: return false
    }
}
// MARK: - ApplicationLogLine AutoEquatable
extension ApplicationLogLine: Equatable {}
internal func == (lhs: ApplicationLogLine, rhs: ApplicationLogLine) -> Bool {
    switch (lhs, rhs) {
    case (.kaleidoscopeCommandMessage(let lhs), .kaleidoscopeCommandMessage(let rhs)): 
        return lhs == rhs
    case (.referenceImageSavedMessage(let lhs), .referenceImageSavedMessage(let rhs)): 
        return lhs == rhs
    case (.unknown, .unknown): 
         return true 
    default: return false
    }
}
// MARK: - DerivedDataFolderType AutoEquatable
extension DerivedDataFolderType: Equatable {}
internal func == (lhs: DerivedDataFolderType, rhs: DerivedDataFolderType) -> Bool {
    switch (lhs, rhs) {
    case (.xcode, .xcode): 
         return true 
    case (.custom, .custom): 
         return true 
    default: return false
    }
}
// MARK: - FolderEventFilter AutoEquatable
extension FolderEventFilter: Equatable {}
internal func == (lhs: FolderEventFilter, rhs: FolderEventFilter) -> Bool {
    switch (lhs, rhs) {
    case (.known, .known): 
         return true 
    case (.pathRegex(let lhs), .pathRegex(let rhs)): 
        return lhs == rhs
    case (.type(let lhs), .type(let rhs)): 
        return lhs == rhs
    case (.compound(let lhs), .compound(let rhs)): 
        if lhs.0 != rhs.0 { return false }
        if lhs.1 != rhs.1 { return false }
        return true
    default: return false
    }
}
// MARK: - SnapshotTestResult AutoEquatable
extension SnapshotTestResult: Equatable {}
internal func == (lhs: SnapshotTestResult, rhs: SnapshotTestResult) -> Bool {
    switch (lhs, rhs) {
    case (.recorded(let lhs), .recorded(let rhs)): 
        if lhs.testName != rhs.testName { return false }
        if lhs.referenceImagePath != rhs.referenceImagePath { return false }
        return true
    case (.failed(let lhs), .failed(let rhs)): 
        if lhs.testName != rhs.testName { return false }
        if lhs.referenceImagePath != rhs.referenceImagePath { return false }
        if lhs.diffImagePath != rhs.diffImagePath { return false }
        if lhs.failedImagePath != rhs.failedImagePath { return false }
        return true
    default: return false
    }
}

// MARK: -
