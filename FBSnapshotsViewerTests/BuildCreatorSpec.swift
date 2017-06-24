//
//  BuildCreatorSpec.swift
//  FBSnapshotsViewerTests
//
//  Created by Anton Domashnev on 24.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class BuildCreatorSpec: QuickSpec {
    override func spec() {
        var buildCreator: BuildCreator!
        
        beforeEach {
            buildCreator = BuildCreator()
        }
        
        describe(".createBuild") {
            context("given application name, date and fbReferenceImageDirectoryURL") {
                var date: Date!
                var applicationName: String!
                var fbReferenceImageDirectoryURL: URL!
                
                beforeEach {
                    fbReferenceImageDirectoryURL = URL(fileURLWithPath: "/Users/fedotiy/myproject/tests/")
                    applicationName = "MyApplication"
                    date = Date()
                    buildCreator.applicationName = applicationName
                    buildCreator.fbReferenceImageDirectoryURL = fbReferenceImageDirectoryURL
                    buildCreator.date = date
                }
                
                it("returns build") {
                    let expectedBuild = Build(date: date, applicationName: applicationName, fbReferenceImageDirectoryURL: fbReferenceImageDirectoryURL)
                    expect(buildCreator.createBuild()).to(equal(expectedBuild))
                }
            }
            
            context("given not all properties") {
                var date: Date!
                var fbReferenceImageDirectoryURL: URL!
                
                beforeEach {
                    fbReferenceImageDirectoryURL = URL(fileURLWithPath: "/Users/fedotiy/myproject/tests/")
                    applicationName = "MyApplication"
                    date = Date()
                    buildCreator.fbReferenceImageDirectoryURL = fbReferenceImageDirectoryURL
                    buildCreator.date = date
                }
                
                it("doesn't create build") {
                    expect(buildCreator.createBuild()).to(beNil())
                }
            }
        }
    }
}
