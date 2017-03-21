//
//  FolderEventFilter.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 18/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

indirect enum FolderEventFilter {
    case known
    case pathRegex(String)
    case type(FolderEventObject)
    case compound(FolderEventFilter, FolderEventFilter)

    func apply(to event: FolderEvent) -> Bool {
        switch self {
        case let .type(type):
            guard let object = event.object else {
                return false
            }
            return object == type
        case let .pathRegex(regex):
            guard let path = event.path else {
                return false
            }
            return path.range(of: regex, options: NSString.CompareOptions.regularExpression) != nil
        case .known:
            switch event {
            case .unknown:
                return false
            default: return true
            }
        case let .compound(filter1, filter2):
            return filter1.apply(to: event) && filter2.apply(to: event)
        }
    }
}

extension FolderEventFilter: AutoEquatable {}

func & (lhs: FolderEventFilter, rhs: FolderEventFilter) -> FolderEventFilter {
    return FolderEventFilter.compound(lhs, rhs)
}
