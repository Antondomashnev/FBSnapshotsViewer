//
//  Build.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 10.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

struct Build: AutoHashable, AutoEquatable {
    let date: Date
    let applicationName: String
    let fbReferenceImageDirectoryURLs: [URL]
    
    init(date: Date, applicationName: String, fbReferenceImageDirectoryURLs: [URL]) {
        self.applicationName = applicationName
        self.date = date
        self.fbReferenceImageDirectoryURLs = fbReferenceImageDirectoryURLs
    }
}
