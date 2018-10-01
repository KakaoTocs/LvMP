//
//  SocketIOManager.swift
//  LvMP-Mac
//
//  Created by Jinu Kim on 01/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import SocketIO

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    static let stateUpdateNotificationKey = Notification.Name("paringStateUpdated")
    
//    let manager = SocketManager(socketURL: URL(string: "http://127.0.0.1:3000")!, config: [.log(true), .compress])
    let manager = SocketManager(socketURL: URL(string: "http://127.0.0.1:3000")!)
    var socket: SocketIOClient?
    
    override init() {
        super.init()
        socket = manager.defaultSocket
        
        socket?.on(clientEvent: .connect) { data, ack in
            print("Server Connected!")
        }
        
        socket?.on("paring") { data, ack in
            let state = data[0] as? Bool ?? false
            print("Receive data: \(state)")
            NotificationCenter.default.post(name: SocketIOManager.stateUpdateNotificationKey, object: nil, userInfo: ["state":state])
        }
        
        socket?.on(clientEvent: .disconnect) { data, ack in
            NotificationCenter.default.post(name: SocketIOManager.stateUpdateNotificationKey, object: nil, userInfo: ["state":false])
        }
    }
    
    func connect() {
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    func sendFile(folder: Folder) {
        let files: [Data] = readAllFileInFolder(folder: folder)
        socket?.emit("data", ["files": files])
    }
    
    func readAllFileInFolder(folder: Folder) -> [Data] {
        var files: [Data] = []
        files = folder.files.reduce([Data]()) { $0 + [$1.file] }
        
        for childFolder in folder.folders {
            files += readAllFileInFolder(folder: childFolder)
        }
        
        return files
    }
    
}
