//
//  iDUMenuCollectionView.swift
//  iDunnoUMenuButton
//
//  Created by Jacob Clayden on 24/04/2020.
//  Copyright © 2020 JacobCXDev. All rights reserved.
//

import UIKit

class iDUMenuCollectionView: UICollectionView {
    
    // MARK: - Private Properties
    private var heightConstraint: NSLayoutConstraint!
    
    // MARK: - Override Properties
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    // MARK: - Init Methods
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Private Funcs
    private func setup() {
        clipsToBounds = false
        isUserInteractionEnabled = false
        isScrollEnabled = false
        heightConstraint = heightAnchor.constraint(equalToConstant: 100)
        heightConstraint.priority = .init(rawValue: 999)
    }
    
    // MARK: - Override Funcs
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, intrinsicContentSize) {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        heightConstraint.constant = collectionViewLayout.collectionViewContentSize.height
        layoutIfNeeded()
    }
    
    // MARK: - Funcs
    func maxCellWidth() -> CGFloat {
        var width: CGFloat = 0
        for cell in visibleCells {
            width = max(width, cell.frame.width)
        }
        return width
    }
    
}
