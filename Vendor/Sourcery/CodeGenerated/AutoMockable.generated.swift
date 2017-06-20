// Generated using Sourcery 0.6.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif


class ApplicationMock: Application {


    //MARK: - terminate

    var terminateCalled = false
    var terminateReceivedSender: Any?

    func terminate(_ sender: Any?) {

        terminateCalled = true
        terminateReceivedSender = sender
    }
}
class ApplicationNameExtractorMock: ApplicationNameExtractor {


    //MARK: - extractApplicationName

    var extractApplicationNameCalled = false
    var extractApplicationNameReceivedLogLine: ApplicationLogLine?
    var extractApplicationNameReturnValue: String!

    func extractApplicationName(from logLine: ApplicationLogLine) -> String {

        extractApplicationNameCalled = true
        extractApplicationNameReceivedLogLine = logLine
        return extractApplicationNameReturnValue
    }
}
class ConfigurationStorageMock: ConfigurationStorage {


    //MARK: - loadConfiguration

    var loadConfigurationCalled = false
    var loadConfigurationReturnValue: Configuration?

    func loadConfiguration() -> Configuration? {

        loadConfigurationCalled = true
        return loadConfigurationReturnValue
    }
    //MARK: - save

    var saveCalled = false
    var saveReceivedConfiguration: Configuration?

