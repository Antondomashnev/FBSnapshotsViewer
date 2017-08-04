//
//  BuildCreator.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 24.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class BuildCreator {
    var date: Date?
    var applicationName: String?
    var fbReferenceImageDirectoryURLs: [URL]?
    
    func createBuild() -> Build? {
        guard let date = date, let applicationName = applicationName, let fbReferenceImageDirectoryURLs = fbReferenceImageDirectoryURLs else {
            print("Can not create a build if not all require properties are initialized:\ndate: \(String(describing: self.date))\napplicationName: \(String(describing: self.applicationName))\nfbReferenceImageDirectoryURLs: \(String(describing: self.fbReferenceImageDirectoryURLs))")
            return nil
        }
        return Build(date: date, applicationName: applicationName, fbReferenceImageDirectoryURLs: fbReferenceImageDirectoryURLs)
    }
}
