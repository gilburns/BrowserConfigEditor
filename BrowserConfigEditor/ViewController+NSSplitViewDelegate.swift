//
//  ViewController+NSSplitViewDelegate.swift
//  BrowserConfigEditor
//
//  Created by Gil Burns on 12/27/25.
//

import Cocoa

// MARK: - NSSplitViewDelegate
extension ViewController: NSSplitViewDelegate {
    func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        // Minimum width for left panel (Available Policies)
        return 400
    }

    func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        // Maximum width for left panel (leave at least 400 for right panel)
        return splitView.bounds.width - 400
    }

    func splitView(_ splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
        // Allow both panels to resize proportionally
        return true
    }
}
