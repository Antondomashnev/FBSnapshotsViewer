//
//  SnapshotsDiffFolderNotificationListener.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 09/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

protocol SnapshotsViewerApplicationRunNotificationListenerDelegate: class, AutoMockable {
    func snapshotsDiffFolderNotificationListener(_ listener: SnapshotsViewerApplicationRunNotificationListener, didReceiveRunningiOSSimulatorFolder simulatorPath: String, andImageDiffFolder imageDiffPath: String?)
}

class SnapshotsViewerApplicationRunNotificationListener {
    private let notificationCenter: CFNotificationCenter
    private let willRunApplicationTestsNotificationIdentifier: NSString
    weak var delegate: SnapshotsViewerApplicationRunNotificationListenerDelegate?

    init(notificationCenter: CFNotificationCenter = CFNotificationCenterGetDistributedCenter(),
         willRunApplicationTestsNotificationIdentifier: NSString = "com.antondomashnev.FBSnapshotsViewerRunPhaseScript.willRunApplicationTestsNotificationIdentifier") {
        self.willRunApplicationTestsNotificationIdentifier = willRunApplicationTestsNotificationIdentifier
        self.notificationCenter = notificationCenter
        registerForDarwinNotifications(with: willRunApplicationTestsNotificationIdentifier, from: notificationCenter)
    }

    deinit {
        CFNotificationCenterRemoveObserver(notificationCenter, nil, CFNotificationName(rawValue: willRunApplicationTestsNotificationIdentifier as CFString), nil)
    }

    // MARK: - Helpers

    private func registerForDarwinNotifications(with identifier: NSString, from center: CFNotificationCenter) {
        let callback: CFNotificationCallback = { center, observer, name, object, info in
            let imageDiffFolderPathKey = "com.antondomashnev.FBSnapshotsViewerRunPhaseScript.imageDiffFolderPath"
            let iOSSimulatorPathKey = "com.antondomashnev.FBSnapshotsViewerRunPhaseScript.iOSSimulatorPath"
            guard let userInfo = info as? NSDictionary,
                  let observer = observer,
                  let iOSSimulatorPath = userInfo[iOSSimulatorPathKey] as? String else {
                return
            }
            let imageDiffFolderPath = userInfo[imageDiffFolderPathKey] as? String
            let unwrappedSelf = Unmanaged<SnapshotsViewerApplicationRunNotificationListener>.fromOpaque(observer).takeUnretainedValue()
            unwrappedSelf.delegate?.snapshotsDiffFolderNotificationListener(unwrappedSelf, didReceiveRunningiOSSimulatorFolder: iOSSimulatorPath, andImageDiffFolder: imageDiffFolderPath)
        }

        let suspensionBehavior = CFNotificationSuspensionBehavior.deliverImmediately
        let center = CFNotificationCenterGetDistributedCenter()
        let observer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        CFNotificationCenterAddObserver(center, observer, callback, CFNotificationName(rawValue: identifier as CFString).rawValue, nil, suspensionBehavior)
    }
}
