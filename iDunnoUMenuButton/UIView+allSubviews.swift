//
//  UIView+allSubviews.swift
//  iDunnoUMenuButton
//
//  Created by Jacob Clayden on 26/04/2020.
//  Copyright © 2020 JacobCXDev. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - Computed Properties
    var allSubviews: [UIView] {
        return allSubviews().sorted { $0.1 < $1.1 }.map(\.0)
    }
    
    // MARK: - Funcs
    func allSubviews(currentDepth depth: Int = 0) -> [(UIView, Int)] {
        var allSubviews = [(UIView, Int)]()
        allSubviews += subviews.map { ($0, depth)}
        for subview in subviews {
            allSubviews += subview.allSubviews(currentDepth: depth + 1)
        }
        return allSubviews
    }
    
}
