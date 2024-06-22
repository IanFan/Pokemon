//
//  JsonHelper.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation

class JsonHelper {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func storeJsonDic(json: [String: Any], forKey key: String) -> Bool {
        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
            let _ = storeJsonData(jsonData: jsonData, forKey: key)
            return true
        } else {
            print("*** Error storeJson key:\(key)")
            return false
        }
    }
    
    func storeJsonData(jsonData: Data, forKey key: String) -> Bool {
        userDefaults.set(jsonData, forKey: key)
        let timestampKey = "\(key)_timestamp"
        userDefaults.set(Date(), forKey: timestampKey)
        return true
    }
    
    func fetchJsonData(forKey key: String, validPeriod: TimeInterval? = nil) -> Data? {
        let timestampKey = "\(key)_timestamp"
        guard isValidPeriod(key: timestampKey, validPeriod: validPeriod) else {
            return nil
        }
        guard let jsonData = userDefaults.data(forKey: key) else { return nil }
        return jsonData
    }
    
    func fetchJsonDic(forKey key: String, validPeriod: TimeInterval? = nil) -> [String: Any]? {
        guard let jsonData = fetchJsonData(forKey: key, validPeriod: validPeriod) else { return nil }
        return try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
    }
    
    func clearJson(forKey key: String) {
        userDefaults.removeObject(forKey: key)
        userDefaults.removeObject(forKey: "\(key)_timestamp")
    }
    
    func isValidPeriod(key: String, validPeriod: TimeInterval?) -> Bool {
        let timestampKey = "\(key)_timestamp"
        if let validPeriod = validPeriod {
            if let time =  userDefaults.object(forKey: timestampKey) as? Date {
                print("time: \(time)")
                print("diff: \(Date().timeIntervalSince(time) < validPeriod)")
            }
            guard let timestamp = userDefaults.object(forKey: timestampKey) as? Date,
                  Date().timeIntervalSince(timestamp) < validPeriod else {
                return false
            }
        }
        return true
    }
    
    class func convertDataToJSONDict(data: Data) -> [String: AnyObject]? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            if let jsonDict = jsonObject as? [String: AnyObject] {
                return jsonDict
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    static func decode<T: Codable>(_ jsonDic: [String: Any], as type: T.Type) -> T? {
        print("\(#function) dictionary: \(jsonDic)")
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonDic, options: [])
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch {
            print("Decode error: \(error)")
            return nil
        }
    }
    
    class func getLocalJsonDic(fileName: String) -> [String: AnyObject]? {
        guard !fileName.isEmpty else {
            return nil
        }
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            print("*** Error - JSON file not found: \(fileName)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return convertDataToJSONDict(data: data)
        } catch {
            return nil
        }
    }
}
