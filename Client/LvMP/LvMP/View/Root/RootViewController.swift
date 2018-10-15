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
    @IBOutlet weak var scrollViewContainerViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBar.delegate = self
        print(FilesManager.shared.rootDirectory.absoluteString)
        scrollViewContainerViewWidth.constant = UIScreen.main.bounds.size.width * 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
