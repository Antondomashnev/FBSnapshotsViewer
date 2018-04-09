// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
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

    var terminate___Called = false
    var terminate___ReceivedSender: Any?

    func terminate(_ sender: Any?) {

        terminate___Called = true
        terminate___ReceivedSender = sender
    }
}
class ApplicationNameExtractorMock: ApplicationNameExtractor {


    //MARK: - extractApplicationName

    var extractApplicationName_from_Called = false
    var extractApplicationName_from_ReceivedLogLine: ApplicationLogLine?
    var extractApplicationName_from_ReturnValue: String!

    func extractApplicationName(from logLine: ApplicationLogLine) -> String {

        extractApplicationName_from_Called = true
        extractApplicationName_from_ReceivedLogLine = logLine
        return extractApplicationName_from_ReturnValue
    }
}
class ConfigurationStorageMock: ConfigurationStorage {


    //MARK: - loadConfiguration

    var loadConfiguration_Called = false
    var loadConfiguration_ReturnValue: Configuration?

    func loadConfiguration() -> Configuration? {

        loadConfiguration_Called = true
        return loadConfiguration_ReturnValue
    }
    //MARK: - save

    var save_configuration_Called = false
    var save_configuration_ReceivedConfiguration: Configuration?

    func save(configuration: Configuration) {

        save_configuration_Called = true
        save_configuration_ReceivedConfiguration = configuration
    }
}
class FBReferenceImageDirectoryURLExtractorMock: FBReferenceImageDirectoryURLExtractor {


    //MARK: - extractImageDirectoryURLs

    var extractImageDirectoryURLs_from_Called = false
    var extractImageDirectoryURLs_from_ReceivedLogLine: ApplicationLogLine?
    var extractImageDirectoryURLs_from_ReturnValue: [URL]!

    func extractImageDirectoryURLs(from logLine: ApplicationLogLine) -> [URL] {

        extractImageDirectoryURLs_from_Called = true
        extractImageDirectoryURLs_from_ReceivedLogLine = logLine
        return extractImageDirectoryURLs_from_ReturnValue
    }
}
class FolderEventsListenerMock: FolderEventsListener {

    var output: FolderEventsListenerOutput?

    //MARK: - init

    var init_folderPath_filter_fileWatcherFactory_ReceivedArguments: (folderPath: String, filter: FolderEventFilter?, fileWatcherFactory: FileWatcherFactory)?

    required init(folderPath: String, filter: FolderEventFilter?, fileWatcherFactory: FileWatcherFactory) {
        init_folderPath_filter_fileWatcherFactory_ReceivedArguments = (folderPath: folderPath, filter: filter, fileWatcherFactory: fileWatcherFactory)
    }
    //MARK: - startListening

    var startListening_Called = false

    func startListening() {

        startListening_Called = true
    }
    //MARK: - stopListening

    var stopListening_Called = false

    func stopListening() {

        stopListening_Called = true
    }
}
class FolderEventsListenerOutputMock: FolderEventsListenerOutput {


    //MARK: - folderEventsListener

    var folderEventsListener___didReceive_Called = false
    var folderEventsListener___didReceive_ReceivedArguments: (listener: FolderEventsListener, event: FolderEvent)?

    func folderEventsListener(_ listener: FolderEventsListener, didReceive event: FolderEvent) {

        folderEventsListener___didReceive_Called = true
        folderEventsListener___didReceive_ReceivedArguments = (listener: listener, event: event)
    }
}
class ImageCacheMock: ImageCache {


    //MARK: - invalidate

    var invalidate_Called = false

    func invalidate() {

        invalidate_Called = true
    }
}
class MenuInteractorInputMock: MenuInteractorInput {

    var foundTestResults: [SnapshotTestResult] = []

    //MARK: - startXcodeBuildsListening

    var startXcodeBuildsListening_derivedDataFolder_Called = false
    var startXcodeBuildsListening_derivedDataFolder_ReceivedDerivedDataFolder: DerivedDataFolder?

    func startXcodeBuildsListening(derivedDataFolder: DerivedDataFolder) {

        startXcodeBuildsListening_derivedDataFolder_Called = true
        startXcodeBuildsListening_derivedDataFolder_ReceivedDerivedDataFolder = derivedDataFolder
    }
    //MARK: - startSnapshotTestResultListening

