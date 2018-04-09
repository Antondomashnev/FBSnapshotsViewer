// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
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
// MARK: - Build AutoEquatable
extension Build: Equatable {} 
internal func == (lhs: Build, rhs: Build) -> Bool {
    guard lhs.date == rhs.date else { return false }
    guard lhs.applicationName == rhs.applicationName else { return false }
    guard lhs.fbReferenceImageDirectoryURLs == rhs.fbReferenceImageDirectoryURLs else { return false }
    return true
}
// MARK: - SnapshotTestInformation AutoEquatable
extension SnapshotTestInformation: Equatable {} 
internal func == (lhs: SnapshotTestInformation, rhs: SnapshotTestInformation) -> Bool {
    guard lhs.testClassName == rhs.testClassName else { return false }
    guard lhs.testName == rhs.testName else { return false }
    guard lhs.testFilePath == rhs.testFilePath else { return false }
    guard lhs.testLineNumber == rhs.testLineNumber else { return false }
    return true
}
// MARK: - TestResultDisplayInfo AutoEquatable
extension TestResultDisplayInfo: Equatable {} 
internal func == (lhs: TestResultDisplayInfo, rhs: TestResultDisplayInfo) -> Bool {
    guard lhs.referenceImageURL == rhs.referenceImageURL else { return false }
    guard compareOptionals(lhs: lhs.diffImageURL, rhs: rhs.diffImageURL, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.failedImageURL, rhs: rhs.failedImageURL, compare: ==) else { return false }
    guard lhs.options == rhs.options else { return false }
    guard lhs.testInformation == rhs.testInformation else { return false }
    guard lhs.testResult == rhs.testResult else { return false }
    return true
}
// MARK: - TestResultInformationDisplayInfo AutoEquatable
extension TestResultInformationDisplayInfo: Equatable {} 
internal func == (lhs: TestResultInformationDisplayInfo, rhs: TestResultInformationDisplayInfo) -> Bool {
    guard lhs.testName == rhs.testName else { return false }
    guard lhs.testContext == rhs.testContext else { return false }
    return true
}
// MARK: - TestResultsDisplayInfo AutoEquatable
extension TestResultsDisplayInfo: Equatable {} 
internal func == (lhs: TestResultsDisplayInfo, rhs: TestResultsDisplayInfo) -> Bool {
    guard lhs.sectionInfos == rhs.sectionInfos else { return false }
    guard lhs.topTitle == rhs.topTitle else { return false }
    guard lhs.testResultsDiffMode == rhs.testResultsDiffMode else { return false }
    return true
}
// MARK: - TestResultsSectionDisplayInfo AutoEquatable
extension TestResultsSectionDisplayInfo: Equatable {} 
internal func == (lhs: TestResultsSectionDisplayInfo, rhs: TestResultsSectionDisplayInfo) -> Bool {
    guard lhs.titleInfo == rhs.titleInfo else { return false }
    guard lhs.itemInfos == rhs.itemInfos else { return false }
    return true
}
// MARK: - TestResultsSectionTitleDisplayInfo AutoEquatable
extension TestResultsSectionTitleDisplayInfo: Equatable {} 
internal func == (lhs: TestResultsSectionTitleDisplayInfo, rhs: TestResultsSectionTitleDisplayInfo) -> Bool {
    guard lhs.title == rhs.title else { return false }
    guard lhs.timeAgo == rhs.timeAgo else { return false }
    guard lhs.timeAgoDate == rhs.timeAgoDate else { return false }
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
    case (.applicationNameMessage(let lhs), .applicationNameMessage(let rhs)): 
        return lhs == rhs
    case (.fbReferenceImageDirMessage(let lhs), .fbReferenceImageDirMessage(let rhs)): 
        return lhs == rhs
    case (.snapshotTestErrorMessage(let lhs), .snapshotTestErrorMessage(let rhs)): 
        return lhs == rhs
    case (.unknown, .unknown): 
         return true 
    default: return false
    }
}
// MARK: - DerivedDataFolder AutoEquatable
extension DerivedDataFolder: Equatable {}
internal func == (lhs: DerivedDataFolder, rhs: DerivedDataFolder) -> Bool {
    switch (lhs, rhs) {
    case (.xcodeCustom(let lhs), .xcodeCustom(let rhs)): 
        return lhs == rhs
    case (.xcodeDefault, .xcodeDefault): 
         return true 
    case (.appcode(let lhs), .appcode(let rhs)): 
        return lhs == rhs
    default: return false
    }
}
// MARK: - DerivedDataFolderType AutoEquatable
extension DerivedDataFolderType: Equatable {}
internal func == (lhs: DerivedDataFolderType, rhs: DerivedDataFolderType) -> Bool {
    switch (lhs, rhs) {
    case (.xcodeDefault, .xcodeDefault): 
         return true 
    case (.xcodeCustom, .xcodeCustom): 
         return true 
    case (.appcode, .appcode): 
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
        if lhs.testInformation != rhs.testInformation { return false }
        if lhs.referenceImagePath != rhs.referenceImagePath { return false }
        if lhs.build != rhs.build { return false }
        return true
    case (.rejected(let lhs), .rejected(let rhs)): 
        if lhs.testInformation != rhs.testInformation { return false }
        if lhs.referenceImagePath != rhs.referenceImagePath { return false }
        if lhs.build != rhs.build { return false }
        return true
    case (.failed(let lhs), .failed(let rhs)): 
        if lhs.testInformation != rhs.testInformation { return false }
        if lhs.referenceImagePath != rhs.referenceImagePath { return false }
        if lhs.diffImagePath != rhs.diffImagePath { return false }
        if lhs.failedImagePath != rhs.failedImagePath { return false }
        if lhs.build != rhs.build { return false }
        return true
    default: return false
    }
}
// MARK: - TestResultsDiffMode AutoEquatable
extension TestResultsDiffMode: Equatable {}
internal func == (lhs: TestResultsDiffMode, rhs: TestResultsDiffMode) -> Bool {
    switch (lhs, rhs) {
    case (.diff, .diff): 
         return true 
    case (.mouseOver, .mouseOver): 
         return true 
    default: return false
    }
}

// MARK: -
