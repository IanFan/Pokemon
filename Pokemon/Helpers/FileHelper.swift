//
//  FileHelper.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation

class FileHelper {
    static func saveDataToDisk(_ data: Data, forKey key: String) -> Bool {
        let fileURL = self.fileURL(forKey: key)
        
        let directoryURL = fileURL.deletingLastPathComponent()
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating directory: \(error)")
            return false
        }
        
        do {
            try data.write(to: fileURL)
            return true
        } catch {
            print("Error writing data to disk: \(error)")
            return false
        }
    }
    
    static func loadDataFromDisk(forKey key: String) -> Data? {
        let fileURL = self.fileURL(forKey: key)
        return try? Data(contentsOf: fileURL)
    }
    
    static func deleteDataFromDisk(forKey key: String) {
        let fileURL = self.fileURL(forKey: key)
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    static func fileURL(forKey key: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(key)
    }
}
