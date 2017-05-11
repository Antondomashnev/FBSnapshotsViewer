//
//  Configuration.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 10.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class Configuration: NSObject, AutoMockable, NSCoding {
    var derivedDataFolder: DerivedDataFolder

    init(derivedDataFolder: DerivedDataFolder) {
        self.derivedDataFolder = derivedDataFolder
        super.init()
    }

    // MARK: - Static

    static func `default`() -> Configuration {
        return Configuration(derivedDataFolder: DerivedDataFolder.xcode)
    }

    // MARK: - NSCoding

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(derivedDataFolder.path, forKey: "derivedDataFolderPath")
        aCoder.encode(derivedDataFolder.type.rawValue, forKey: "derivedDataFolderType")
    }

    required public convenience init?(coder aDecoder: NSCoder) {
        guard let derivedDataFolderPath = aDecoder.decodeObject(forKey: "derivedDataFolderPath") as? String,
              let derivedDataFolderType = aDecoder.decodeObject(forKey: "derivedDataFolderType") as? String else {
                return nil
        }
        switch derivedDataFolderType {
        case DerivedDataFolder.xcode.type.rawValue:
            self.init(derivedDataFolder: DerivedDataFolder.xcode)
        case DerivedDataFolder.custom(path: "").type.rawValue:
            self.init(derivedDataFolder: DerivedDataFolder.custom(path: derivedDataFolderPath))
        default:
            return nil
        }
    }
}
