//
//  DerivedDataFolderType.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 10.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

enum DerivedDataFolderType {
    case xcode
    case custom
}

extension DerivedDataFolderType: AutoCases {}
extension DerivedDataFolderType: AutoEquatable {}

extension DerivedDataFolderType: RawRepresentable {
    typealias RawValue = String

    init?(rawValue: DerivedDataFolderType.RawValue) {
        switch rawValue {
        case "Xcode":
            self = .xcode
        case "Custom":
            self = .custom
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .xcode:
            return "Xcode"
        case .custom:
            return "Custom"
        }
    }
}
