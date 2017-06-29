// Generated using Sourcery 0.6.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif


class ApplicationMock: Application {


    //MARK: - terminate

    var terminate_Called = false
    var terminate_ReceivedSender: Any?

    func terminate(_ sender: Any?) {

        terminate_Called = true
        terminate_ReceivedSender = sender
    }
}
class ApplicationNameExtractorMock: ApplicationNameExtractor {


    //MARK: - extractApplicationName

    var extractApplicationNamefromCalled = false
    var extractApplicationNamefromReceivedLogLine: ApplicationLogLine?
    var extractApplicationNamefromReturnValue: String!

    func extractApplicationName(from logLine: ApplicationLogLine) -> String {

        extractApplicationNamefromCalled = true
        extractApplicationNamefromReceivedLogLine = logLine
        return extractApplicationNamefromReturnValue
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

    var saveconfigurationCalled = false
    var saveconfigurationReceivedConfiguration: Configuration?

    func save(configuration: Configuration) {

        saveconfigurationCalled = true
        saveconfigurationReceivedConfiguration = configuration
    }
}
class FBReferenceImageDirectoryURLExtractorMock: FBReferenceImageDirectoryURLExtractor {


    //MARK: - extractImageDirectoryURL

    var extractImageDirectoryURLfromCalled = false
    var extractImageDirectoryURLfromReceivedLogLine: ApplicationLogLine?
    var extractImageDirectoryURLfromReturnValue: URL!

    func extractImageDirectoryURL(from logLine: ApplicationLogLine) -> URL {

        extractImageDirectoryURLfromCalled = true
        extractImageDirectoryURLfromReceivedLogLine = logLine
        return extractImageDirectoryURLfromReturnValue
    }
}
class FolderEventsListenerMock: FolderEventsListener {

    var output: FolderEventsListenerOutput?

    //MARK: - init

    var initfolderPathfilterfileWatcherFactoryReceivedArguments: (folderPath: String, filter: FolderEventFilter?, fileWatcherFactory: FileWatcherFactory)?

    required init(folderPath: String, filter: FolderEventFilter?, fileWatcherFactory: FileWatcherFactory) {
        initfolderPathfilterfileWatcherFactoryReceivedArguments = (folderPath: folderPath, filter: filter, fileWatcherFactory: fileWatcherFactory)
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

    var folderEventsListener_didReceiveCalled = false
    var folderEventsListener_didReceiveReceivedArguments: (listener: FolderEventsListener, event: FolderEvent)?

    func folderEventsListener(_ listener: FolderEventsListener, didReceive event: FolderEvent) {

        folderEventsListener_didReceiveCalled = true
        folderEventsListener_didReceiveReceivedArguments = (listener: listener, event: event)
    }
}
class MenuInteractorInputMock: MenuInteractorInput {

    var foundTestResults: [SnapshotTestResult] = []

    //MARK: - startXcodeBuildsListening

    var startXcodeBuildsListeningderivedDataFolderCalled = false
    var startXcodeBuildsListeningderivedDataFolderReceivedDerivedDataFolder: DerivedDataFolder?

    func startXcodeBuildsListening(derivedDataFolder: DerivedDataFolder) {

        startXcodeBuildsListeningderivedDataFolderCalled = true
        startXcodeBuildsListeningderivedDataFolderReceivedDerivedDataFolder = derivedDataFolder
    }
    //MARK: - startSnapshotTestResultListening

    var startSnapshotTestResultListeningfromLogFileAtCalled = false
    var startSnapshotTestResultListeningfromLogFileAtReceivedPath: String?

    func startSnapshotTestResultListening(fromLogFileAt path: String) {

        startSnapshotTestResultListeningfromLogFileAtCalled = true
        startSnapshotTestResultListeningfromLogFileAtReceivedPath = path
    }
}
class MenuInteractorOutputMock: MenuInteractorOutput {


    //MARK: - didFindNewTestResult

    var didFindNewTestResult_Called = false
    var didFindNewTestResult_ReceivedTestResult: SnapshotTestResult?

    func didFindNewTestResult(_ testResult: SnapshotTestResult) {

        didFindNewTestResult_Called = true
        didFindNewTestResult_ReceivedTestResult = testResult
    }
    //MARK: - didFindNewTestLogFile