    var startSnapshotTestResultListening_fromLogFileAt_Called = false
    var startSnapshotTestResultListening_fromLogFileAt_ReceivedPath: String?

    func startSnapshotTestResultListening(fromLogFileAt path: String) {

        startSnapshotTestResultListening_fromLogFileAt_Called = true
        startSnapshotTestResultListening_fromLogFileAt_ReceivedPath = path
    }
}
class MenuInteractorOutputMock: MenuInteractorOutput {


    //MARK: - didFindNewTestResult

    var didFindNewTestResult___Called = false
    var didFindNewTestResult___ReceivedTestResult: SnapshotTestResult?

    func didFindNewTestResult(_ testResult: SnapshotTestResult) {

        didFindNewTestResult___Called = true
        didFindNewTestResult___ReceivedTestResult = testResult
    }
    //MARK: - didFindNewTestLogFile

    var didFindNewTestLogFile_at_Called = false
    var didFindNewTestLogFile_at_ReceivedPath: String?

    func didFindNewTestLogFile(at path: String) {

        didFindNewTestLogFile_at_Called = true
        didFindNewTestLogFile_at_ReceivedPath = path
    }
}
class MenuModuleInterfaceMock: MenuModuleInterface {


    //MARK: - start

    var start_Called = false

    func start() {

        start_Called = true
    }
    //MARK: - showTestResults

    var showTestResults_Called = false

    func showTestResults() {

        showTestResults_Called = true
    }
    //MARK: - showPreferences

    var showPreferences_Called = false

    func showPreferences() {

        showPreferences_Called = true
    }
    //MARK: - showApplicationMenu

    var showApplicationMenu_Called = false

    func showApplicationMenu() {

        showApplicationMenu_Called = true
    }
    //MARK: - checkForUpdates

    var checkForUpdates_Called = false

    func checkForUpdates() {

        checkForUpdates_Called = true
    }
    //MARK: - quit

    var quit_Called = false

    func quit() {

        quit_Called = true
    }
}
class MenuUserInterfaceMock: MenuUserInterface {


    //MARK: - setNewTestResults

    var setNewTestResults_available_Called = false
    var setNewTestResults_available_ReceivedAvailable: Bool?

    func setNewTestResults(available: Bool) {

        setNewTestResults_available_Called = true
        setNewTestResults_available_ReceivedAvailable = available
    }
    //MARK: - popUpOptionsMenu

    var popUpOptionsMenu_Called = false

    func popUpOptionsMenu() {

        popUpOptionsMenu_Called = true
    }
}
class PasteboardMock: Pasteboard {


    //MARK: - copyImage

    var copyImage_at_Called = false
    var copyImage_at_ReceivedUrl: URL?

    func copyImage(at url: URL) {

        copyImage_at_Called = true
        copyImage_at_ReceivedUrl = url
    }
}
class PreferencesInteractorInputMock: PreferencesInteractorInput {


    //MARK: - save

    var save_Called = false

    func save() {

        save_Called = true
    }
    //MARK: - currentConfiguration

    var currentConfiguration_Called = false
    var currentConfiguration_ReturnValue: Configuration!

    func currentConfiguration() -> Configuration {

        currentConfiguration_Called = true
        return currentConfiguration_ReturnValue
    }
    //MARK: - setNewDerivedDataFolderType

    var setNewDerivedDataFolderType___Called = false
    var setNewDerivedDataFolderType___ReceivedType: String?

    func setNewDerivedDataFolderType(_ type: String) {

        setNewDerivedDataFolderType___Called = true
        setNewDerivedDataFolderType___ReceivedType = type
    }
    //MARK: - setNewDerivedDataFolderPath

    var setNewDerivedDataFolderPath___Called = false
    var setNewDerivedDataFolderPath___ReceivedPath: String?

    func setNewDerivedDataFolderPath(_ path: String) {

        setNewDerivedDataFolderPath___Called = true
        setNewDerivedDataFolderPath___ReceivedPath = path
    }
}
class PreferencesModuleDelegateMock: PreferencesModuleDelegate {


    //MARK: - preferencesModuleWillClose