    func save(configuration: Configuration) {

        saveCalled = true
        saveReceivedConfiguration = configuration
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
class MenuInteractorInputMock: MenuInteractorInput {

    var foundTestResults: [SnapshotTestResult] = []

    //MARK: - startXcodeBuildsListening

    var startXcodeBuildsListeningCalled = false
    var startXcodeBuildsListeningReceivedDerivedDataFolder: DerivedDataFolder?

    func startXcodeBuildsListening(derivedDataFolder: DerivedDataFolder) {

        startXcodeBuildsListeningCalled = true
        startXcodeBuildsListeningReceivedDerivedDataFolder = derivedDataFolder
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
    //MARK: - showPreferences

    var showPreferencesCalled = false

    func showPreferences() {

        showPreferencesCalled = true
    }
    //MARK: - showApplicationMenu

    var showApplicationMenuCalled = false

    func showApplicationMenu() {

        showApplicationMenuCalled = true
    }
    //MARK: - checkForUpdates

    var checkForUpdatesCalled = false

    func checkForUpdates() {

        checkForUpdatesCalled = true
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
class PreferencesInteractorInputMock: PreferencesInteractorInput {


    //MARK: - save

    var saveCalled = false

    func save() {

        saveCalled = true
    }
    //MARK: - currentConfiguration

    var currentConfigurationCalled = false
    var currentConfigurationReturnValue: Configuration!

    func currentConfiguration() -> Configuration {

        currentConfigurationCalled = true
        return currentConfigurationReturnValue
    }
    //MARK: - setNewDerivedDataFolderType

    var setNewDerivedDataFolderTypeCalled = false
    var setNewDerivedDataFolderTypeReceivedType: String?

    func setNewDerivedDataFolderType(_ type: String) {

        setNewDerivedDataFolderTypeCalled = true
        setNewDerivedDataFolderTypeReceivedType = type
    }
    //MARK: - setNewDerivedDataFolderPath

    var setNewDerivedDataFolderPathCalled = false
    var setNewDerivedDataFolderPathReceivedPath: String?

    func setNewDerivedDataFolderPath(_ path: String) {

        setNewDerivedDataFolderPathCalled = true
        setNewDerivedDataFolderPathReceivedPath = path
    }
}
class PreferencesModuleDelegateMock: PreferencesModuleDelegate {


    //MARK: - preferencesModuleWillClose

    var preferencesModuleWillCloseCalled = false
    var preferencesModuleWillCloseReceivedPreferencesModule: PreferencesModuleInterface?

    func preferencesModuleWillClose(_ preferencesModule: PreferencesModuleInterface) {

        preferencesModuleWillCloseCalled = true
        preferencesModuleWillCloseReceivedPreferencesModule = preferencesModule
    }
}
class PreferencesModuleInterfaceMock: PreferencesModuleInterface {


    //MARK: - close

    var closeCalled = false

    func close() {

        closeCalled = true
    }
    //MARK: - updateUserInterface

    var updateUserInterfaceCalled = false

    func updateUserInterface() {

        updateUserInterfaceCalled = true
    }
    //MARK: - select

    var selectCalled = false
    var selectReceivedDerivedDataFolderType: String?

    func select(derivedDataFolderType: String) {

        selectCalled = true
        selectReceivedDerivedDataFolderType = derivedDataFolderType
    }
    //MARK: - update

    var updateCalled = false
    var updateReceivedDerivedDataFolderPath: String?

    func update(derivedDataFolderPath: String) {

        updateCalled = true
        updateReceivedDerivedDataFolderPath = derivedDataFolderPath
    }
}
class PreferencesUserInterfaceMock: PreferencesUserInterface {


    //MARK: - show

    var showCalled = false
    var showReceivedPreferencesDisplayInfo: PreferencesDisplayInfo?

    func show(preferencesDisplayInfo: PreferencesDisplayInfo) {

        showCalled = true
        showReceivedPreferencesDisplayInfo = preferencesDisplayInfo
    }
}
class TestResultCellDelegateMock: TestResultCellDelegate {


    //MARK: - testResultCell

    var testResultCellCalled = false
    var testResultCellReceivedArguments: (cell: TestResultCell, viewInKaleidoscopeButtonClicked: NSButton)?

    func testResultCell(_ cell: TestResultCell, viewInKaleidoscopeButtonClicked: NSButton) {

        testResultCellCalled = true
        testResultCellReceivedArguments = (cell: cell, viewInKaleidoscopeButtonClicked: viewInKaleidoscopeButtonClicked)
    }
}
class TestResultsInteractorInputMock: TestResultsInteractorInput {

    var testResults: [SnapshotTestResult] = []

    //MARK: - openInKaleidoscope

    var openInKaleidoscopeCalled = false
    var openInKaleidoscopeReceivedTestResult: SnapshotTestResult?

    func openInKaleidoscope(testResult: SnapshotTestResult) {

        openInKaleidoscopeCalled = true
        openInKaleidoscopeReceivedTestResult = testResult
    }
}
class TestResultsModuleInterfaceMock: TestResultsModuleInterface {


    //MARK: - updateUserInterface

    var updateUserInterfaceCalled = false

    func updateUserInterface() {

        updateUserInterfaceCalled = true
    }
    //MARK: - openInKaleidoscope

    var openInKaleidoscopeCalled = false
    var openInKaleidoscopeReceivedTestResultDisplayInfo: TestResultDisplayInfo?

    func openInKaleidoscope(testResultDisplayInfo: TestResultDisplayInfo) {

        openInKaleidoscopeCalled = true
        openInKaleidoscopeReceivedTestResultDisplayInfo = testResultDisplayInfo
    }
    //MARK: - selectDiffMode

    var selectDiffModeCalled = false
    var selectDiffModeReceivedDiffMode: TestResultsDiffMode?

    func selectDiffMode(_ diffMode: TestResultsDiffMode) {

        selectDiffModeCalled = true
        selectDiffModeReceivedDiffMode = diffMode
    }
}
class TestResultsUserInterfaceMock: TestResultsUserInterface {


    //MARK: - show

    var showCalled = false
    var showReceivedDisplayInfo: TestResultsDisplayInfo?

    func show(displayInfo: TestResultsDisplayInfo) {

        showCalled = true
        showReceivedDisplayInfo = displayInfo
    }
}
class UpdaterMock: Updater {


    //MARK: - checkForUpdates

    var checkForUpdatesCalled = false

    func checkForUpdates() {

        checkForUpdatesCalled = true
    }
}
