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
    let referenceImagesFolder: String
    static let referenceImagesFolderDefault = "\(NSHomeDirectory())/Library/Developer/Xcode/DerivedData"

    init(derivedDataFolder: DerivedDataFolder,
         referenceImagesFolder: String = Configuration.referenceImagesFolderDefault) {
        self.derivedDataFolder = derivedDataFolder
        self.referenceImagesFolder = referenceImagesFolder
        super.init()
    }

    // MARK: - Static

    static func `default`() -> Configuration {
      return Configuration(derivedDataFolder: DerivedDataFolder.xcodeDefault,
                           referenceImagesFolder: Configuration.referenceImagesFolderDefault)
    }

    // MARK: - NSCoding

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(derivedDataFolder.path, forKey: "derivedDataFolderPath")
        aCoder.encode(derivedDataFolder.type.rawValue, forKey: "derivedDataFolderType")
        aCoder.encode(referenceImagesFolder, forKey: "referenceImagesFolderPath")
    }

    required public convenience init?(coder aDecoder: NSCoder) {
        guard let derivedDataFolderPath = aDecoder.decodeObject(forKey: "derivedDataFolderPath") as? String,
              let derivedDataFolderType = aDecoder.decodeObject(forKey: "derivedDataFolderType") as? String,
            let referenceImagesFolder = aDecoder.decodeObject(forKey: "referenceImagesFolderPath") as? String else {
                return nil
        }
        switch derivedDataFolderType {
        case DerivedDataFolder.xcodeDefault.type.rawValue:
            self.init(derivedDataFolder: DerivedDataFolder.xcodeDefault,
                    referenceImagesFolder: referenceImagesFolder)
        case DerivedDataFolder.xcodeCustom(path: "").type.rawValue:
            self.init(derivedDataFolder: DerivedDataFolder.xcodeCustom(path: derivedDataFolderPath),
                      referenceImagesFolder: referenceImagesFolder)
        case DerivedDataFolder.appcode(path: "").type.rawValue:
          self.init(derivedDataFolder: DerivedDataFolder.appcode(path: derivedDataFolderPath),
                    referenceImagesFolder: referenceImagesFolder)
        default:
            return nil
        }
    }

    // MARK: - Equatable

    override func isEqual(_ object: Any?) -> Bool {
        guard let configuration = object as? Configuration else {
            return false
        }
      return configuration.derivedDataFolder == self.derivedDataFolder && configuration.referenceImagesFolder == self.referenceImagesFolder
    }
}
