//
//  String+HTML.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 20.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

extension String {
    // This at the moment works inly partially due to current requirenments
    func htmlUnescape() -> String {
        var newString = self
        let symbols = [
            "&quot;": "\"",
            "&amp;": "&",
            "&apos;": "'",
            "&lt;": "<",
            "&gt;": ">"
        ]
        for symbol in symbols.keys {
            guard self.range(of: symbol) != nil, let unescapedSymbol = symbols[symbol] else {
                continue
            }
            newString = newString.replacingOccurrences(of: symbol, with: unescapedSymbol).htmlUnescape()
        }
        return newString
    }
}
