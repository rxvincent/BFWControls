//
//  UITableViewCell+Separator.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 12/12/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

/// To see the change in the storyboard, you must use a UITabelViewCell subclass that has @IBDesignable, such as DesignableTableViewCell.
public extension UITableViewCell {
    
    /// Arbitrarily large number. Must be larger than any possible screen dimension. Can't be .greatestFiniteMagnitude, since that causes a screen flash when the app is restored from background.
    private var hiddenInsetRight: CGFloat {
        if #available(iOS 10, *) {
            return 999999.0
        } else {
            // Workaround for iOS 9, which otherwise draws the separator to the left of separatorInset.left when separatorInset.right is large.
            return bounds.width - separatorInset.left
        }
    }
    
    private var hiddenInset: UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: hiddenInsetRight)
    }
    
    /// Hides the separator in a cell in a table view that is showing cell separators.
    @IBInspectable public var isSeparatorHidden: Bool {
        get {
            return separatorInset.right == hiddenInsetRight
        }
        set {
            update(isSeparatorHidden: newValue)
            observeFrameChanges()
        }
    }

    public func updateIsSeparatorHidden() {
        update(isSeparatorHidden: isSeparatorHidden)
    }
    
    public func update(isSeparatorHidden: Bool) {
        if isSeparatorHidden {
            if separatorInset.right != hiddenInsetRight {
                separatorInset = hiddenInset
            }
        }
    }
    
    // MARK - KVO
    
    private static var observations: Set<NSKeyValueObservation> = []
    
    private var observations: Set<NSKeyValueObservation> {
        return type(of: self).observations
    }
    
    private func observeFrameChanges() {
        if #available(iOS 10.0, *) {
            // No need
        } else {
            // TODO: Remove observations of cells before they are deallocated, to prevent crashing.
            let frameObservation = observe(\.frame) { (cell, change) in
                cell.update(isSeparatorHidden: true)
            }
            type(of: self).observations.insert(frameObservation)
            debugPrint("observations.count = \(observations.count)")
        }
    }
}
