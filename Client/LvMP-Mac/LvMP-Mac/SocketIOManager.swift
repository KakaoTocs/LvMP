//
//  SocketIOManager.swift
//  LvMP-Mac
//
//  Created by Jinu Kim on 01/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import SocketIO
import Alamofire

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    static let serverConnectionstateUpdateNotificationKey = Notification.Name("connectionStateUpdated")
    static let paringStateUpdateNotificationKey = Notification.Name("paringStateUpdated")
    
    var isConnected: Bool = false
    var isParing: Bool = false
    
    //    let manager = SocketManager(socketURL: URL(string: "http://127.0.0.1:3000")!, config: [.log(true), .compress])
    let manager = SocketManager(socketURL: URL(string: "http://127.0.0.1:3000")!)
    var socket: SocketIOClient?
    
    override init() {
        super.init()
        socket = manager.defaultSocket
        
        socket?.on(clientEvent: .connect) { data, ack in
            print("Server Connected!")
            self.isConnected = true
            NotificationCenter.default.post(name: SocketIOManager.serverConnectionstateUpdateNotificationKey, object: nil)
        }
        
        socket?.on("kind") { data, ack in
            self.socket?.emit("kind", 0)
        }
        
        socket?.on("paring") { data, ack in
            let state = data[0] as? Bool ?? false
            self.isParing = state
            NotificationCenter.default.post(name: SocketIOManager.paringStateUpdateNotificationKey, object: nil)
        }
        
        socket?.on(clientEvent: .disconnect) { data, ack in
            print("-Server Disconnected!")
            self.isConnected = false
            self.isParing = false
            NotificationCenter.default.post(name: SocketIOManager.paringStateUpdateNotificationKey, object: nil)
            NotificationCenter.default.post(name: SocketIOManager.serverConnectionstateUpdateNotificationKey, object: nil)
        }
    }
    
    func connect() {
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    func sendFile(folder: Folder) {
        var files: [Data] = []
        var types: [String] = []
        (files, types) = readAllFileInFolder(folder: folder)
        dump(files)
        dump(types)
        
        var result = Data()
        let json = ["types":types]
        do {
            result = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch {
            print("Error")
        }
        let temp = String(data: result, encoding: String.Encoding.utf8)!
        print(temp)
        let param: Parameters = ["data":temp]
        Alamofire.request("http://127.0.0.1:3000/uploadFiles", method: .post, parameters: param, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON { res in
                guard let value = res.result.value as? [String:Any] else {
                    return
                }
                print(value["code"])
                print(value["message"])
        }
//        socket?.emit("data", [files, types])
    }
    
    func readAllFileInFolder(folder: Folder) -> ([Data], [String]) {
        var files: [Data] = []
        var types: [String] = []
        var filesTemp: [Data] = []
        var typesTemp: [String] = []
        
        files = folder.files.reduce([Data]()) { $0 + [$1.file] }
        types = folder.files.reduce([String]()) { $0 + [$1.type] }
        
        for childFolder in folder.folders {
            (filesTemp, typesTemp) = readAllFileInFolder(folder: childFolder)
            files += filesTemp
            types += typesTemp
        }
        
        return (files, types)
    }
    
}
