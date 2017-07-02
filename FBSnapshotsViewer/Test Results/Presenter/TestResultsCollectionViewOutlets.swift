//
//  TestResultsCollectionViewOutlets.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 03/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import AppKit

class TestResultsCollectionViewOutlets: NSObject {
    var testResultsDisplayInfo: TestResultsDisplayInfo = TestResultsDisplayInfo()
    fileprivate weak var testResultCellDelegate: TestResultCellDelegate?
    fileprivate weak var testResultsHeaderDelegate: TestResultsHeaderDelegate?

    init(collectionView: NSCollectionView, testResultCellDelegate: TestResultCellDelegate? = nil, testResultsHeaderDelegate: TestResultsHeaderDelegate? = nil) {
        guard let testResultCellNib = NSNib(nibNamed: TestResultCell.itemIdentifier, bundle: Bundle.main),
              let testResultHeaderNib = NSNib(nibNamed: TestResultsHeader.itemIdentifier, bundle: Bundle.main) else {
            fatalError("TestResultCell || TestResultsHeader is missing in bundle")
        }
        collectionView.register(testResultCellNib, forItemWithIdentifier: TestResultCell.itemIdentifier)
        collectionView.register(testResultHeaderNib, forSupplementaryViewOfKind: NSCollectionElementKindSectionHeader, withIdentifier: TestResultsHeader.itemIdentifier)
        self.testResultCellDelegate = testResultCellDelegate
        self.testResultsHeaderDelegate = testResultsHeaderDelegate
        super.init()
    }
}

extension TestResultsCollectionViewOutlets: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: 732, height: 408)
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, insetForSectionAt section: Int) -> EdgeInsets {
        return EdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: 732, height: 30)
    }
}

extension TestResultsCollectionViewOutlets: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return testResultsDisplayInfo.sectionInfos.count
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return testResultsDisplayInfo.sectionInfos[section].itemInfos.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> NSView {
        guard let view = collectionView.makeSupplementaryView(ofKind: NSCollectionElementKindSectionHeader, withIdentifier: TestResultsHeader.itemIdentifier, for: indexPath) as? TestResultsHeader else {
            fatalError("TestResultsHeader is not registered in collection view")
        }
        let sectionInfo = testResultsDisplayInfo.sectionInfos[indexPath.section]
        view.configure(with: sectionInfo)
        view.delegate = self.testResultsHeaderDelegate
        return view
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let item = collectionView.makeItem(withIdentifier: TestResultCell.itemIdentifier, for: indexPath) as? TestResultCell else {
            fatalError("TestResultCell is not registered in collection view")
        }
        let testResultInfo = testResultsDisplayInfo.sectionInfos[indexPath.section].itemInfos[indexPath.item]
        item.configure(with: testResultInfo, diffMode: testResultsDisplayInfo.testResultsDiffMode)
        item.delegate = testResultCellDelegate
        return item
    }
}
