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
        }
        
        socket?.on("uploadReady") { data, ack in
            Alamofire.request("http://127.0.0.1:3000/receiveFiles", method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { res in
                    guard let value = res.result.value as? [String:AnyObject] else {
                        return
                    }
                    guard let data = value as? [String: Any] else {
                        return
                    }
                    let temp2 = data["types"] as? [String]
                    print(temp2)
                    
                    let filesAny = data["files"] as! [Any]
                    let filesJSON = filesAny.map{ $0 as! [String:Any] }
                    let fileTemp = filesJSON[0]["data"] as? [UInt8]
                    let fileData = Data(bytes: fileTemp!)
                    print(fileData)
//                    print(filesAny)
//                    dump(print(filesAny))
//                    let dd = filesAny[0] as? String
//                    print(dd?.count)
                    
                    
//                    let da = filesJSON[0]["data"] as? Data
//                    print(da)
//                    dump(filesJSON)
//                    print(filesJSON["type"])
                    
                    
                    //                    let result = temp.map { String(data: $0, encoding: String.Encoding.utf8) }
//                    print(temp2)
//                    print(data["files"])
//                    print(data["files"])
//                    let temp6 = data["files"] as? Data
//                    print(temp6?.count)
//                    print(data["files"] as? [String])
//                    let temp1 = data["files"] as? [Data]
//                    print(temp1)
//                    print(temp1?.count)
                    
                    
//                    let temp3 = temp1?[0] as? [String:Any]
//                    dump(temp3)
//                    print(temp3?["buffer"] as? Data)
//                    print(temp1?[0].count)
//                    print(temp1?[1].count)
//                    let temp3 = temp1?[0] as Any
//                    let temp4 = temp3 as? Data
//                    print(temp4)
//                    print(temp1?[1].count)
//                    let temp3 = (temp1?[0].map{UInt8(})! as [UInt8]
//                    print(temp3)
//                    print(temp1?[0].utf8.count)
                    
//                    print(Data())
//                    print(temp4?.count)
//                    let nsTemp = NSString(string: temp[0])
//                    let nsData = nsTemp.data(using: String.Encoding.ascii.rawValue)
//                    print(nsData)
//                    let fileData = temp[0].data(using: String.Encoding.ascii)
//                    print(fileData)e
//                    let files = temp as! [Data]
//                    dump(files)
//                    let files = temp.map{ Data(bytes: $0.map{UInt8(String($0))!})  }
//                    print(files.count)
                    
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
