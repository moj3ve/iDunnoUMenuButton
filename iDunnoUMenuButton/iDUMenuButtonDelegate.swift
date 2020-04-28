//
//  iDUMenuButtonDelegate.swift
//  iDunnoUMenuButton
//
//  Created by Jacob Clayden on 26/04/2020.
//  Copyright © 2020 JacobCXDev. All rights reserved.
//

import UIKit

protocol iDUMenuButtonDelegate: class {
    
    // MARK: - Funcs
    func menuButton(_ menuButton: iDUMenuButton, isExpandedDidUpdate isExpanded: Bool)
    
}
