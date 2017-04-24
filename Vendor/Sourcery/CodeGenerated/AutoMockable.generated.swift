// Generated using Sourcery 0.5.9 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Cocoa

class ApplicationSnapshotTestImageCollectorOutputMock: ApplicationSnapshotTestImageCollectorOutput {


    //MARK: - applicationSnapshotTestResultCollector

    var applicationSnapshotTestResultCollectorCalled = false
    var applicationSnapshotTestResultCollectorReceivedArguments: (collector: ApplicationSnapshotTestImageCollector, testResult: TestResult)?

    func applicationSnapshotTestResultCollector(_ collector: ApplicationSnapshotTestImageCollector, didCollect testResult: TestResult) {

        applicationSnapshotTestResultCollectorCalled = true
        applicationSnapshotTestResultCollectorReceivedArguments = (collector: collector, testResult: testResult)
    }

}
class FolderEventsListenerOutputMock: FolderEventsListenerOutput {


    //MARK: - folderEventsListener

    var folderEventsListenerCalled = false
    var folderEventsListenerReceivedArguments: (listener: FolderEventsListener, event: FolderEvent)?

    func folderEventsListener(_ listener: FolderEventsListener, didReceive event: FolderEvent) {

        folderEventsListenerCalled = true
        folderEventsListenerReceivedArguments = (listener: listener, event: event)
    }

}
class MenuInteractorInputMock: MenuInteractorInput {

    var foundTestResults: [TestResult] = []

    //MARK: - startXcodeBuildsListening

    var startXcodeBuildsListeningCalled = false
    var startXcodeBuildsListeningReceivedXcodeDerivedDataFolder: XcodeDerivedDataFolder?

    func startXcodeBuildsListening(xcodeDerivedDataFolder: XcodeDerivedDataFolder) {

        startXcodeBuildsListeningCalled = true
        startXcodeBuildsListeningReceivedXcodeDerivedDataFolder = xcodeDerivedDataFolder
    }

    //MARK: - startSnapshotTestResultListening

    var startSnapshotTestResultListeningCalled = false
    var startSnapshotTestResultListeningReceivedPath: String?

    func startSnapshotTestResultListening(fromLogFileAt path: String) {

        startSnapshotTestResultListeningCalled = true
        startSnapshotTestResultListeningReceivedPath = path
    }

}
class MenuInteractorOutputMock: MenuInteractorOutput {


    //MARK: - didFind

    var didFindCalled = false
    var didFindReceivedTestResult: TestResult?

    func didFind(newTestResult testResult: TestResult) {

        didFindCalled = true
        didFindReceivedTestResult = testResult
    }

    //MARK: - didFind

    var didFindCalled = false
    var didFindReceivedPath: String?

    func didFind(newTestLogFileAt path: String) {

        didFindCalled = true
        didFindReceivedPath = path
    }

}
class MenuModuleInterfaceMock: MenuModuleInterface {


    //MARK: - start

    var startCalled = false

    func start() {

        startCalled = true
    }

    //MARK: - showTestResults

    var showTestResultsCalled = false

    func showTestResults() {

        showTestResultsCalled = true
    }

    //MARK: - showApplicationMenu

    var showApplicationMenuCalled = false

    func showApplicationMenu() {

        showApplicationMenuCalled = true
    }

    //MARK: - quit

    var quitCalled = false

    func quit() {

        quitCalled = true
    }

}
class MenuUserInterfaceMock: MenuUserInterface {


    //MARK: - setNewTestResults

    var setNewTestResultsCalled = false
    var setNewTestResultsReceivedAvailable: Bool?

    func setNewTestResults(available: Bool) {

        setNewTestResultsCalled = true
        setNewTestResultsReceivedAvailable = available
    }

    //MARK: - popUpOptionsMenu

    var popUpOptionsMenuCalled = false

    func popUpOptionsMenu() {

        popUpOptionsMenuCalled = true
    }

}
class SnapshotsViewerApplicationRunNotificationListenerDelegateMock: SnapshotsViewerApplicationRunNotificationListenerDelegate {


    //MARK: - snapshotsDiffFolderNotificationListener

    var snapshotsDiffFolderNotificationListenerCalled = false
    var snapshotsDiffFolderNotificationListenerReceivedArguments: (listener: SnapshotsViewerApplicationRunNotificationListener, simulatorPath: String, imageDiffPath: String?)?

    func snapshotsDiffFolderNotificationListener(_ listener: SnapshotsViewerApplicationRunNotificationListener, didReceiveRunningiOSSimulatorFolder simulatorPath: String, andImageDiffFolder imageDiffPath: String?) {

        snapshotsDiffFolderNotificationListenerCalled = true
        snapshotsDiffFolderNotificationListenerReceivedArguments = (listener: listener, simulatorPath: simulatorPath, imageDiffPath: imageDiffPath)
    }

}
class TestResultsInteractorInputMock: TestResultsInteractorInput {

    var testResults: [TestResult] = []

}
class TestResultsModuleInterfaceMock: TestResultsModuleInterface {


    //MARK: - updateUserInterface

    var updateUserInterfaceCalled = false

    func updateUserInterface() {

        updateUserInterfaceCalled = true
    }

}
class TestResultsUserInterfaceMock: TestResultsUserInterface {


    //MARK: - show

    var showCalled = false
    var showReceivedTestResults: [TestResultDisplayInfo]?

    func show(testResults: [TestResultDisplayInfo]) {

        showCalled = true
        showReceivedTestResults = testResults
    }

}