    var didFindNewTestLogFileatCalled = false
    var didFindNewTestLogFileatReceivedPath: String?

    func didFindNewTestLogFile(at path: String) {

        didFindNewTestLogFileatCalled = true
        didFindNewTestLogFileatReceivedPath = path
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

    var setNewTestResultsavailableCalled = false
    var setNewTestResultsavailableReceivedAvailable: Bool?

    func setNewTestResults(available: Bool) {

        setNewTestResultsavailableCalled = true
        setNewTestResultsavailableReceivedAvailable = available
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

    var setNewDerivedDataFolderType_Called = false
    var setNewDerivedDataFolderType_ReceivedType: String?

    func setNewDerivedDataFolderType(_ type: String) {

        setNewDerivedDataFolderType_Called = true
        setNewDerivedDataFolderType_ReceivedType = type
    }
    //MARK: - setNewDerivedDataFolderPath

    var setNewDerivedDataFolderPath_Called = false
    var setNewDerivedDataFolderPath_ReceivedPath: String?

    func setNewDerivedDataFolderPath(_ path: String) {

        setNewDerivedDataFolderPath_Called = true
        setNewDerivedDataFolderPath_ReceivedPath = path
    }
}
class PreferencesModuleDelegateMock: PreferencesModuleDelegate {


    //MARK: - preferencesModuleWillClose

    var preferencesModuleWillClose_Called = false
    var preferencesModuleWillClose_ReceivedPreferencesModule: PreferencesModuleInterface?

    func preferencesModuleWillClose(_ preferencesModule: PreferencesModuleInterface) {

        preferencesModuleWillClose_Called = true
        preferencesModuleWillClose_ReceivedPreferencesModule = preferencesModule
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

    var selectderivedDataFolderTypeCalled = false
    var selectderivedDataFolderTypeReceivedDerivedDataFolderType: String?

    func select(derivedDataFolderType: String) {

        selectderivedDataFolderTypeCalled = true
        selectderivedDataFolderTypeReceivedDerivedDataFolderType = derivedDataFolderType
    }
    //MARK: - update

    var updatederivedDataFolderPathCalled = false
    var updatederivedDataFolderPathReceivedDerivedDataFolderPath: String?

    func update(derivedDataFolderPath: String) {

        updatederivedDataFolderPathCalled = true
        updatederivedDataFolderPathReceivedDerivedDataFolderPath = derivedDataFolderPath
    }
}
class PreferencesUserInterfaceMock: PreferencesUserInterface {


    //MARK: - show

    var showpreferencesDisplayInfoCalled = false
    var showpreferencesDisplayInfoReceivedPreferencesDisplayInfo: PreferencesDisplayInfo?

    func show(preferencesDisplayInfo: PreferencesDisplayInfo) {

        showpreferencesDisplayInfoCalled = true
        showpreferencesDisplayInfoReceivedPreferencesDisplayInfo = preferencesDisplayInfo
    }
}
class TestResultCellDelegateMock: TestResultCellDelegate {


    //MARK: - testResultCell

    var testResultCell_viewInKaleidoscopeButtonClickedCalled = false
    var testResultCell_viewInKaleidoscopeButtonClickedReceivedArguments: (cell: TestResultCell, viewInKaleidoscopeButtonClicked: NSButton)?

    func testResultCell(_ cell: TestResultCell, viewInKaleidoscopeButtonClicked: NSButton) {

        testResultCell_viewInKaleidoscopeButtonClickedCalled = true
        testResultCell_viewInKaleidoscopeButtonClickedReceivedArguments = (cell: cell, viewInKaleidoscopeButtonClicked: viewInKaleidoscopeButtonClicked)
    }
    //MARK: - testResultCell

    var testResultCell_swapSnapshotsButtonClickedCalled = false
    var testResultCell_swapSnapshotsButtonClickedReceivedArguments: (cell: TestResultCell, swapSnapshotsButtonClicked: NSButton)?

    func testResultCell(_ cell: TestResultCell, swapSnapshotsButtonClicked: NSButton) {

        testResultCell_swapSnapshotsButtonClickedCalled = true
        testResultCell_swapSnapshotsButtonClickedReceivedArguments = (cell: cell, swapSnapshotsButtonClicked: swapSnapshotsButtonClicked)
    }
}
class TestResultsHeaderDelegateMock: TestResultsHeaderDelegate {


    //MARK: - testResultsHeader

    var testResultsHeader_swapSnapshotsButtonClickedCalled = false
    var testResultsHeader_swapSnapshotsButtonClickedReceivedArguments: (header: TestResultsHeader, swapSnapshotsButtonClicked: NSButton)?

    func testResultsHeader(_ header: TestResultsHeader, swapSnapshotsButtonClicked: NSButton) {

        testResultsHeader_swapSnapshotsButtonClickedCalled = true
        testResultsHeader_swapSnapshotsButtonClickedReceivedArguments = (header: header, swapSnapshotsButtonClicked: swapSnapshotsButtonClicked)
    }
}
class TestResultsInteractorInputMock: TestResultsInteractorInput {

    var testResults: [SnapshotTestResult] = []

    //MARK: - openInKaleidoscope

    var openInKaleidoscopetestResultCalled = false
    var openInKaleidoscopetestResultReceivedTestResult: SnapshotTestResult?

    func openInKaleidoscope(testResult: SnapshotTestResult) {

        openInKaleidoscopetestResultCalled = true
        openInKaleidoscopetestResultReceivedTestResult = testResult
    }
    //MARK: - swap

    var swaptestResultCalled = false
    var swaptestResultReceivedTestResult: SnapshotTestResult?

    func swap(testResult: SnapshotTestResult) {

        swaptestResultCalled = true
        swaptestResultReceivedTestResult = testResult
    }
}
class TestResultsInteractorOutputMock: TestResultsInteractorOutput {


    //MARK: - didFailToSwap

    var didFailToSwaptestResultwithCalled = false
    var didFailToSwaptestResultwithReceivedArguments: (testResult: SnapshotTestResult, error: Error)?

    func didFailToSwap(testResult: SnapshotTestResult, with error: Error) {

        didFailToSwaptestResultwithCalled = true
        didFailToSwaptestResultwithReceivedArguments = (testResult: testResult, error: error)
    }
}
class TestResultsModuleInterfaceMock: TestResultsModuleInterface {


    //MARK: - updateUserInterface

    var updateUserInterfaceCalled = false

    func updateUserInterface() {

        updateUserInterfaceCalled = true
    }
    //MARK: - openInKaleidoscope

    var openInKaleidoscopetestResultDisplayInfoCalled = false
    var openInKaleidoscopetestResultDisplayInfoReceivedTestResultDisplayInfo: TestResultDisplayInfo?

    func openInKaleidoscope(testResultDisplayInfo: TestResultDisplayInfo) {

        openInKaleidoscopetestResultDisplayInfoCalled = true
        openInKaleidoscopetestResultDisplayInfoReceivedTestResultDisplayInfo = testResultDisplayInfo
    }
    //MARK: - selectDiffMode

    var selectDiffMode_Called = false
    var selectDiffMode_ReceivedDiffMode: TestResultsDiffMode?

    func selectDiffMode(_ diffMode: TestResultsDiffMode) {

        selectDiffMode_Called = true
        selectDiffMode_ReceivedDiffMode = diffMode
    }
    //MARK: - swap

    var swap_Called = false
    var swap_ReceivedTestResults: [TestResultDisplayInfo]?

    func swap(_ testResults: [TestResultDisplayInfo]) {

        swap_Called = true
        swap_ReceivedTestResults = testResults
    }
}
class TestResultsUserInterfaceMock: TestResultsUserInterface {


    //MARK: - show

    var showdisplayInfoCalled = false
    var showdisplayInfoReceivedDisplayInfo: TestResultsDisplayInfo?

    func show(displayInfo: TestResultsDisplayInfo) {

        showdisplayInfoCalled = true
        showdisplayInfoReceivedDisplayInfo = displayInfo
    }
}
class UpdaterMock: Updater {


    //MARK: - checkForUpdates

    var checkForUpdatesCalled = false

    func checkForUpdates() {

        checkForUpdatesCalled = true
    }
}
