//
//  FolderEventsListenerFactorySpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 19/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class FolderEventsListenerFactorySpec: QuickSpec {
    override func spec() {
        var factory: FolderEventsListenerFactory!

        beforeEach {
            factory = FolderEventsListenerFactory()
        }

        describe(".applicationTestLogsEventsListener") {
            var listener: NonRecursiveFolderEventsListener!
            var derivedDataFolder: DerivedDataFolder!

            context("when derived data folder is xcode default") {
                beforeEach {
                    derivedDataFolder = DerivedDataFolder.xcodeDefault
                    listener = factory.applicationTestLogsEventsListener(at: derivedDataFolder) as? NonRecursiveFolderEventsListener
                }

                it("returns correct listener") {
                    let expectedFilter = FolderEventFilter.known & FolderEventFilter.type(.file) & FolderEventFilter.pathRegex("/Logs/Test/[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}/.+log$")
                    expect(listener.folderPath).to(equal(derivedDataFolder.path))
                    expect(listener.filter).to(equal(expectedFilter))
                }
            }

            context("when derived data folder is xcode custom") {
                beforeEach {
                    derivedDataFolder = DerivedDataFolder.xcodeCustom(path: "BlaBla")
                    listener = factory.applicationTestLogsEventsListener(at: derivedDataFolder) as? NonRecursiveFolderEventsListener
                }

                it("returns correct listener") {
                    let expectedFilter = FolderEventFilter.known & FolderEventFilter.type(.file) & FolderEventFilter.pathRegex("/Logs/Test/[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}/.+log$")
                    expect(listener.folderPath).to(equal(derivedDataFolder.path))
                    expect(listener.filter).to(equal(expectedFilter))
                }
            }

            context("when derived data folder is appcode") {
                beforeEach {
                    derivedDataFolder = DerivedDataFolder.appcode(path: "FooBar")
                    listener = factory.applicationTestLogsEventsListener(at: derivedDataFolder) as? NonRecursiveFolderEventsListener
                }

                it("returns correct listener") {
                    let expectedFilter = FolderEventFilter.known & FolderEventFilter.type(.file) & FolderEventFilter.pathRegex("/testHistory/[0-9a-fA-F]+/.+ - [0-9]{4}.[0-9]{2}.[0-9]{2} at [0-9]{2}h [0-9]{2}m [0-9]{2}s.xml$")
                    expect(listener.folderPath).to(equal(derivedDataFolder.path))
                    expect(listener.filter).to(equal(expectedFilter))
                }
            }
        }

        describe(".iOSSimulatorApplicationsFolderEventsListener") {
            it("returns correct listener") {
                expect(factory.iOSSimulatorApplicationsFolderEventsListener(at: "mypath") is NonRecursiveFolderEventsListener).to(beTrue())
            }
        }
    }
}
