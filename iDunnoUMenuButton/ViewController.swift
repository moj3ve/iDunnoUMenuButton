//
//  ViewController.swift
//  iDunnoUMenuButton
//
//  Created by Jacob Clayden on 24/04/2020.
//  Copyright © 2020 JacobCXDev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Private Properties
    private let listMetadata: [(UIImage?, UIColor)] = [
        (UIImage(systemName: "person.crop.circle"), .systemBlue),
        (UIImage(systemName: "questionmark.circle"), .systemBlue),
        (UIImage(systemName: "circle.fill"), .systemRed),
        (UIImage(systemName: "circle.fill"), .systemOrange),
        (UIImage(systemName: "circle.fill"), .systemYellow),
        (UIImage(systemName: "circle.fill"), .systemGreen),
        (UIImage(systemName: "circle.fill"), .systemBlue),
        (UIImage(systemName: "circle.fill"), .systemPurple),
        (UIImage(systemName: "circle.fill"), .systemGray)
    ]
    
    // MARK: - Override Funcs
    override func loadView() {
        super.loadView()
        
        var buttons = [iDUButton]()
        listMetadata.forEach {
            let button = iDUButton(image: $0.0, tintColor: $0.1)
            button.setBadgeCount(badgeCount: UInt.random(in: 0 ... 10))
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            buttons.append(button)
        }
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.widthAnchor.constraint(equalToConstant: 30).isActive = true
        container.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let dimmingView = iDUMenuButtonDimmingView()
        container.addSubview(dimmingView)

        let menu = iDUMenuButton(buttons: buttons)
        menu.delegate = dimmingView
        dimmingView.menuButton = menu
        container.addSubview(menu)
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        menu.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        menu.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        menu.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        
        let bbi = UIBarButtonItem(customView: container)
        navigationItem.leftBarButtonItem = bbi
        navigationItem.title = "Messages"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - @objc Funcs
    @objc func buttonTapped() {
        print("Button tapped")
    }

}
