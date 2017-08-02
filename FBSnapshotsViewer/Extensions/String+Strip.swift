//
//  String+Strip.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 01.08.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

extension String {
    /// Shortcut for `trimmingCharacters(in: .whitespaces)`
    func stripping() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
