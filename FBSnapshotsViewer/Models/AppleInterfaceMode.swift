//
//  AppleInterfaceMode.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

enum AppleInterfaceMode: AutoEquatable {
    case light
    case dark

    init(settings: UserDefaults = UserDefaults.standard) {
        if settings.string(forKey: "AppleInterfaceStyle") != nil {
            self = .dark
        }
        else {
            self = .light
        }
    }
}
