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
    case compound(FolderEventFilter, FolderEventFilter)
    
    func apply(to event: FolderEvent) -> Bool {
        switch self {
        case let .pathRegex(regex):
            switch event {
            case let .created(path, _) where path.range(of: regex, options: NSString.CompareOptions.regularExpression) != nil:
                return true
            case let .modified(path, _) where path.range(of: regex, options: NSString.CompareOptions.regularExpression) != nil:
                return true
            case let .deleted(path, _) where path.range(of: regex, options: NSString.CompareOptions.regularExpression) != nil:
                return true
            default: return false
            }
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

func + (lhs: FolderEventFilter, rhs: FolderEventFilter) -> FolderEventFilter {
    return FolderEventFilter.compound(lhs, rhs)
}
