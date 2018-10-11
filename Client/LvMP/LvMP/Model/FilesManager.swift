//
//  FilesManager.swift
//  LvMP
//
//  Created by Jinu Kim on 02/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Foundation

class FilesManager {
    static let shared = FilesManager()
    
    let fileManager = FileManager.default
    let rootDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func test() {
        print("RootPath: \(rootDirectory)")
        let testFilePath = rootDirectory.appendingPathComponent("TestFile.txt")
        let testDirectoryPath = rootDirectory.appendingPathComponent("TestDirectory")
        let contents = "LvMP File R/W Test"
        
        let directoryCreateTestResult = createDirectory(at: testDirectoryPath)
        let directoryRemoveTestResult = removeDirectory(at: testDirectoryPath)
        let fileWriteTestResult = writeFile(at: testFilePath, file: contents.data(using: .utf8)!)
        let fileRemoveTestResult = removeFile(at: testFilePath)
        print("DirectoryCreate: \(directoryCreateTestResult)\nDirectoryRemove: \(directoryRemoveTestResult)\nFileWrite: \(fileWriteTestResult)\nFileRemove: \(fileRemoveTestResult)")
    }
    
    func createDirectory(at url: URL) -> Bool {
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
        } catch {
            print("Error >> FilesManager >> createDirectory: \n\t\(error.localizedDescription)")
            return false
        }
        return true
    }
    
    func removeDirectory(at url: URL) -> Bool {
        do {
            try fileManager.removeItem(at: url)
        } catch let error {
            print("Error >> FilesManager >> removeDirectory: \n\t\(error.localizedDescription)")
            return false
        }
        return true
    }
    
    func writeFile(at url: URL, file: Data) -> Bool {
        do {
            try file.write(to: url)
        } catch let error {
            print("Error >> FilesManager >> writeFile: \n\t\(error.localizedDescription)")
            return false
        }
        return true
    }

    func removeFile(at url: URL) -> Bool {
        do {
            try fileManager.removeItem(at: url)
        } catch let error {
            print("Error >> FilesManager >> deleteFile: \n\t\(error.localizedDescription)")
            return false
        }
        return true
    }
    
    
}
