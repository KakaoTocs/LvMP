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
    
    var isConnected = false;
    
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
            let state = data[0] as? Bool ?? false
            print(state)
        }
        
        socket?.on("uploadReady") { data, ack in
            Alamofire.request("http://127.0.0.1:3000/receiveFiles", method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { res in
                    guard let value = res.result.value as? [String:AnyObject] else {
                        return
                    }
                    guard let data = value as? [String: AnyObject] else {
                        return
                    }
                    print(data["types"] as! [String])
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
    
    // pc에서 파일+확장자명 전달 -> 앱에서 UUID+확장자로 저장 -> 읽어서 Music객체 생성 -> 인스턴스+경로 Realm에 저장 ->
    func addMusicFiles(files: [Data]) {
        for file in files {
            let url = FilesManager.shared.rootDirectory.appendingPathComponent(UUID().uuidString)
            let result = FilesManager.shared.writeFile(at: url, file: file)
            print(result)
            fileToMusic(at: url)
        }
    }
}
