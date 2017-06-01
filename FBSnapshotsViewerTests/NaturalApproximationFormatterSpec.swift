//
//  NaturalApproximationFormatterSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 31.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import FBSnapshotsViewer

class NaturalApproximationFormatterSpec: QuickSpec {
    override func spec() {
        var formatter: DateComponentsFormatter!

        beforeEach {
            formatter = DateComponentsFormatter.naturalApproximationFormatter
        }

        context("given the date") {
            var toDate: Date!
            var initialDate: Date!

            beforeEach {
                toDate = Date()
                initialDate = Date(timeIntervalSinceNow: -550)
            }

            it("converts it into string representation") {
                expect(formatter.string(from: initialDate, to: toDate)).to(equal("About 9 minutes"))
            }
        }
    }
}
