//
//  Networking.swift
//  LvMP
//
//  Created by Jinu Kim on 29/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import  SocketIO

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    static let stateUpdateNotificationKey = Notification.Name("paringStateUpdated")
    
    let manager = SocketManager(socketURL: URL(string: "http://10.80.163.248:3000")!)
    var socket: SocketIOClient?
    
    override init() {
        super.init()
        socket = manager.defaultSocket
        
        socket?.on(clientEvent: .connect) { data, ack in
            print("-Server Connected!")
        }
        
        socket?.on(clientEvent: .disconnect) { data, ack in
            print("-Server Disconnected!")
        }
        
        socket?.on("clientData") { data, ack in
            guard let files = data[0] as? [Data] else {
                print("Error >> SocketIOManager >> socket.on(\"data\"): data type change([Any] -> [Data])")
                return
            }
            print("Recieve data: \(files.count)")
            self.addMusicFiles(files: files)
        }
        
        socket?.on("paringiPhone") { data, ack in
            let state = data[0] as? Bool ?? false
            print("Receive data: \(state)")
        }
    }
    
    func connect() {
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    func addMusicFiles(files: [Data]) {
        for file in files {
            let url = FilesManager.shared.rootDirectory.appendingPathComponent(UUID().uuidString + ".mp3")
            let result = FilesManager.shared.writeFile(at: url, file: file)
            print(result)
            fileToMusic(at: url)
        }
    }
}
