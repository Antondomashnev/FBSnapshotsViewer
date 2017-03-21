//
//  SnapshotsViewerApplicationRunNotificationListenerSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class SnapshotsViewerApplicationRunNotificationListenerSpec: QuickSpec {
    override func spec() {
        var delegate: SnapshotsViewerApplicationRunNotificationListenerDelegateMock!
        var listeners: [SnapshotsViewerApplicationRunNotificationListener] = []
        let notificationIdentifier: NSString = "com.antondomashnev.FBSnapshotsViewerTests.willRunApplicationTestsNotificationIdentifier"
        let notificationCenter: CFNotificationCenter = CFNotificationCenterGetDistributedCenter()

        func sendDarwinNotification(with snapshotsDiffFolderPath: String?, and runningiOSSimulatorPath: String?) {
            let imageDiffFolderPathKey = "com.antondomashnev.FBSnapshotsViewerRunPhaseScript.imageDiffFolderPath"
            let iOSSimulatorPathKey = "com.antondomashnev.FBSnapshotsViewerRunPhaseScript.iOSSimulatorPath"
            let userInfo: NSDictionary

            // swiftlint:disable compiler_protocol_init
            if let snapshotsDiffFolderPath = snapshotsDiffFolderPath, let runningiOSSimulatorPath = runningiOSSimulatorPath {
                userInfo = NSDictionary(dictionaryLiteral: (imageDiffFolderPathKey, snapshotsDiffFolderPath), (iOSSimulatorPathKey, runningiOSSimulatorPath))
            }
            else if let runningiOSSimulatorPath = runningiOSSimulatorPath {
                userInfo = NSDictionary(dictionaryLiteral: (iOSSimulatorPathKey, runningiOSSimulatorPath))
            }
            else {
                userInfo = NSDictionary()
            }
            // swiftlint:enable compiler_protocol_init

            let deliverImmediately: Bool = true
            CFNotificationCenterPostNotification(notificationCenter, CFNotificationName(rawValue: notificationIdentifier as CFString), nil, userInfo as CFDictionary, deliverImmediately)
        }

        beforeEach {
            delegate = SnapshotsViewerApplicationRunNotificationListenerDelegateMock()
            let listener = SnapshotsViewerApplicationRunNotificationListener(notificationCenter: notificationCenter, willRunApplicationTestsNotificationIdentifier: notificationIdentifier)
            listener.delegate = delegate
            listeners.append(listener)
        }

        context("when receives the notification") {
            context("when without simulator folder path") {
                beforeEach {
                    sendDarwinNotification(with: nil, and: nil)
                }

                it("doesn't pass the information to delegate") {
                    expect(delegate.snapshotsDiffFolderNotificationListenerCalled).toEventually(beFalse())
                }
            }

            context("when with the image diff folder path") {
                beforeEach {
                    sendDarwinNotification(with: "imagediff/folder/", and: "mysimulator1/path/")
                }

                it("passes information to delegate") {
                    expect(delegate.snapshotsDiffFolderNotificationListenerReceivedArguments?.simulatorPath).toEventually(equal("mysimulator1/path/"))
                    expect(delegate.snapshotsDiffFolderNotificationListenerReceivedArguments?.imageDiffPath).toEventually(equal("imagediff/folder/"))
                }
            }

            context("when without image diff folder path") {
                beforeEach {
                    sendDarwinNotification(with: nil, and: "mysimulator2/path/")
                }

                it("passes information to delegate") {
                    expect(delegate.snapshotsDiffFolderNotificationListenerReceivedArguments?.simulatorPath).toEventually(equal("mysimulator2/path/"))
                    expect(delegate.snapshotsDiffFolderNotificationListenerReceivedArguments?.imageDiffPath).to(beNil())
                }
            }
        }
    }
}
