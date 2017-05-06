// Generated using Sourcery 0.5.9 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



class ApplicationMock: Application {


    //MARK: - terminate

    var terminateCalled = false
    var terminateReceivedSender: Any?

    func terminate(_ sender: Any?) {

        terminateCalled = true
        terminateReceivedSender = sender
    }
}
class FolderEventsListenerMock: FolderEventsListener {

    var output: FolderEventsListenerOutput?

    //MARK: - init

    var initReceivedArguments: (folderPath: String, filter: FolderEventFilter?, fileWatcherFactory: FileWatcherFactory)?

    required init(folderPath: String, filter: FolderEventFilter?, fileWatcherFactory: FileWatcherFactory) {
        initReceivedArguments = (folderPath: folderPath, filter: filter, fileWatcherFactory: fileWatcherFactory)
    }
    //MARK: - startListening

    var startListeningCalled = false

    func startListening() {

        startListeningCalled = true
    }
    //MARK: - stopListening

    var stopListeningCalled = false

    func stopListening() {

        stopListeningCalled = true
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
class ListMock: List {


    //MARK: - reloadData

    var reloadDataCalled = false

    func reloadData() {

        reloadDataCalled = true
    }
}
class MenuInteractorInputMock: MenuInteractorInput {

    var foundTestResults: [SnapshotTestResult] = []

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


    //MARK: - didFindNewTestResult

    var didFindNewTestResultCalled = false
    var didFindNewTestResultReceivedTestResult: SnapshotTestResult?

    func didFindNewTestResult(_ testResult: SnapshotTestResult) {

        didFindNewTestResultCalled = true
        didFindNewTestResultReceivedTestResult = testResult
    }
    //MARK: - didFindNewTestLogFile

    var didFindNewTestLogFileCalled = false
    var didFindNewTestLogFileReceivedPath: String?

    func didFindNewTestLogFile(at path: String) {

        didFindNewTestLogFileCalled = true
        didFindNewTestLogFileReceivedPath = path
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
class TestResultsInteractorInputMock: TestResultsInteractorInput {

    var testResults: [SnapshotTestResult] = []

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
