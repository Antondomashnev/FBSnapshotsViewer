//
//  ApplicationTestLogFilesListenerSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class ApplicationTestLogFilesListener_MockFolderEventsListenerFactory: FolderEventsListenerFactory {
    var mockApplicationTestLogsEventsListener: FolderEventsListener!
    var givenXcodeDerivedDataFolderPath: String!

    override func applicationTestLogsEventsListener(at xcodeDerivedDataFolderPath: String) -> FolderEventsListener {
        givenXcodeDerivedDataFolderPath = xcodeDerivedDataFolderPath
        return mockApplicationTestLogsEventsListener
    }
}

class ApplicationTestLogFilesListenerSpec: QuickSpec {
    override func spec() {
        let xcodeDerivedDataFolder = "Users/Antondomashnev/Library/Xcode/DerivedData/"
        var folderEventsListenerFactory: ApplicationTestLogFilesListener_MockFolderEventsListenerFactory!
        var applicationTestLogsEventsListener: FolderEventsListenerMock!
        var applicationTestLogFilesListener: ApplicationTestLogFilesListener!
        var applicationTestLogFilesListenerOutput: ApplicationTestLogFilesListenerOutput!
        var outputPath: String?

        beforeEach {
            applicationTestLogFilesListenerOutput = { path in
                outputPath = path
            }
            applicationTestLogsEventsListener = FolderEventsListenerMock(folderPath: "", filter: nil, fileWatcherFactory: FileWatcherFactory())
            folderEventsListenerFactory = ApplicationTestLogFilesListener_MockFolderEventsListenerFactory()
            folderEventsListenerFactory.mockApplicationTestLogsEventsListener = applicationTestLogsEventsListener
            applicationTestLogFilesListener = ApplicationTestLogFilesListener(folderEventsListenerFactory: folderEventsListenerFactory)
        }

        describe(".stopListening") {
            beforeEach {
                applicationTestLogFilesListener.listen(xcodeDerivedDataFolder: xcodeDerivedDataFolder, outputTo: applicationTestLogFilesListenerOutput)
                applicationTestLogFilesListener.stopListening()
                applicationTestLogFilesListener.folderEventsListener(applicationTestLogsEventsListener, didReceive: FolderEvent.created(path: "createdPath.log", object: .folder))
            }

            it("stops current listening") {
                expect(outputPath).to(beNil())
            }
        }

        describe(".folderEventsListener(didReceive:)") {
            beforeEach {
                applicationTestLogFilesListener.listen(xcodeDerivedDataFolder: xcodeDerivedDataFolder, outputTo: applicationTestLogFilesListenerOutput)
            }

            context("when event without path") {
                beforeEach {
                    applicationTestLogFilesListener.folderEventsListener(applicationTestLogsEventsListener, didReceive: FolderEvent.unknown)
                }

                it("doesnt output it") {
                    expect(outputPath).to(beNil())
                }
            }

            context("when event with path") {
                let eventPath = "Users/Antondomashnev/Library/Xcode/DerivedData/Application.log"

                beforeEach {
                    applicationTestLogFilesListener.folderEventsListener(applicationTestLogsEventsListener, didReceive: FolderEvent.modified(path: eventPath, object: .folder))
                }

                it("outputs it") {
                    expect(outputPath).to(equal(eventPath))
                }
            }
        }

        describe(".listen") {
            beforeEach {
                applicationTestLogFilesListener.listen(xcodeDerivedDataFolder: xcodeDerivedDataFolder, outputTo: applicationTestLogFilesListenerOutput)
            }

            context("when already listening") {
                beforeEach {
                    applicationTestLogFilesListener.listen(xcodeDerivedDataFolder: xcodeDerivedDataFolder, outputTo: applicationTestLogFilesListenerOutput)
                }

                it("stops current listening") {
                    expect(applicationTestLogsEventsListener.stopListeningCalled).to(beTrue())
                }
            }

            it("starts listening the given derived data folder") {
                expect(folderEventsListenerFactory.givenXcodeDerivedDataFolderPath).to(equal(xcodeDerivedDataFolder))
            }

            it("starts listening") {
                expect(applicationTestLogsEventsListener.startListeningCalled).to(beTrue())
            }
        }
    }
}
