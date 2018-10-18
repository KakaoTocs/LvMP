//
//  SocketIOManager.swift
//  LvMP-Mac
//
//  Created by Jinu Kim on 01/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import SocketIO
//import Alamofire

class SocketIOManager: NSObject {
    // MARK: - Static Property
    static let shared = SocketIOManager()
    static let serverConnectionstateUpdateNotificationKey = Notification.Name("connectionStateUpdated")
    static let paringStateUpdateNotificationKey = Notification.Name("paringStateUpdated")
    
    // MARK: - Property
    let manager = SocketManager(socketURL: URL(string: "http://127.0.0.1:3000")!)
    var socket: SocketIOClient?
    var isConnected: Bool = false
    var isParing: Bool = false
    
    // MARK: - Init Method
    override init() {
        super.init()
        socket = manager.defaultSocket
        
        // 서버와 연결시 작업
        socket?.on(clientEvent: .connect) { data, ack in
            print("Server Connected!")
            self.isConnected = true
            NotificationCenter.default.post(name: SocketIOManager.serverConnectionstateUpdateNotificationKey, object: nil)
        }
        
        // 연결시 Mac이라는 것을 알리기위한 작업
        socket?.on("kind") { data, ack in
            self.socket?.emit("kind", 0)
        }
        
        // iPhone과 연결/해제시 작업
        socket?.on("paring") { data, ack in
            let state = data[0] as? Bool ?? false
            self.isParing = state
            NotificationCenter.default.post(name: SocketIOManager.paringStateUpdateNotificationKey, object: nil)
        }
        
        // 서버와 연결 해제시 작업
        socket?.on(clientEvent: .disconnect) { data, ack in
            print("-Server Disconnected!")
            self.isConnected = false
            self.isParing = false
            NotificationCenter.default.post(name: SocketIOManager.paringStateUpdateNotificationKey, object: nil)
            NotificationCenter.default.post(name: SocketIOManager.serverConnectionstateUpdateNotificationKey, object: nil)
        }
    }
    
    // MARK: - Method
    // 연결 메소드
    func connect() {
        socket?.connect()
    }
    
    // 연결해제 메소드
    func disconnect() {
        socket?.disconnect()
    }
    
    // 파일 전송 메소드
    func sendFile(folder: Folder) {
        var files: [Music] = []
        
        files = readAllFileInFolder(folder: folder)
        
        guard let url = URL(string: "http://127.0.0.1:3000/uploadFiles") else {
            return
        }
        
        let session: URLSession = URLSession(configuration: .default)
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let requestFiles = RequestFileType(files: files.map{ $0.file }, types: files.map{ $0.type })
            let jsonData = try JSONEncoder().encode(requestFiles)
            urlRequest.httpBody = jsonData
        } catch {
            print("Error >> SocketIOManager >> sendFile(folder: Folder): jsonFormatting error")
        }
        
        let uploadTask: URLSessionDataTask = session.uploadTask(with: urlRequest, from: nil) { (data: Data?, response: URLResponse?, error: Error?) in
            if let jsonData = data {
                do {
                    let dataStruct = try JSONDecoder().decode(NetworkResponse.self, from: jsonData)
                    print("Count: \(files.count), Code: \(dataStruct.code), Message: \(dataStruct.message)")
                } catch {
                    print("Error >> SocketIOManager >> sendFile(folder: Folder): dataTask error: \(error.localizedDescription)")
                }
            }
        }
        uploadTask.resume()
    }
    
    // 루트디렉토리안에 있는 모든 파일을 배열로 반환하는 메소드
    private func readAllFileInFolder(folder: Folder) -> [Music] {
        var files: [Music] = []
        
        files = folder.files
        for childFolder in folder.folders {
            files += readAllFileInFolder(folder: childFolder)
        }
        
        return files
    }
    
}
