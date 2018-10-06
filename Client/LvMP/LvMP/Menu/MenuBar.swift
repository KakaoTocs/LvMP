//
//  MenuBar.swift
//  LvMP
//
//  Created by Jinu Kim on 03/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit

class MenuBar: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var artistButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var itemState: UIView!
    @IBOutlet var itemStateleadingConstraint: NSLayoutConstraint!
    
    var itemWidth: CGFloat {
        return homeButton.bounds.width
    }
    
    private var selectedItem = MenuItem() {
        willSet(newValue) {
            itemStateUpdate(item: newValue)
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
        
        self.homeButton.addTarget(self, action: #selector(itemAction(_:)), for: .touchUpInside)
        self.musicButton.addTarget(self, action: #selector(itemAction(_:)), for: .touchUpInside)
        self.artistButton.addTarget(self, action: #selector(itemAction(_:)), for: .touchUpInside)
        self.albumButton.addTarget(self, action: #selector(itemAction(_:)), for: .touchUpInside)
    }
    
    fileprivate func itemStateUpdate(item: MenuItem) {
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
    
    func selectItem(item newItem: Int) {
        guard let newItem = MenuItem(rawValue: newItem) else {
            print("Error >> MenuBar >> selectItem: menuButton change type(Int -> Enum) ")
            return
        }
        selectedItem = newItem
    }
    
    @objc fileprivate func itemAction(_ sender: UIButton!) {
//        selectItem(item: sender.tag)
    }
    

}
