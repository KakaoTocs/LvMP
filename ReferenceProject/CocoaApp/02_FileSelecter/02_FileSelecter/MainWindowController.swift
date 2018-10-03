//
//  MainWindowController.swift
//  02_FileSelecter
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
    
    @IBAction func browsFile(sender: AnyObject) {
        let dialog = NSOpenPanel();
        
        dialog.title = "Choose a file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = true
        dialog.allowsMultipleSelection = true
        dialog.allowedFileTypes = ["mp3", "mp4"]
        
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            let result = dialog.url
            print(dialog.urls)
            if result != nil {
                let path = result?.path ?? "nil"
                textField.stringValue = path
            }
        } else {
            return
        }
    }
}
