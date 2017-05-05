//
//  OSXApplicationFinder.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import CoreServices

class OSXApplicationFinder {

    /// Check whether the application with the given bundle identifier is installed or not on the machine
    ///
    /// - Parameter bundleIdentifier: bundle identifier of the looking app
    /// - Returns: URL for the application that corresponds to a bundle identifier, nil if no application found
    func findApplication(with bundleIdentifier: String) -> URL? {
        guard let result = LSCopyApplicationURLsForBundleIdentifier(bundleIdentifier as CFString, nil)?.takeUnretainedValue() as [AnyObject]?, let urls = result as? [URL] else {
            return nil
        }
        return urls.first
    }
}
