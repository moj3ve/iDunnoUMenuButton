//
//  iDUNavigationBar.swift
//  iDunnoUMenuButton
//
//  Created by Jacob Clayden on 26/04/2020.
//  Copyright © 2020 JacobCXDev. All rights reserved.
//

import UIKit

class iDUNavigationBar: UINavigationBar {
    
    // MARK: - Override Funcs
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in allSubviews {
            if subview.frame.contains(convert(point, to: subview)) {
                return true
            }
        }
        return super.point(inside: point, with: event)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = allSubviews.last {
            $0.isUserInteractionEnabled && $0.point(inside: convert(point, to: $0), with: event)
        }
        return view
    }
    
}
