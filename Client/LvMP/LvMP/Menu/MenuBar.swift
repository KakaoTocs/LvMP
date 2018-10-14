//
//  MenuBar.swift
//  LvMP
//
//  Created by Jinu Kim on 03/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit

@objc protocol MenuBarDelegate {
    func selectedMenu(at index: Int)
}

class MenuBar: UIView {
    // MARK: - Property
    @IBOutlet var contentView: UIView!
    @IBOutlet var menuButtons: [UIButton]!
    @IBOutlet weak var selectedMenuHint: UIView!
    @IBOutlet var itemStateleadingConstraint: NSLayoutConstraint!
    
    weak var delegate: MenuBarDelegate?
    
    var itemWidth: CGFloat {
        return menuButtons[0].bounds.width
    }
    
    private var selectedItem = MenuItem() {
        willSet(newValue) {
            itemStateUpdate(menu: newValue)
        }
    }
    
    enum MenuItem: Int {
        case home = 0
        case music
        case artist
        case album
        
        init() {
            self = .home
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MenuBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: - IBAction
    @IBAction func touchMenu(_ sender: UIButton) {
        if let index = menuButtons.firstIndex(of: sender) {
            delegate?.selectedMenu(at: index)
        } else {
            print("Error >> MenuBar >> touchMenu: selected index invalid")
        }
    }
    
    // MARK: - Custom Method
    fileprivate func itemStateUpdate(menu item: MenuItem) {
        switch item {
        case .home:
            itemStateleadingConstraint.constant = 0
        case .music:
            itemStateleadingConstraint.constant = itemWidth * 1
        case .artist:
            itemStateleadingConstraint.constant = itemWidth * 2
        case .album:
            itemStateleadingConstraint.constant = itemWidth * 3
            
        }
    }
    
    func selectItem(at index: Int) {
        guard let newItem = MenuItem(rawValue: index) else {
            print("Error >> MenuBar >> selectItem: menuButton change type(Int -> Enum) ")
            return
        }
        selectedItem = newItem
    }

}
