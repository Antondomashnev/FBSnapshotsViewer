//
//  TestResultsCollectionViewOutlets.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 03/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

class TestResultsCollectionViewOutlets {
    var testResults: [TestResultDisplayInfo] = []
    
    init(collectionView: NSCollectionView) {
        guard let nib = NSNib(nibNamed: "TestResultCell", bundle: Bundle.main) else {
            fatalError("TestResultCell is missing in bundle")
        }
        collectionView.register(nib, forItemWithIdentifier: TestResultCell.itemIdentifier)
    }
}

extension TestResultsCollectionViewOutlets: NSCollectionViewDelegateFlowLayout {
    
}

extension TestResultsCollectionViewOutlets: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return testResults.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: TestResultCell.itemIdentifier, for: indexPath) as? TestResultCell
        return item
    }
}
