//
//  iDUButton.swift
//  iDunnoUMenuButton
//
//  Created by Jacob Clayden on 24/04/2020.
//  Copyright © 2020 JacobCXDev. All rights reserved.
//

import UIKit

class iDUButton: UIButton, BadgeView {
    
    // MARK: - Enums
    enum SizeState: CGFloat {
        case normal = 22
        case expanded = 30
    }
    
    // MARK: - Properties
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    
    // MARK: - BadgeView Properties
    var badgeLabel = UILabel()
    var badgeCount: UInt = 0
    
    // MARK: - Observed Properties
    var sizeState: SizeState = .normal {
        didSet {
            if sizeState != oldValue {
                switch sizeState {
                case .normal:
                    widthConstraint.constant = SizeState.normal.rawValue
                    heightConstraint.constant = SizeState.normal.rawValue
                    break
                case .expanded:
                    widthConstraint.constant = SizeState.expanded.rawValue
                    heightConstraint.constant = SizeState.expanded.rawValue
                }
                layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Computed Properties
    var maxRect: CGRect {
        let rect = CGRect(x: 0, y: 0, width: SizeState.expanded.rawValue, height: SizeState.expanded.rawValue)
        return rect.union(badgeFrameForRect(rect: rect))
    }
    
    // MARK: - Init Methods
    init(image: UIImage? = nil, tintColor: UIColor = .systemBlue) {
        super.init(frame: CGRect(x: 0, y: 0, width: SizeState.normal.rawValue, height: SizeState.normal.rawValue))
        if let image = image {
            setImage(image, for: .normal)
        }
        self.tintColor = tintColor
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Private Funcs
    private func setup() {
        backgroundColor = .secondarySystemFill
        translatesAutoresizingMaskIntoConstraints = false
        widthConstraint = widthAnchor.constraint(equalToConstant: SizeState.normal.rawValue)
        heightConstraint = heightAnchor.constraint(equalToConstant: SizeState.normal.rawValue)
        widthConstraint.priority = .init(rawValue: 999)
        heightConstraint.priority = .init(rawValue: 999)
        widthConstraint.isActive = true
        heightConstraint.isActive = true
        setupBadge()
    }
    
    // MARK: - Override Funcs
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        layoutBadge()
    }
    
}
