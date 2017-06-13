//
//  TestResultSplitView.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 13.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import AppKit

class TestResultSplitView: NSView {
    @IBOutlet weak var splitReferenceImageView: NSImageView!
    @IBOutlet weak var splitFailedImageView: NSImageView!
    @IBOutlet weak var splitReferenceMaskView: NSView!
    @IBOutlet weak var splitFailedMaskView: NSView!
    @IBOutlet weak var splitSeparatorView: NSView!
    @IBOutlet weak var splitReferenceMaskViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var splitFailedMaskViewLeading: NSLayoutConstraint!
    @IBOutlet weak var splitSeparatorViewHorizontalCenter: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [splitReferenceImageView, splitFailedImageView, splitReferenceMaskView, splitFailedMaskView].forEach {
            $0?.wantsLayer = true
        }
        splitReferenceImageView.layer?.masksToBounds = true
        splitFailedImageView.layer?.masksToBounds = true
        splitReferenceImageView.layer?.mask = splitReferenceMaskView.layer
        splitFailedImageView.layer?.mask = splitFailedMaskView.layer
        resetConstraints()
    }
    
    // MARK: - Helpers
    
    private func resetConstraints() {
        splitReferenceMaskViewTrailing.constant = self.bounds.width / 2
        splitFailedMaskViewLeading.constant = self.bounds.width / 2
        splitSeparatorViewHorizontalCenter.constant = 0
    }
    
    func configureBordersColorScheme(for appleInterfaceMode: AppleInterfaceMode) {
        let borderColor: NSColor
        switch appleInterfaceMode {
        case .dark:
            borderColor = NSColor(named: .dividerDarkMode)
        case .light:
            borderColor = NSColor(named: .dividerLightMode)
        }
        splitSeparatorView.wantsLayer = true
        splitSeparatorView.layer?.backgroundColor = borderColor.cgColor
    }
    
    // MARK: - NSEvent
    
    override func mouseEntered(with event: NSEvent) {
        Swift.print("Location: \(event.locationInWindow)")
    }
    
    override func mouseExited(with event: NSEvent) {
        resetConstraints()
    }
}
