//
//  SnapshotsDiffFolderNotificationListener.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 09/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

protocol SnapshotsDiffFolderNotificationListenerDelegate: class {
    func snapshotsDiffFolderNotificationListener(_ listener: SnapshotsDiffFolderNotificationListener, didReceive folderPath: String)
}

class SnapshotsDiffFolderNotificationListener {
    private let notificationCenter: CFNotificationCenter
    private let sendTemporaryFolderPathNotificationIdentiier: NSString = "com.antondomashnev.FBSnapshotsViewerTempFolderProxy.temporaryFolderPathNotification.identifier"
    weak var delegate: SnapshotsDiffFolderNotificationListenerDelegate?
    
    init(notificationCenter: CFNotificationCenter = CFNotificationCenterGetDistributedCenter()) {
        self.notificationCenter = notificationCenter
        registerForDarwinNotifications(with: sendTemporaryFolderPathNotificationIdentiier, from: notificationCenter)
    }
    
    deinit {
        CFNotificationCenterRemoveObserver(notificationCenter, nil, CFNotificationName(rawValue: sendTemporaryFolderPathNotificationIdentiier as CFString), nil)
    }
    
    // MARK: - Helpers
    
    private func registerForDarwinNotifications(with identifier: NSString, from center: CFNotificationCenter) {
        let callback: CFNotificationCallback = { center, observer, name, object, info in
            let sendTemporaryFolderPathNotificationFolderKey = "com.antondomashnev.FBSnapshotsViewerTempFolderProxy.temporaryFolderPathNotification.userInfo.temporaryFolderKey"
            guard let userInfo = info as? NSDictionary,
                  let observer = observer,
                  let tempFolderPath = userInfo[sendTemporaryFolderPathNotificationFolderKey] as? String else {
                return
            }
            let unwrappedSelf = Unmanaged<SnapshotsDiffFolderNotificationListener>.fromOpaque(observer).takeUnretainedValue()
            unwrappedSelf.delegate?.snapshotsDiffFolderNotificationListener(unwrappedSelf, didReceive: tempFolderPath)
        }
        
        let suspensionBehavior = CFNotificationSuspensionBehavior.deliverImmediately
        let center = CFNotificationCenterGetDistributedCenter()
        let observer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        CFNotificationCenterAddObserver(center, observer, callback, CFNotificationName(rawValue: identifier as CFString).rawValue, nil, suspensionBehavior)
    }
}
