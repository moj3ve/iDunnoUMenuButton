//
//  iDUMenuCollectionViewCell.swift
//  iDunnoUMenuButton
//
//  Created by Jacob Clayden on 24/04/2020.
//  Copyright © 2020 JacobCXDev. All rights reserved.
//

import UIKit

class iDUMenuCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var button: iDUButton?
    
    // MARK: - Funcs
    func initPostDequeue(button: iDUButton) {
        self.button = button
        isUserInteractionEnabled = false
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
}
