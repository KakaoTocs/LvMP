//
//  Utility.swift
//  LvMP
//
//  Created by Jinu Kim on 15/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit

func warringAlert(title: String, message: String) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(okAction)
    
    return alertController
}


//extension UIViewController {
//    
//    var effect = UIBlurEffect(style: .dark)
//    lazy var effectView: UIVisualEffectView = {
//        let effectView = UIVisualEffectView(effect: effect)
//        effectView.frame = self.view.bounds
//        effectView.autoresizingMask = []
//        return effectView
//    }()
//    
//    func viewDidAppear(_ animated: Bool) {
//        self.backgroundImageToBack()
//    }
//    
//    private func backgroundImageToFront() {
//        self.view.bringSubviewToFront(self.backgroundImage)
//        self.view.bringSubviewToFront(self.backgroundImageEffectView)
//    }
//    
//    private func backgroundImageToBack() {
//        self.view.sendSubviewToBack(self.backgroundImageEffectView)
//        self.view.sendSubviewToBack(self.backgroundImage)
//    }
//}
