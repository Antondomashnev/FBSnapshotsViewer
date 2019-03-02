//
//  TestResultSplitView.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 13.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import AppKit

class TestResultSplitView: NSView {
    @IBOutlet private weak var splitReferenceImageView: NSImageView!
    @IBOutlet private weak var splitFailedImageView: NSImageView!
    @IBOutlet private weak var splitReferenceMaskView: NSView!
    @IBOutlet private weak var splitFailedMaskView: NSView!
    @IBOutlet private weak var splitSeparatorView: NSView!
    @IBOutlet private weak var splitReferenceMaskViewTrailing: NSLayoutConstraint!
    @IBOutlet private weak var splitFailedMaskViewLeading: NSLayoutConstraint!
    @IBOutlet private weak var splitSeparatorViewHorizontalCenter: NSLayoutConstraint!
    
    private var trackingArea: NSTrackingArea!
    private lazy var selfMidX: CGFloat = {
        return self.bounds.width / 2
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
        resetConstraints()
        createTrackingArea()
    }
    
    // MARK: - Helpers
    
    private func createTrackingArea() {
        trackingArea = NSTrackingArea(rect: bounds, options: NSTrackingArea.Options.mouseEnteredAndExited.union(NSTrackingArea.Options.mouseMoved).union(NSTrackingArea.Options.activeAlways), owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
    private func prepareUI() {
        [splitReferenceMaskView, splitFailedMaskView].forEach {
            $0?.wantsLayer = true
            $0?.layer?.masksToBounds = true
        }
    }
    
    private func resetConstraints() {
        splitReferenceMaskViewTrailing.constant = selfMidX
        splitFailedMaskViewLeading.constant = selfMidX
        splitSeparatorViewHorizontalCenter.constant = 0
        layoutSubtreeIfNeeded()
    }
    
    private func configureBordersColorScheme(for appleInterfaceMode: AppleInterfaceMode) {
        let borderColor = Color.divider(for: appleInterfaceMode)
        splitSeparatorView.wantsLayer = true
        splitSeparatorView.layer?.backgroundColor = borderColor.cgColor
    }
    
    private func updateConstraints(with event: NSEvent) {
        guard let contentView = event.window?.contentView else {
            return
        }
        let convertedPoint = convert(event.locationInWindow, from: contentView)
        let contentViewOrigin = contentView.frame.origin
        let mousePosition = NSPoint(x: convertedPoint.x - contentViewOrigin.x, y: convertedPoint.y - contentViewOrigin.y)
        splitSeparatorViewHorizontalCenter.constant = mousePosition.x - selfMidX
        splitReferenceMaskViewTrailing.constant = bounds.width - mousePosition.x
        splitFailedMaskViewLeading.constant = mousePosition.x
    }
    
    // MARK: - Interface
    
    func configure(with testResult: TestResultDisplayInfo, appleInterfaceMode: AppleInterfaceMode = AppleInterfaceMode()) {
        resetUI()
        if let referenceImage = NSImage(contentsOf: testResult.referenceImageURL) {
            splitReferenceImageView.image = referenceImage
        }
        if let failedImageURL = testResult.failedImageURL, let failedImage = NSImage(contentsOf: failedImageURL) {
            splitFailedImageView.image = failedImage
        }
        configureBordersColorScheme(for: appleInterfaceMode)
    }
    
    func resetUI() {
        splitReferenceImageView.image = nil
        splitFailedImageView.image = nil
    }
    
    // MARK: - TrackingEvents
    
    override func mouseExited(with event: NSEvent) {
        resetConstraints()
    }
    
    override func mouseEntered(with event: NSEvent) {
        updateConstraints(with: event)
    }
    
    override func mouseMoved(with event: NSEvent) {
        updateConstraints(with: event)
    }
}
