//
//  MainWindowController.swift
//  01_Basic
//
//  Created by Jinu Kim on 29/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    @IBOutlet weak var textField: NSTextField!

    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @IBAction func generatePassword(sender: AnyObject) {
        let length = 8
        let generaterPassword = generateRandomString(length: length)
        textField.stringValue = generaterPassword
    }
    
}
