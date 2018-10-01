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
}