    var preferencesModuleWillClose___Called = false
    var preferencesModuleWillClose___ReceivedPreferencesModule: PreferencesModuleInterface?

    func preferencesModuleWillClose(_ preferencesModule: PreferencesModuleInterface) {

        preferencesModuleWillClose___Called = true
        preferencesModuleWillClose___ReceivedPreferencesModule = preferencesModule
    }
}
class PreferencesModuleInterfaceMock: PreferencesModuleInterface {


    //MARK: - close

    var close_Called = false

    func close() {

        close_Called = true
    }
    //MARK: - updateUserInterface

    var updateUserInterface_Called = false

    func updateUserInterface() {

        updateUserInterface_Called = true
    }
    //MARK: - select

    var select_derivedDataFolderType_Called = false
    var select_derivedDataFolderType_ReceivedDerivedDataFolderType: String?

    func select(derivedDataFolderType: String) {

        select_derivedDataFolderType_Called = true
        select_derivedDataFolderType_ReceivedDerivedDataFolderType = derivedDataFolderType
    }
    //MARK: - update

    var update_derivedDataFolderPath_Called = false
    var update_derivedDataFolderPath_ReceivedDerivedDataFolderPath: String?

    func update(derivedDataFolderPath: String) {

        update_derivedDataFolderPath_Called = true
        update_derivedDataFolderPath_ReceivedDerivedDataFolderPath = derivedDataFolderPath
    }
}
class PreferencesUserInterfaceMock: PreferencesUserInterface {


    //MARK: - show

    var show_preferencesDisplayInfo_Called = false
    var show_preferencesDisplayInfo_ReceivedPreferencesDisplayInfo: PreferencesDisplayInfo?

    func show(preferencesDisplayInfo: PreferencesDisplayInfo) {

        show_preferencesDisplayInfo_Called = true
        show_preferencesDisplayInfo_ReceivedPreferencesDisplayInfo = preferencesDisplayInfo
    }
}
class TestClassNameExtractorMock: TestClassNameExtractor {


    //MARK: - extractTestClassName

    var extractTestClassName_from_Called = false
    var extractTestClassName_from_ReceivedLogLine: ApplicationLogLine?
    var extractTestClassName_from_ReturnValue: String!

    func extractTestClassName(from logLine: ApplicationLogLine) -> String {

        extractTestClassName_from_Called = true
        extractTestClassName_from_ReceivedLogLine = logLine
        return extractTestClassName_from_ReturnValue
    }
}
class TestNameExtractorMock: TestNameExtractor {


    //MARK: - extractTestName

    var extractTestName_from_Called = false
    var extractTestName_from_ReceivedLogLine: ApplicationLogLine?
    var extractTestName_from_ReturnValue: String!

    func extractTestName(from logLine: ApplicationLogLine) -> String {

        extractTestName_from_Called = true
        extractTestName_from_ReceivedLogLine = logLine
        return extractTestName_from_ReturnValue
    }
}
class TestResultCellDelegateMock: TestResultCellDelegate {


    //MARK: - testResultCell

    var testResultCell___viewInXcodeButtonClicked_Called = false
    var testResultCell___viewInXcodeButtonClicked_ReceivedArguments: (cell: TestResultCell, viewInXcodeButtonClicked: NSButton)?

    func testResultCell(_ cell: TestResultCell, viewInXcodeButtonClicked: NSButton) {

        testResultCell___viewInXcodeButtonClicked_Called = true
        testResultCell___viewInXcodeButtonClicked_ReceivedArguments = (cell: cell, viewInXcodeButtonClicked: viewInXcodeButtonClicked)
    }
    //MARK: - testResultCell

    var testResultCell___viewInKaleidoscopeButtonClicked_Called = false
    var testResultCell___viewInKaleidoscopeButtonClicked_ReceivedArguments: (cell: TestResultCell, viewInKaleidoscopeButtonClicked: NSButton)?

    func testResultCell(_ cell: TestResultCell, viewInKaleidoscopeButtonClicked: NSButton) {

        testResultCell___viewInKaleidoscopeButtonClicked_Called = true
        testResultCell___viewInKaleidoscopeButtonClicked_ReceivedArguments = (cell: cell, viewInKaleidoscopeButtonClicked: viewInKaleidoscopeButtonClicked)
    }
    //MARK: - testResultCell

