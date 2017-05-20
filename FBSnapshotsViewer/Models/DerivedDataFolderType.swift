//
//  DerivedDataFolderType.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 10.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

enum DerivedDataFolderType {
    case xcodeDefault
    case xcodeCustom
    case appcode
}

extension DerivedDataFolderType: AutoCases {}
extension DerivedDataFolderType: AutoEquatable {}

extension DerivedDataFolderType: RawRepresentable {
    typealias RawValue = String

    init?(rawValue: DerivedDataFolderType.RawValue) {
        switch rawValue {
        case "Xcode Default":
            self = .xcodeDefault
        case "Xcode Custom":
            self = .xcodeCustom
        case "AppCode":
            self = .appcode
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .xcodeDefault:
            return "Xcode Default"
        case .xcodeCustom:
            return "Xcode Custom"
        case .appcode:
            return "AppCode"
        }
    }
}
