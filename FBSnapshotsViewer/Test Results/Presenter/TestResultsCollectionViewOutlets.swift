//
//  TestResultsCollectionViewOutlets.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 03/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

class TestResultsCollectionViewOutlets: NSObject {
    var testResults: [TestResultDisplayInfo] = []
    fileprivate weak var testResultCellDelegate: TestResultCellDelegate?

    init(collectionView: NSCollectionView, testResultCellDelegate: TestResultCellDelegate? = nil) {
        guard let nib = NSNib(nibNamed: "TestResultCell", bundle: Bundle.main) else {
            fatalError("TestResultCell is missing in bundle")
        }
        collectionView.register(nib, forItemWithIdentifier: TestResultCell.itemIdentifier)
        self.testResultCellDelegate = testResultCellDelegate
        super.init()
    }
}

extension TestResultsCollectionViewOutlets: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: 530, height: 346)
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, insetForSectionAt section: Int) -> EdgeInsets {
        return EdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension TestResultsCollectionViewOutlets: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return testResults.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let item = collectionView.makeItem(withIdentifier: TestResultCell.itemIdentifier, for: indexPath) as? TestResultCell else {
            fatalError("TestResultCell is not registered in collection view")
        }
        item.configure(with: testResults[indexPath.item])
        item.delegate = testResultCellDelegate
        return item
    }
}
