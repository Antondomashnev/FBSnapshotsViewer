//
//  DateComponentsFormatter+NaturalApproximation.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 31.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

extension DateComponentsFormatter {
    static let naturalApproximationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = DateComponentsFormatter.UnitsStyle.full
        formatter.includesApproximationPhrase = true
        formatter.allowedUnits = NSCalendar.Unit.minute.union(NSCalendar.Unit.second)
        formatter.maximumUnitCount = 1
        return formatter
    }()
}
