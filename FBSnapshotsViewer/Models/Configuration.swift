//
//  Configuration.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 10.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class Configuration: AutoMockable, NSCoding {
    var derivedDataFolder: DerivedDataFolder

    init(derivedDataFolder: DerivedDataFolder) {
        self.derivedDataFolder = derivedDataFolder
    }

    // MARK: - NSCoding

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(derivedDataFolder.path, forKey: "derivedDataFolderPath")
        aCoder.encode(derivedDataFolder.type.rawValue, forKey: "derivedDataFolderType")
    }

    required public convenience init?(coder aDecoder: NSCoder) {
        guard let derivedDataFolderPath = aDecoder.value(forKey: "derivedDataFolderPath") as? String,
            let derivedDataFolderType = DerivedDataFolderType(rawValue: aDecoder.value(forKey: "derivedDataFolderType") as? DerivedDataFolderType.RawValue ?? "") else {
                return nil
        }
        self.init(derivedDataFolder: DerivedDataFolder(path: derivedDataFolderPath, type: derivedDataFolderType))
    }
}
