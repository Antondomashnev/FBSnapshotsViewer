//
//  TestResultsController.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 28/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

class TestResultsController: NSViewController {
    @IBOutlet private var collectionView: NSCollectionView!
    
    var eventHandler: TestResultsModuleInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TestResultsController: TestResultsUserInterface {
    func show(testResults: [TestResultDisplayInfo]) {
        //TODO
    }
}
