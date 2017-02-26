//
//  MenuInteractorOutput.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

protocol MenuInteractorInput: class {
}

protocol MenuInteractorOutput: class {
    func didFind(new testResults: [TestResult])
}

