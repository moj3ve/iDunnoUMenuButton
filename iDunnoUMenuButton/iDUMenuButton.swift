//
//  iDUMenuButton.swift
//  iDunnoUMenuButton
//
//  Created by Jacob Clayden on 24/04/2020.
//  Copyright © 2020 JacobCXDev. All rights reserved.
//

import UIKit

class iDUMenuButton: UIControl, BadgeView {
    
    // MARK: - Private Properties
    private var itemSize = CGSize(width: 30, height: 30)
    private var shadowRadius: CGFloat = 5
    private var heightConstraint: NSLayoutConstraint!
    private var collectionView: UICollectionView!
    private var timer: Timer?
    private var unorderedButtons = [iDUButton]()
    
    // MARK: - Weak Properties
    weak var delegate: iDUMenuButtonDelegate?
    
    // MARK: - BadgeView Properties
    var badgeLabel = UILabel()
    var badgeCount: UInt = 0
    
    // MARK: - Observed Properties
    var buttons = [iDUButton]() {
        didSet {
            buttons.forEach { $0.isUserInteractionEnabled = false }
            reloadCollectionView()
            selectFirstButton()
        }
    }
    
    var isExpanded = false {
        didSet {
            if isExpanded != oldValue {
                if isExpanded {
                    becomeFirstResponder()
                    let haptics = UIImpactFeedbackGenerator(style: .rigid)
                    haptics.impactOccurred()
                }
                guard let sv = self.superview else {
                    fatalError("\(description) does not have a superview.")
                }
                UIView.animate(withDuration: 0.3) {
                    self.heightConstraint.isActive = !self.isExpanded
                    sv.layoutIfNeeded()
                    self.layer.shadowOpacity = self.isExpanded ? 1 : 0
                    self.buttons.forEach { $0.setBadgeHidden(hidden: !self.isExpanded, animated: true) }
                }
                delegate?.menuButton(self, isExpandedDidUpdate: isExpanded)
            }
        }
    }
    
    // MARK: - Init Methods
    init(buttons: [iDUButton]? = nil, itemSize: CGSize? = nil) {
        super.init(frame: .zero)
        if let buttons = buttons {
            buttons.forEach { $0.setBadgeHidden(hidden: !isExpanded, animated: false) }
            self.buttons = buttons
            self.unorderedButtons = buttons
            selectFirstButton()
        }
        if let itemSize = itemSize {
            self.itemSize = itemSize
        }
        setup()
    }
    
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
        backgroundColor = .secondarySystemBackground
        layer.shadowColor = UIColor.systemFill.cgColor
        layer.shadowOpacity = 0
        layer.shadowOffset = .zero
        layer.shadowRadius = shadowRadius
        mask = UIView()
        mask?.backgroundColor = .black
        
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = heightAnchor.constraint(equalToConstant: itemSize.height)
        heightConstraint.isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 30, height: 30)

        collectionView = iDUMenuCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(iDUMenuCollectionViewCell.self, forCellWithReuseIdentifier: "iDUMenuCollectionViewCell")
        collectionView.isUserInteractionEnabled = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.backgroundColor = nil
        addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setupBadge()
    }
    
    // MARK: - Override Funcs
    override func layoutSubviews() {
        allSubviews.forEach { $0.isUserInteractionEnabled = false }
        
        layer.cornerRadius = frame.width / 2
        layoutBadge()
        
        let rect = maxButtonRect()
        mask?.frame.origin.x = rect.minX - shadowRadius * 2
        mask?.frame.origin.y = rect.minY - shadowRadius * 2
        mask?.frame.size.height = frame.height - rect.minY + shadowRadius * 4
        mask?.frame.size.width = max(frame.width, rect.width) + shadowRadius * 4
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if isExpanded {
            _ = updateButtonsWithTouch(touch, shouldHighlight: true, shouldSelect: false)
        } else {
            if timer != nil {
                timer?.invalidate()
            }
            timer = Timer.scheduledTimer(withTimeInterval: UILongPressGestureRecognizer().minimumPressDuration, repeats: false, block: { timer in
                self.isExpanded = true
            })
        }
        return true
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if isExpanded {
            _ = updateButtonsWithTouch(touch, shouldHighlight: true, shouldSelect: false)
        }
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard let touch = touch else {
            return
        }
        if isExpanded {
            if !updateButtonsWithTouch(touch, shouldHighlight: false, shouldSelect: true) {
                selectFirstButton()
            }
            isExpanded = false
        } else if timer != nil {
            timer?.fire()
            timer?.invalidate()
        }
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        selectFirstButton()
        isExpanded = false
        return true
    }
    
    // MARK: - Funcs
    func maxButtonRect() -> CGRect {
        var x: CGFloat = 0
        var y: CGFloat = 0
        var width: CGFloat = 0
        var height: CGFloat = 0
        buttons.forEach {
            let rect = $0.maxRect
            x = min(x, rect.minX)
            y = min(y, rect.minY)
            width = max(width, rect.width)
            height = max(height, rect.height)
        }
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func selectFirstButton() {
        if let button = unorderedButtons.first {
            button.isSelected = true
            UIView.animate(withDuration: 0.3) {
                button.sizeState = .expanded
            }
        }
    }

    func updateButtonsWithTouch(_ touch: UITouch, shouldHighlight: Bool, shouldSelect: Bool) -> Bool {
        var newButton: iDUButton?
        let indexPath = collectionView.indexPathForItem(at: touch.location(in: collectionView))
        if let indexPath = indexPath {
            newButton = unorderedButtons[indexPath.row]
        }
        for button in buttons {
            if button != newButton {
                button.isHighlighted = false
                button.isSelected = false
                UIView.animate(withDuration: 0.3) {
                    button.sizeState = .normal
                }
            }
        }
        guard let button = newButton else {
            return false
        }
        if !button.isHighlighted {
            let haptics = UISelectionFeedbackGenerator()
            haptics.selectionChanged()
        }
        button.isHighlighted = shouldHighlight
        button.isSelected = shouldSelect
        UIView.animate(withDuration: 0.3) {
            button.sizeState = .expanded
        }
        if shouldSelect {
            reloadCollectionView(topButton: button)
            button.sendActions(for: .touchUpInside)
        }
        return true
    }
    
    func reloadCollectionView(topButton button: iDUButton? = nil) {
        collectionView.performBatchUpdates({
            unorderedButtons = buttons
            if let button = button {
                unorderedButtons.removeAll { $0 == button }
                unorderedButtons.insert(button, at: 0)
            }
            collectionView.reloadSections(IndexSet(integer: 0))
        }, completion: nil)
    }
    
}

// MARK: - UICollectionViewDataSource
extension iDUMenuButton: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        unorderedButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iDUMenuCollectionViewCell", for: indexPath) as! iDUMenuCollectionViewCell
        cell.initPostDequeue(button: unorderedButtons[indexPath.row])
        return cell
    }
    
}
