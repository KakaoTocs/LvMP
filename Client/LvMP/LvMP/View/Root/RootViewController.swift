//
//  RootViewController.swift
//  LvMP
//
//  Created by Jinu Kim on 03/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit
import RealmSwift

class RootViewController: UIViewController {
    
    @IBOutlet weak var menuBar: MenuBar!
    @IBOutlet weak var playerBar: PlayerBar!
    @IBOutlet weak var scrollViewContainerViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundImageEffectView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBar.delegate = self
        print(FilesManager.shared.rootDirectory.absoluteString)
        scrollViewContainerViewWidth.constant = UIScreen.main.bounds.size.width * 4
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        self.backgroundImageToBack()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func backgroundImageToFront() {
        self.view.bringSubviewToFront(self.backgroundImage)
        self.view.bringSubviewToFront(self.backgroundImageEffectView)
    }
    
    func backgroundImageToBack() {
        self.view.sendSubviewToBack(self.backgroundImageEffectView)
        self.view.sendSubviewToBack(self.backgroundImage)
    }

}

// MARK: - Extension UIScrollViewDelegate
extension RootViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        menuBar.selectItem(at: currentPage)
    }
}

// MARK: - Extension MenuBarDelegate
extension RootViewController: MenuBarDelegate {
    func selectedMenu(at index: Int) {
        scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.size.width * CGFloat(index), y: 0), animated: true)
    }
}
