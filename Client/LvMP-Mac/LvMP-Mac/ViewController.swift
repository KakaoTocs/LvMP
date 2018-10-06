//
//  ViewController.swift
//  LvMP-Mac
//
//  Created by Jinu Kim on 30/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Cocoa
import AVFoundation
import SocketIO

class ViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSScrollView!
    @IBOutlet weak var stateIcon: NSButton!
    @IBOutlet weak var stateLabel: NSTextField!
    @IBOutlet weak var filePathTextField: NSTextField!
    @IBOutlet weak var outlineView: NSOutlineView!
    
    var rootFolder: Folder = Folder(name: "empty")
    let types = ["mp3", "flac", "m4a", "WAV", "folder"]
    var state = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.paringStateUpdated(_:)), name: SocketIOManager.stateUpdateNotificationKey, object: nil)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: - IBAction Method
    @IBAction func getFiles(_ sender: NSButton) {
        let openPanel = NSOpenPanel()
        openPanel.showsResizeIndicator = true
        openPanel.showsHiddenFiles = false
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = true
        openPanel.allowedFileTypes = ["mp3", "flac", "m4a", "WAV", "ACC"]
        
        if openPanel.runModal() == NSApplication.ModalResponse.OK {
            let results = openPanel.urls
            //            dump(results)
            rootFolder = readAllFiles(name: "root", urls: results)
            outlineView.reloadData()
//            dump(rootFolder)
        } else {
            return
        }
    }
    
    @objc func paringStateUpdated(_ noti: Notification) {
        if let data = noti.userInfo?["state"] as? Bool {
            self.state = data
            self.stateUpdate()
        }
        
    }
    
    @IBAction func sendData(_ sender: NSButton) {
        SocketIOManager.shared.sendFile(folder: rootFolder)
    }

    // MARK: - Custom Method
    
    func stateUpdate() {
        if self.state {
            self.stateLabel.stringValue = "연결됨"
            self.stateIcon.image = NSImage(named: NSImage.Name(rawValue: "StateIcon_On"))
        } else {
            self.stateLabel.stringValue = "연결안됨"
            self.stateIcon.image = NSImage(named: NSImage.Name(rawValue: "StateIcon_Off"))
        }
    }
    func readAllFiles(name: String, urls: [URL]) -> Folder {
        let folder: Folder = Folder(name: name)
        var errorFiles: [String] = []
        let requiredAttributes = [URLResourceKey.typeIdentifierKey, URLResourceKey.fileSizeKey, URLResourceKey.isDirectoryKey, URLResourceKey.localizedNameKey]
        
        for url in urls {
            do {
                let properties = try (url as NSURL).resourceValues(forKeys: requiredAttributes)
                
                let type = String((properties[URLResourceKey.typeIdentifierKey] as? String)?.split(separator: ".")[1] ?? "")
                let size = (properties[URLResourceKey.fileSizeKey] as? NSNumber)?.int64Value ?? 0
                let isDirectory = (properties[URLResourceKey.isDirectoryKey] as? NSNumber)?.boolValue ?? false
                let name = properties[URLResourceKey.localizedNameKey] as? String ?? ""
                
                if !types.contains(type) {
                    continue
                }
                if isDirectory {
                    let fm = FileManager.default
                    do {
                        let items = try fm.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                        folder.folders.append(readAllFiles(name: name, urls: items))
                    } catch {
                        print("Error")
                    }
                } else {
                    if let file = readFile(url: url, size: UInt64(size), type: type) {
                        folder.files.append(file)
                    }
                }
            } catch {
                errorFiles.append(url.absoluteString)
            }
        }
        
        return folder
    }
    
    func readFile(url: URL, size: UInt64, type: String) -> Music? {
        let file = AVPlayerItem(url: url)
        let metaData = file.asset.metadata
        
        var title: String?
        var artist: String?
        var album: String?
        var artwork: Data?
        let frame = NSRect(x: 0, y: 0, width: 16, height: 16)
        var playTime: UInt64 = 0
        var fileData: Data?
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            playTime = UInt64(audioPlayer.duration)
            fileData = try Data(contentsOf: url)
        } catch {
            playTime = 0
            if fileData == nil {
                return nil
            }
        }
        
        for item in metaData {
            switch item.commonKey?.rawValue {
            case "title":
                let encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII)
                let euc = item.stringValue?.cString(using: String.Encoding(rawValue: encoding))
                print("1: \(String(utf8String: euc ?? [CChar(0)]))")
                // ?? Data(bytes: [UInt8(0)])
                
                let string = item.stringValue ?? "0"
                print(string)
                print(try NSString(contentsOfFile: string, encoding: 0))
//                let cp = String(data: string.data(using: String.Encoding.utf8)!, encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x422)))
                let response = NSString(data: string.data(using: String.Encoding.utf8)!, encoding: String.Encoding.ascii.rawValue)
                let a = response
                print(a)
                let result2 = response?.utf8String
                let b = String(cString: result2!, encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII)))
                let c = String(cString: result2!, encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x422)))
                
                let gTemp = (c ?? "하이루").cString(using: String.Encoding.utf8)
                let g = String(cString: gTemp ?? [0, 0, 0], encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x422)))
