// Generated using Sourcery 0.5.8 — https://github.com/krzysztofzablocki/Sourcery
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
class MenuInteractorOutputMock: MenuInteractorOutput {


    //MARK: - didFind

    var didFindCalled = false
    var didFindReceivedTestResult: TestResult?

    func didFind(new testResult: TestResult) {

        didFindCalled = true
        didFindReceivedTestResult = testResult
    }

}
class MenuModuleInterfaceMock: MenuModuleInterface {


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
