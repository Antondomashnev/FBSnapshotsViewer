//
//  TestResultsController.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 28/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

class TestResultsController: NSViewController {
    @IBOutlet fileprivate var collectionView: NSCollectionView!
    fileprivate var collectionViewOutlets: TestResultsCollectionViewOutlets!
    var eventHandler: TestResultsModuleInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewOutlets = TestResultsCollectionViewOutlets(collectionView: collectionView)
        collectionView.delegate = collectionViewOutlets
        collectionView.dataSource = collectionViewOutlets
        collectionView.enclosingScrollView?.backgroundColor = NSColor.red
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        eventHandler.updateUserInterface()
    }
}

extension TestResultsController: TestResultsUserInterface {
    func show(testResults: [TestResultDisplayInfo]) {
        collectionViewOutlets.testResults = testResults
        collectionView.reloadData()
    }
}
