//
//  BadgeView.swift
//  iDunnoUMenuButton
//
//  Created by Jacob Clayden on 25/04/2020.
//  Copyright © 2020 JacobCXDev. All rights reserved.
//

import UIKit

protocol BadgeView where Self: UIView {
    
    // MARK: - Properties
    var badgeLabel: UILabel { get }
    var badgeCount: UInt { get set }
    
    // MARK: - Funcs
    func badgeFrameForRect(rect: CGRect) -> CGRect
    func layoutBadge()
    func setBadgeCount(badgeCount: UInt)
    func setBadgeHidden(hidden: Bool, animated: Bool)
    func setupBadge()
    func updateBadge()
    
}

// MARK: - Default Implementations
extension BadgeView {
    func badgeFrameForRect(rect: CGRect) -> CGRect {
        let height = max(18, badgeLabel.frame.height + 5.0)
        let width = max(height, badgeLabel.frame.width + 10.0)
        return CGRect(x: rect.width - 5, y: -badgeLabel.frame.height / 2, width: width, height: height);
    }
    
    func layoutBadge() {
        badgeLabel.sizeToFit()
        badgeLabel.frame = badgeFrameForRect(rect: frame)
        badgeLabel.layer.cornerRadius = badgeLabel.frame.height / 2;
        badgeLabel.layer.masksToBounds = true;
    }
    
    func setBadgeCount(badgeCount: UInt) {
        self.badgeCount = badgeCount;
        self.updateBadge()
    }
    
    func setBadgeHidden(hidden: Bool, animated: Bool) {
        guard badgeCount != 0 else {
            return
        }
        if !hidden {
            self.badgeLabel.isHidden = false
        }
        UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
            self.badgeLabel.alpha = hidden ? 0 : 1
        }) { finished in
            if (hidden) {
                self.badgeLabel.isHidden = true
            }
        }
    }
    
    func setupBadge() {
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = .systemRed
        badgeLabel.textAlignment = .center
        badgeLabel.font = .preferredFont(forTextStyle: .caption1)
        badgeLabel.alpha = 0
        updateBadge()
        addSubview(badgeLabel)
    }
    
    func updateBadge() {
        if badgeCount != 0 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            badgeLabel.text = formatter.string(from: NSNumber(value: badgeCount))
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.badgeLabel.alpha = self.badgeCount == 0 ? 0 : 1
        })
        layoutSubviews()
    }
}
