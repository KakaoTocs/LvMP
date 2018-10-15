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