//                let dTemp = c!.data(using: .utf8)
//                let d = String(data: dTemp!, encoding: .ascii)
                let e = euckrEncoding(item.stringValue!)
                let fTemp = e.data(using: .ascii)
                let f = String(data: fTemp!, encoding: .utf8)
                
//                let enco = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.EUC_KR.rawValue))
//                let enco = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(kCFStringEncodingASCII))
//                let enco = String.Encoding.utf8
                let enco = String.Encoding.utf16
                print(enco)
                print(string.cString(using: enco))
                let encoData = string.data(using: enco) ?? Data()
                print(encoData)
                let attribu = try? NSAttributedString(data: encoData, options: [:], documentAttributes: nil)
                print(attribu?.string ?? "NULL")
                
                let hTemp1 = Array(string)
                print(hTemp1)
                let temp3 = String(hTemp1).utf8.map{ String($0).unicodeScalars }
                print(temp3)
                let hTemp2 = String(hTemp1).utf8.map{ Int8($0) }
                print(hTemp2)
                let h = String(cString: UnsafePointer<Int8>(hTemp2), encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x422)))
                // C7 D8 B9 D9 B6 F3 B1 E2
                print("2-1: \(a)")
                print("2-2: \(b)")
                print("2-3: \(c), C: ")
                print(gTemp)
                print(g)
                print("2-7: \(h)")
//                for char in c {
//                    print("\(char)-")
//                }
//                print("2-4: \(d)")
                print("2-5: \(e)")
                print("2-6: \(f)")
                
                
                let encoding2 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x422))
                let result3 = String(cString: item.stringValue!, encoding: encoding2)
                print("3: \(result3)\n")
                
                let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)
                let size = (item.stringValue?.lengthOfBytes(using: String.Encoding(rawValue: encodingEUCKR)))! + 1
                var buffer: [CChar] = [CChar](repeating: 0, count: size)
                let result4 = item.stringValue?.getCString(&buffer, maxLength: size, encoding: String.Encoding(rawValue: encodingEUCKR))
                print("4-1: \(buffer)")
                title = item.stringValue ?? "제목 없음"
            case "artist":
                artist = item.stringValue ?? "아티스트 없음"
            case "albumName":
                album = item.stringValue ?? "앨범 없음"
            case "artwork":
                let originalImage = NSImage(data: item.value as? Data ?? Data(bytes: [0]))
                let tempImage = originalImage?.bestRepresentation(for: frame, context: nil, hints: nil)
                let resizeImage = NSImage(size: NSSize(width: 16, height: 16), flipped: false, drawingHandler: { (_) -> Bool in
                    return (tempImage?.draw(in: frame))!
                })
                artwork = resizeImage.tiffRepresentation ?? Data(bytes: [0])
            default:
                break
            }
        }
        return Music(title: title!, artist: artist!, album: album!, size: size, type: type, artwork: artwork ?? Data(bytes: [UInt8(0)]), playTime: playTime, file: fileData!)
    }
    
    func euckrEncoding(_ query: String) -> String { //EUC-KR 인코딩
        
        let rawEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.EUC_KR.rawValue))
        let encoding = String.Encoding(rawValue: rawEncoding)
        
        let eucKRStringData = query.data(using: encoding) ?? Data()
        let outputQuery = eucKRStringData.map {byte->String in
            if byte >= UInt8(ascii: "A") && byte <= UInt8(ascii: "Z")
                || byte >= UInt8(ascii: "a") && byte <= UInt8(ascii: "z")
                || byte >= UInt8(ascii: "0") && byte <= UInt8(ascii: "9")
                || byte == UInt8(ascii: "_") || byte == UInt8(ascii: ".") || byte == UInt8(ascii: "-")
            {
                return String(Character(UnicodeScalar(UInt32(byte))!))
            } else if byte == UInt8(ascii: " ") {
                return "+"
            } else {
                return String(format: "%%%02X", byte)
            }
            }.joined()
        
        return outputQuery
    }
}

