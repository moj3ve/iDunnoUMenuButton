//
//  iDUMenuButtonDimmingView.swift
//  iDunnoUMenuButton
//
//  Created by Jacob Clayden on 26/04/2020.
//  Copyright © 2020 JacobCXDev. All rights reserved.
//

import UIKit

class iDUMenuButtonDimmingView: UIView {
    
    // MARK: - Weak Properties
    weak var menuButton: iDUMenuButton?
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Private Funcs
    private func setup() {
        backgroundColor = .black
        alpha = 0
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Override Funcs
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if let window = window {
            topAnchor.constraint(equalTo: window.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
            leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        menuButton?.isExpanded = false
    }
    
}

// MARK: - iDUMenuButtonDelegate
extension iDUMenuButtonDimmingView: iDUMenuButtonDelegate {
    
    func menuButton(_ menuButton: iDUMenuButton, isExpandedDidUpdate isExpanded: Bool) {
        isUserInteractionEnabled = isExpanded
        UIView.animate(withDuration: 0.3) {
            self.alpha = isExpanded ? 0.2 : 0
        }
    }
    
}
