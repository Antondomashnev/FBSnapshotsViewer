// Generated using Sourcery 0.5.8 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Cocoa

class FolderEventsListenerOutputMock: FolderEventsListenerOutput {


    //MARK: - folderEventsListener

    var folderEventsListenerCalled = false
    var folderEventsListenerReceivedArguments: (listener: FolderEventsListener, event: FolderEvent)?

    func folderEventsListener(_ listener: FolderEventsListener, didReceive event: FolderEvent) {

        folderEventsListenerCalled = true
        folderEventsListenerReceivedArguments = (listener: listener, event: event)
    }

}
class MenuActionsMock: MenuActions {


    //MARK: - handleIconMouseEvent

    var handleIconMouseEventCalled = false
    var handleIconMouseEventReceivedEvent: NSEvent?

    func handleIconMouseEvent(_ event: NSEvent) {

        handleIconMouseEventCalled = true
        handleIconMouseEventReceivedEvent = event
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
