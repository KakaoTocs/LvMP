//
//  OutlineView.swift
//  LvMP-Mac
//
//  Created by Jinu Kim on 30/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Cocoa

extension ViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if let folder = item as? Folder {
            return folder.totalCount
        }
        return self.rootFolder.totalCount
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let folder = item as? Folder {
            if index < folder.folders.count {
                return folder.folders[index]
            }
            return folder.files[index - folder.folders.count]
        }
        if index < rootFolder.folders.count {
            return rootFolder.folders[index]
        }
        return rootFolder.files[index - rootFolder.folders.count]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if item is Folder {
            return true
        }
        return false
    }
}

extension ViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
        
        if let folder = item as? Folder {
            switch tableColumn?.identifier.rawValue {
            case "TitleColumn":
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TitleCell"), owner: self) as? NSTableCellView
                view?.textField?.stringValue = folder.name
                view?.imageView?.image = NSImage(named: NSImage.Name(rawValue: "Folder"))
                view?.textField?.sizeToFit()
            case "TypeCell":
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TypeCell"), owner: self) as? NSTableCellView
                view?.textField?.stringValue = folder.type
                view?.imageView?.image = nil
                view?.textField?.sizeToFit()
            default:
                view?.textField?.stringValue = ""
                view?.textField?.sizeToFit()
            }
        } else if let file = item as? Music {
            switch tableColumn?.identifier.rawValue {
            case "TitleColumn":
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TitleCell"), owner: self) as? NSTableCellView
                view?.textField?.stringValue = file.title
                view?.imageView?.image =  NSImage(data: file.artwork)
                view?.textField?.sizeToFit()
            case "AlbumColumn":
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TitleCell"), owner: self) as? NSTableCellView
                view?.textField?.stringValue = file.album
                view?.imageView?.image = nil
                view?.textField?.sizeToFit()
            case "ArtistColumn":
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TitleCell"), owner: self) as? NSTableCellView
                view?.textField?.stringValue = file.artist
                view?.imageView?.image = nil
                view?.textField?.sizeToFit()
            case "PlayTimeColumn":
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TitleCell"), owner: self) as? NSTableCellView
                view?.textField?.stringValue = String(format: "%2d분 %2d초", file.playTime / 60, file.playTime % 60)
                view?.imageView?.image = nil
                view?.textField?.sizeToFit()
            case "SizeColumn":
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TitleCell"), owner: self) as? NSTableCellView
                view?.textField?.stringValue = String(format: "%.2f MB", Double(Double(file.size) / 1000000.0))
                view?.imageView?.image = nil
                view?.textField?.sizeToFit()
            case "TypeColumn":
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TitleCell"), owner: self) as? NSTableCellView
                view?.textField?.stringValue = file.type
                view?.imageView?.image = nil
                view?.textField?.sizeToFit()
            default:
                view?.textField?.sizeToFit()
            }
        }
        return view
    }
}