    var testResultCell___acceptSnapshotsButtonClicked_Called = false
    var testResultCell___acceptSnapshotsButtonClicked_ReceivedArguments: (cell: TestResultCell, acceptSnapshotsButtonClicked: NSButton)?

    func testResultCell(_ cell: TestResultCell, acceptSnapshotsButtonClicked: NSButton) {

        testResultCell___acceptSnapshotsButtonClicked_Called = true
        testResultCell___acceptSnapshotsButtonClicked_ReceivedArguments = (cell: cell, acceptSnapshotsButtonClicked: acceptSnapshotsButtonClicked)
    }
    //MARK: - testResultCell

    var testResultCell___rejectSnapshotButtonClicked_Called = false
    var testResultCell___rejectSnapshotButtonClicked_ReceivedArguments: (cell: TestResultCell, rejectSnapshotButtonClicked: NSButton)?

    func testResultCell(_ cell: TestResultCell, rejectSnapshotButtonClicked: NSButton) {

        testResultCell___rejectSnapshotButtonClicked_Called = true
        testResultCell___rejectSnapshotButtonClicked_ReceivedArguments = (cell: cell, rejectSnapshotButtonClicked: rejectSnapshotButtonClicked)
    }
    //MARK: - testResultCell

    var testResultCell___copySnapshotButtonClicked_Called = false
    var testResultCell___copySnapshotButtonClicked_ReceivedArguments: (cell: TestResultCell, copySnapshotButtonClicked: NSButton)?

    func testResultCell(_ cell: TestResultCell, copySnapshotButtonClicked: NSButton) {

        testResultCell___copySnapshotButtonClicked_Called = true
        testResultCell___copySnapshotButtonClicked_ReceivedArguments = (cell: cell, copySnapshotButtonClicked: copySnapshotButtonClicked)
    }
}
class TestResultsHeaderDelegateMock: TestResultsHeaderDelegate {


    //MARK: - testResultsHeader

    var testResultsHeader___acceptSnapshotsButtonClicked_Called = false
    var testResultsHeader___acceptSnapshotsButtonClicked_ReceivedArguments: (header: TestResultsHeader, acceptSnapshotsButtonClicked: NSButton)?

    func testResultsHeader(_ header: TestResultsHeader, acceptSnapshotsButtonClicked: NSButton) {

        testResultsHeader___acceptSnapshotsButtonClicked_Called = true
        testResultsHeader___acceptSnapshotsButtonClicked_ReceivedArguments = (header: header, acceptSnapshotsButtonClicked: acceptSnapshotsButtonClicked)
    }
}
class TestResultsInteractorInputMock: TestResultsInteractorInput {

    var testResults: [SnapshotTestResult] = []

    //MARK: - openInKaleidoscope

    var openInKaleidoscope_testResult_Called = false
    var openInKaleidoscope_testResult_ReceivedTestResult: SnapshotTestResult?

    func openInKaleidoscope(testResult: SnapshotTestResult) {

        openInKaleidoscope_testResult_Called = true
        openInKaleidoscope_testResult_ReceivedTestResult = testResult
    }
    //MARK: - openInXcode

    var openInXcode_testResult_Called = false
    var openInXcode_testResult_ReceivedTestResult: SnapshotTestResult?

    func openInXcode(testResult: SnapshotTestResult) {

        openInXcode_testResult_Called = true
        openInXcode_testResult_ReceivedTestResult = testResult
    }
    //MARK: - accept

    var accept_testResult_Called = false
    var accept_testResult_ReceivedTestResult: SnapshotTestResult?

    func accept(testResult: SnapshotTestResult) {

        accept_testResult_Called = true
        accept_testResult_ReceivedTestResult = testResult
    }
    //MARK: - reject

    var reject_testResult_Called = false
    var reject_testResult_ReceivedTestResult: SnapshotTestResult?

    func reject(testResult: SnapshotTestResult) {

        reject_testResult_Called = true
        reject_testResult_ReceivedTestResult = testResult
    }
    //MARK: - copy

    var copy_testResult_Called = false
    var copy_testResult_ReceivedTestResult: SnapshotTestResult?

