//
//  Networking.swift
//  LvMP
//
//  Created by Jinu Kim on 29/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import  SocketIO
import Alamofire

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    static let stateUpdateNotificationKey = Notification.Name("paringStateUpdated")
    
    let manager = SocketManager(socketURL: URL(string: "http://127.0.0.1:3000")!)
    var socket: SocketIOClient?
    
    var isConnected = false
    var isParing = false
    
    override init() {
        super.init()
        socket = manager.defaultSocket
        
        socket?.on(clientEvent: .connect) { data, ack in
            self.isConnected = true
            print("-Server Connected!")
        }
        
        socket?.on("kind") { data, ack in
            self.socket?.emit("kind", 1)
        }
        
        socket?.on("paring") { data, ack in
            self.isParing = data[0] as? Bool ?? false
        }
        
        socket?.on("uploadReady") { data, ack in
            Alamofire.request("http://127.0.0.1:3000/receiveFiles", method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    guard let resJSON = response.result.value as? [String:Any] else {
                        return
                    }
                    
                    let types = resJSON["types"] as! [String]
                    
                    let filesTemp = resJSON["files"] as! [Any]
                    let filesTempJSON = filesTemp.map{ $0 as! [String:Any] }
//                    let filesData:[Data] = filesTempJSON.map{ ($0["data"] as! Data) }
//                    let files = filesData
                    let filesData:[[UInt8]] = filesTempJSON.map{ ($0["data"] as? [UInt8])! } //
                    let files: [Data] = filesData.map { Data(bytes: $0) }
                    
                    if types.count != files.count {
                        return
                    }
                    print("Received data count: \(files.count)")
                    Music.saves(files: files, with: types)
//                    self.addMusicFiles(files: files, types: types)
                    print("Write finish!")
            }
        }
        
        socket?.on(clientEvent: .disconnect) { data, ack in
            self.isConnected = false
            print("-Server Disconnected!")
        }
    }
    
    func connect() {
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    
//    func addMusicFiles(files: [Data], types: [String]) {
//        for index in 0..<files.count {
//            let url = FilesManager.shared.rootDirectory.appendingPathComponent(UUID().uuidString + "." + types[index])
//            let result = FilesManager.shared.writeFile(at: url, file: files[index])
//            if result {
//                fileToMusic(at: url)
//            } else {
//                print("SocketIOManager >> addMusicFiles: File write error")
//            }
//        }
//    }
}
