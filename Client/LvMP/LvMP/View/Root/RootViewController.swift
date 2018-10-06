//
//  RootViewController.swift
//  LvMP
//
//  Created by Jinu Kim on 03/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    @IBOutlet weak var menuBar: MenuBar!
    @IBOutlet weak var scrollViewContainerViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FilesManager.shared.rootDirectory)
        scrollViewContainerViewWidth.constant = UIScreen.main.bounds.size.width * 4
        menuBar.homeButton.addTarget(self, action: #selector(self.menuBarButtonAction(_:)), for: .touchUpInside)
        menuBar.musicButton.addTarget(self, action: #selector(self.menuBarButtonAction(_:)), for: .touchUpInside)
        menuBar.artistButton.addTarget(self, action: #selector(self.menuBarButtonAction(_:)), for: .touchUpInside)
        menuBar.albumButton.addTarget(self, action: #selector(self.menuBarButtonAction(_:)), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func menuBarButtonAction(_ sender: UIButton) {
        scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.size.width * CGFloat(sender.tag), y: 0), animated: true)
    }

}

extension RootViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        menuBar.selectItem(item: currentPage)
    }
}
