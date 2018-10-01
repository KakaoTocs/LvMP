//
//  AppDelegate.swift
//  LvMP-Mac
//
//  Created by Jinu Kim on 30/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        SocketIOManager.shared.connect()
    }
    
    func applicationDidResignActive(_ notification: Notification) {
        SocketIOManager.shared.disconnect()
    }

}