    func copy(testResult: SnapshotTestResult) {

        copy_testResult_Called = true
        copy_testResult_ReceivedTestResult = testResult
    }
}
class TestResultsInteractorOutputMock: TestResultsInteractorOutput {


    //MARK: - didFailToAccept

    var didFailToAccept_testResult_with_Called = false
    var didFailToAccept_testResult_with_ReceivedArguments: (testResult: SnapshotTestResult, error: Error)?

    func didFailToAccept(testResult: SnapshotTestResult, with error: Error) {

        didFailToAccept_testResult_with_Called = true
        didFailToAccept_testResult_with_ReceivedArguments = (testResult: testResult, error: error)
    }
    //MARK: - didFailToReject

    var didFailToReject_testResult_with_Called = false
    var didFailToReject_testResult_with_ReceivedArguments: (testResult: SnapshotTestResult, error: Error)?

    func didFailToReject(testResult: SnapshotTestResult, with error: Error) {

        didFailToReject_testResult_with_Called = true
        didFailToReject_testResult_with_ReceivedArguments = (testResult: testResult, error: error)
    }
}
class TestResultsModuleInterfaceMock: TestResultsModuleInterface {


    //MARK: - updateUserInterface

    var updateUserInterface_Called = false

    func updateUserInterface() {

        updateUserInterface_Called = true
    }
    //MARK: - openInKaleidoscope

    var openInKaleidoscope_testResultDisplayInfo_Called = false
    var openInKaleidoscope_testResultDisplayInfo_ReceivedTestResultDisplayInfo: TestResultDisplayInfo?

    func openInKaleidoscope(testResultDisplayInfo: TestResultDisplayInfo) {

        openInKaleidoscope_testResultDisplayInfo_Called = true
        openInKaleidoscope_testResultDisplayInfo_ReceivedTestResultDisplayInfo = testResultDisplayInfo
    }
    //MARK: - openInXcode

    var openInXcode_testResultDisplayInfo_Called = false
    var openInXcode_testResultDisplayInfo_ReceivedTestResultDisplayInfo: TestResultDisplayInfo?

    func openInXcode(testResultDisplayInfo: TestResultDisplayInfo) {

        openInXcode_testResultDisplayInfo_Called = true
        openInXcode_testResultDisplayInfo_ReceivedTestResultDisplayInfo = testResultDisplayInfo
    }
    //MARK: - selectDiffMode

    var selectDiffMode___Called = false
    var selectDiffMode___ReceivedDiffMode: TestResultsDiffMode?

    func selectDiffMode(_ diffMode: TestResultsDiffMode) {

        selectDiffMode___Called = true
        selectDiffMode___ReceivedDiffMode = diffMode
    }
    //MARK: - accept

    var accept___Called = false
    var accept___ReceivedTestResults: [TestResultDisplayInfo]?

    func accept(_ testResults: [TestResultDisplayInfo]) {

        accept___Called = true
        accept___ReceivedTestResults = testResults
    }
    //MARK: - reject

    var reject___Called = false
    var reject___ReceivedTestResults: [TestResultDisplayInfo]?

    func reject(_ testResults: [TestResultDisplayInfo]) {

        reject___Called = true
        reject___ReceivedTestResults = testResults
    }
    //MARK: - copy

    var copy_testResultDisplayInfo_Called = false
    var copy_testResultDisplayInfo_ReceivedTestResultDisplayInfo: TestResultDisplayInfo?

    func copy(testResultDisplayInfo: TestResultDisplayInfo) {

        copy_testResultDisplayInfo_Called = true
        copy_testResultDisplayInfo_ReceivedTestResultDisplayInfo = testResultDisplayInfo
    }
}
class TestResultsUserInterfaceMock: TestResultsUserInterface {


    //MARK: - show

    var show_displayInfo_Called = false
    var show_displayInfo_ReceivedDisplayInfo: TestResultsDisplayInfo?

    func show(displayInfo: TestResultsDisplayInfo) {

        show_displayInfo_Called = true
        show_displayInfo_ReceivedDisplayInfo = displayInfo
    }
}
class UpdaterMock: Updater {


    //MARK: - checkForUpdates

    var checkForUpdates_Called = false

    func checkForUpdates() {

        checkForUpdates_Called = true
    }
}
