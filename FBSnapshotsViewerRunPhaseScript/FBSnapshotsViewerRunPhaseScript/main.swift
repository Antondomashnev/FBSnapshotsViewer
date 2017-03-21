#!/usr/bin/swift

//
//  main.swift
//  FBSnapshotsViewerRunPhaseScript
//
//  Created by Anton Domashnev on 21/03/2017.
//  Copyright © 2017 antondomashnev. All rights reserved.
//

import Foundation

enum FBSnapshotsViewerTempFolderProxyError: Error {
    case xcrunSimctlListInvalidJSONOutput(String)
    case xcrunSimctlListNoBootedSimulators(String)
}


let coreSimulatorsPath = "\(NSHomeDirectory())/Library/Developer/CoreSimulator/Devices"
let coreSimulatorsDataApplicationsRelativePath = "/data/Containers/Data/Application"
let willRunApplicationTestsNotificationIdentifier = "com.antondomashnev.FBSnapshotsViewerRunPhaseScript.willRunApplicationTestsNotificationIdentifier" as NSString
let imageDiffFolderPath = "com.antondomashnev.FBSnapshotsViewerRunPhaseScript.imageDiffFolderPath" as NSString
let iOSSimulatorPath = "com.antondomashnev.FBSnapshotsViewerRunPhaseScript.iOSSimulatorPath" as NSString


func sendDarwinNotification(with snapshotsDiffFolderPath: String?, and runningiOSSimulatorPath: String) {
    let userInfo: NSDictionary
    if let snapshotsDiffFolderPath = snapshotsDiffFolderPath {
        userInfo = NSDictionary(dictionaryLiteral: (imageDiffFolderPath, snapshotsDiffFolderPath), (iOSSimulatorPath, runningiOSSimulatorPath))
    }
    else {
        userInfo = NSDictionary(dictionaryLiteral: (iOSSimulatorPath, runningiOSSimulatorPath))
    }
    let deliverImmediately: Bool = true
    CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), CFNotificationName(rawValue: willRunApplicationTestsNotificationIdentifier as CFString), nil, userInfo as CFDictionary, deliverImmediately)
}

func extractSnapshotsDiffFolderPath(from arguments: [String]) -> String? {
    return arguments.count == 2 ? arguments[1] : nil
}

func currentlyRunningiOSSimulatorPath() throws -> String {
    let task = Process()
    task.launchPath = "/usr/bin/xcrun"
    task.arguments = ["simctl", "list" ,"-j"]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    
    let outputJSONData = pipe.fileHandleForReading.readDataToEndOfFile()
    let jsonReadingOptions = JSONSerialization.ReadingOptions(rawValue: UInt(0))
    guard let outputJSON = try JSONSerialization.jsonObject(with: outputJSONData, options: jsonReadingOptions) as? [String: Any],
        let devicesJSON = outputJSON["devices"] as? [String: [[String: String]]] else {
            throw FBSnapshotsViewerTempFolderProxyError.xcrunSimctlListInvalidJSONOutput("Invalid `xcrun simctl list` output")
    }
    let bootedDevice = devicesJSON.flatMap { $0.value }.first { $0["state"] == "Booted" }
    guard let bootedDeviceUUID = bootedDevice?["udid"] else {
        throw FBSnapshotsViewerTempFolderProxyError.xcrunSimctlListNoBootedSimulators("`xcrun simctl list` didn't find any booted simulator")
    }
    return coreSimulatorsPath + "/" + bootedDeviceUUID + coreSimulatorsDataApplicationsRelativePath
}

do {
    let simulatorPath = try currentlyRunningiOSSimulatorPath()
    sendDarwinNotification(with: extractSnapshotsDiffFolderPath(from: CommandLine.arguments), and: simulatorPath)
    print("Notification has been sent.")
    exit(EXIT_SUCCESS)
}
catch let error {
    print(error.localizedDescription)
    exit(EXIT_FAILURE)
}

