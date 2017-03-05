#!/usr/bin/env -S xcrun --sdk macosx swift

//
//  main.swift
//  FBSnapshotsViewerTempFolderProxy
//
//  Created by Anton Domashnev on 08/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

enum FBSnapshotsViewerTempFolderProxy: Error {
    case invalidArguments(String)
}

let sendTemporaryFolderPathNotificationIdentiier = "com.antondomashnev.FBSnapshotsViewerTempFolderProxy.temporaryFolderPathNotification.identifier" as NSString
let sendTemporaryFolderPathNotificationFolderKey = "com.antondomashnev.FBSnapshotsViewerTempFolderProxy.temporaryFolderPathNotification.userInfo.temporaryFolderKey" as NSString

func sendDarwinNotification(with temporaryFolderPath: String) {
    let userInfo = [sendTemporaryFolderPathNotificationFolderKey: temporaryFolderPath]
    let center = CFNotificationCenterGetDistributedCenter()
    let deliverImmediately: Bool = true
    CFNotificationCenterPostNotification(center, CFNotificationName(rawValue: sendTemporaryFolderPathNotificationIdentiier as CFString), nil, userInfo as CFDictionary, deliverImmediately)
    print("Sent")
}

func extractTemporaryFolderPath(from arguments: [String]) throws -> String {
    guard arguments.count == 2 else {
        throw FBSnapshotsViewerTempFolderProxy.invalidArguments("FBSnapshotsViewerTempFolderProxy expects only one argument - the path to the temporary built app folder")
    }
    return arguments[1]
}

do {
    let temporaryFolderPath = try extractTemporaryFolderPath(from: CommandLine.arguments)
    sendDarwinNotification(with: temporaryFolderPath)
}
catch let error {
    print(error)
    exit(0)
}
