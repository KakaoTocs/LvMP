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
        SocketIOManager.shared.connect()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        SocketIOManager.shared.disconnect()
    }

}

