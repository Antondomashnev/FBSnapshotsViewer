//
//  Configuration.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 10.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class Configuration: NSObject, AutoMockable, NSCoding {
    let derivedDataFolder: DerivedDataFolder

    init(derivedDataFolder: DerivedDataFolder) {
        self.derivedDataFolder = derivedDataFolder
        super.init()
    }

    // MARK: - Static

    static func `default`() -> Configuration {
        return Configuration(derivedDataFolder: DerivedDataFolder.xcodeDefault)
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
        case DerivedDataFolder.xcodeDefault.type.rawValue:
            self.init(derivedDataFolder: DerivedDataFolder.xcodeDefault)
        case DerivedDataFolder.xcodeCustom(path: "").type.rawValue:
            self.init(derivedDataFolder: DerivedDataFolder.xcodeCustom(path: derivedDataFolderPath))
        case DerivedDataFolder.appcode(path: "").type.rawValue:
            self.init(derivedDataFolder: DerivedDataFolder.appcode(path: derivedDataFolderPath))
        default:
            return nil
        }
    }

    // MARK: - Equatable

    override func isEqual(_ object: Any?) -> Bool {
        guard let configuration = object as? Configuration else {
            return false
        }
        return configuration.derivedDataFolder == self.derivedDataFolder
    }
}
