//
//  Networking.swift
//  LvMP
//
//  Created by Jinu Kim on 29/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import  SocketIO
//import Alamofire

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    static let stateUpdateNotificationKey = Notification.Name("paringStateUpdated")
    
    let manager = SocketManager(socketURL: URL(string: "http://10.80.163.248:3000")!)
    lazy var socket: SocketIOClient = {
        return manager.defaultSocket
    }()
    
    var isConnected = false
    var isParing = false
    
    override init() {
        super.init()
        socket.on(clientEvent: .connect) { data, ack in
            self.isConnected = true
            print("-Server Connected!")
        }
        
        socket.on("kind") { data, ack in
            self.socket.emit("kind", 1)
        }
        
        socket.on("paring") { data, ack in
            self.isParing = data[0] as? Bool ?? false
        }
        
        socket.on("uploadReady") { data, ack in
            guard let url = URL(string: "http://127.0.0.1:3000/receiveFilesTest") else {
                return
            }
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
                if let error = error {
                    print("Error >> SocketIOManager >> socket.on(\"uploadReady\"): Request error: \(error.localizedDescription)")
                    return
                }
                
                guard let jsonData = data else {
                    return
                }
                do {
                    //                    print(String(data: data, encoding: .utf8))
                    print(jsonData)
                    let apiResponse: ResponseFiles = try JSONDecoder().decode(ResponseFiles.self, from: jsonData)
                    print(apiResponse.files.count)
                    Music.saves(files: apiResponse.files, with: apiResponse.types)
                } catch {
                    print("Error >> SocketIOManager >> socket.on(\"uploadReady\"): Response error:\(error.localizedDescription)")
                }
                
                
            }
            dataTask.resume()
            print("Write finish!")
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            self.isConnected = false
            print("-Server Disconnected!")
        }
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }

}
