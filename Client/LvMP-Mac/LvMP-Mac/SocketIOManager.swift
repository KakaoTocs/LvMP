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
        var files: [Music] = []
        
        files = readAllFileInFolder(folder: folder)
        print("Send files count: \(files.count)")
        
        Alamofire.upload(multipartFormData: { multipartFormData in
        for file in files {
            multipartFormData.append(file.file, withName: "files", fileName: "\(file.title).\(file.type)", mimeType: "audio/\(file.type)")
            multipartFormData.append(file.type.data(using: String.Encoding.utf8)!, withName: "types")
        }
        }, to: "http://127.0.0.1:3000/uploadFiles") { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { res in
                    guard let value = res.result.value as? [String:Any] else {
                        return
                    }
                    print(value["code"])
                    print(value["message"])
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func readAllFileInFolder(folder: Folder) -> [Music] {
        var files: [Music] = []
        var filesTemp: [Music] = []
        
        files = folder.files
        
        for childFolder in folder.folders {
            filesTemp = readAllFileInFolder(folder: childFolder)
            files += filesTemp
        }
        
        return files
    }
    
}
