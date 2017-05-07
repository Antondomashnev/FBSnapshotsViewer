//
//  TestResultsController.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 28/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

class TestResultsController: NSViewController {
    @IBOutlet var collectionView: NSCollectionView!
    var collectionViewOutlets: TestResultsCollectionViewOutlets!
    var eventHandler: TestResultsModuleInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewOutlets = TestResultsCollectionViewOutlets(collectionView: collectionView, testResultCellDelegate: self)
        collectionView.delegate = collectionViewOutlets
        collectionView.dataSource = collectionViewOutlets
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

extension TestResultsController: TestResultCellDelegate {
    func testResultCell(_ cell: TestResultCell, viewInKaleidoscopeButtonClicked: NSButton) {
        guard let cellIndex = collectionView.indexPath(for: cell)?.item, collectionViewOutlets.testResults.count > cellIndex else {
            assertionFailure("Unexpected TestResultCellDelegate callback about Kaleidoscope button click")
            return
        }
        eventHandler.openInKaleidoscope(testResultDisplayInfo: collectionViewOutlets.testResults[cellIndex])
    }
}
