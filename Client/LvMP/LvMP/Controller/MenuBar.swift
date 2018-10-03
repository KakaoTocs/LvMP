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
    @IBOutlet weak var artistButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var homeState: UIView!
    @IBOutlet weak var artistState: UIView!
    @IBOutlet weak var albumState: UIView!
    
    private var selectedItem = MenuItem() {
        willSet(newValue) {
            itemStateUpdate(item: newValue)
        }
    }
    
    fileprivate enum MenuItem: Int {
        case home = 0
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
        self.artistButton.addTarget(self, action: #selector(itemAction(_:)), for: .touchUpInside)
        self.albumButton.addTarget(self, action: #selector(itemAction(_:)), for: .touchUpInside)
        self.homeState.backgroundColor = UIColor.blue
    }
    
    fileprivate func itemStateUpdate(item: MenuItem) {
        switch item {
        case .home:
            self.homeState.backgroundColor = UIColor.blue
            self.artistState.backgroundColor = UIColor.clear
            self.albumState.backgroundColor = UIColor.clear
        case .artist:
            self.homeState.backgroundColor = UIColor.clear
            self.artistState.backgroundColor = UIColor.blue
            self.albumState.backgroundColor = UIColor.clear
        case .album:
            self.homeState.backgroundColor = UIColor.clear
            self.artistState.backgroundColor = UIColor.clear
            self.albumState.backgroundColor = UIColor.blue
            
        }
    }
    
    @objc fileprivate func itemAction(_ sender: UIButton!) {
        guard let newState = MenuItem(rawValue: sender.tag) else {
            print("Error >> MenuBar >> itemAction: menuButton change type(Int -> Enum) ")
            return
        }
        selectedItem = newState
    }

}
