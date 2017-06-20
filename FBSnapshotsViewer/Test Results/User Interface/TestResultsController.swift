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
    @IBOutlet var topView: TestResultsTopView!
    var collectionViewOutlets: TestResultsCollectionViewOutlets!
    var eventHandler: TestResultsModuleInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        topView.delegate = self
        setupCollectionView()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        eventHandler.updateUserInterface()
    }
    
    // MARK: - Helpers
    
    private func setupCollectionView() {
        collectionViewOutlets = TestResultsCollectionViewOutlets(collectionView: collectionView, testResultCellDelegate: self)
        collectionView.delegate = collectionViewOutlets
        collectionView.dataSource = collectionViewOutlets
    }
}

extension TestResultsController: TestResultsUserInterface {
    func show(displayInfo: TestResultsDisplayInfo) {
        topView.configure(with: displayInfo)
        collectionViewOutlets.testResultsDisplayInfo = displayInfo
        collectionView.reloadData()
    }
}

extension TestResultsController: TestResultCellDelegate {
    func testResultCell(_ cell: TestResultCell, viewInKaleidoscopeButtonClicked: NSButton) {
        let sectionInfos = collectionViewOutlets.testResultsDisplayInfo.sectionInfos
        guard let cellIndexPath = collectionView.indexPath(for: cell),
                  sectionInfos.count > cellIndexPath.section,
                  sectionInfos[cellIndexPath.section].itemInfos.count > cellIndexPath.item else {
            assertionFailure("Unexpected TestResultCellDelegate callback about Kaleidoscope button click")
            return
        }
        let testResultInfo = sectionInfos[cellIndexPath.section].itemInfos[cellIndexPath.item]
        eventHandler.openInKaleidoscope(testResultDisplayInfo: testResultInfo)
    }
}

extension TestResultsController: TestResultsTopViewDelegate {
    func testResultsTopView(_ topView: TestResultsTopView, didSelect diffMode: TestResultsDiffMode) {
        eventHandler.selectDiffMode(diffMode)
    }
}
