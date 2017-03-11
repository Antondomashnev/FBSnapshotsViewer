// Generated using Sourcery 0.5.8 — https://github.com/krzysztofzablocki/Sourcery
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
// MARK: - Application AutoEquatable
extension Application: Equatable {} 
internal func == (lhs: Application, rhs: Application) -> Bool {
    guard lhs.snapshotsDiffFolder == rhs.snapshotsDiffFolder else { return false }
    return true
}
// MARK: - CompletedTestResult AutoEquatable
extension CompletedTestResult: Equatable {} 
internal func == (lhs: CompletedTestResult, rhs: CompletedTestResult) -> Bool {
    guard lhs.referenceImagePath == rhs.referenceImagePath else { return false }
    guard lhs.diffImagePath == rhs.diffImagePath else { return false }
    guard lhs.failedImagePath == rhs.failedImagePath else { return false }
    guard lhs.testName == rhs.testName else { return false }
    return true
}
// MARK: - PendingTestResult AutoEquatable
extension PendingTestResult: Equatable {} 
internal func == (lhs: PendingTestResult, rhs: PendingTestResult) -> Bool {
    guard lhs.referenceImagePath == rhs.referenceImagePath else { return false }
    guard lhs.diffImagePath == rhs.diffImagePath else { return false }
    guard lhs.failedImagePath == rhs.failedImagePath else { return false }
    guard lhs.testName == rhs.testName else { return false }
    return true
}
// MARK: - TestResult AutoEquatable
internal func == (lhs: TestResult, rhs: TestResult) -> Bool {
    guard lhs.referenceImagePath == rhs.referenceImagePath else { return false }
    guard lhs.diffImagePath == rhs.diffImagePath else { return false }
    guard lhs.failedImagePath == rhs.failedImagePath else { return false }
    guard lhs.testName == rhs.testName else { return false }
    return true
}

// MARK: - AutoEquatable for Enums

// MARK: -
