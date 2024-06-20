//
//  PrefHelper.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation

class PrefHelper {
    static func getInt(_ key: String, _ defaultKey: Int) -> Int {
        let prefs = UserDefaults.standard
        if prefs.object(forKey: key) == nil {
            return defaultKey
        } else {
            return prefs.integer(forKey: key)
        }
    }

    static func setInt(_ key: String, _ value: Int) {
        let prefs = UserDefaults.standard
        prefs.set(value, forKey: key)
    }

    static func getFloat(_ key: String, _ defaultKey: Float) -> Float {
        let prefs = UserDefaults.standard
        if prefs.object(forKey: key) == nil {
            return defaultKey
        } else {
            return prefs.float(forKey: key)
        }
    }

    static func setFloat(_ key: String, _ value: Float) {
        let prefs = UserDefaults.standard
        prefs.set(value, forKey: key)
    }

    static func getBool(_ key: String, _ defaultKey: Bool) -> Bool {
        let prefs = UserDefaults.standard
        if prefs.object(forKey: key) == nil {
            return defaultKey
        } else {
            return prefs.bool(forKey: key)
        }
    }

    static func setBool(_ key: String, _ value: Bool) {
        let prefs = UserDefaults.standard
        prefs.set(value, forKey: key)
    }

    static func getString(_ key: String, _ defaultKey: String) -> String {
        let prefs = UserDefaults.standard
        return prefs.string(forKey: key) ?? defaultKey
    }

    static func setString(_ key: String, _ value: String) {
        let prefs = UserDefaults.standard
        prefs.setValue(value, forKeyPath: key)
    }

    static func setStringList(_ key: String, _ value: [String]) {
        let prefs = UserDefaults.standard
        prefs.setValue(value, forKeyPath: key)
    }

    static func getStringList(_ key: String) -> [String] {
        let prefs = UserDefaults.standard
        return prefs.stringArray(forKey: key) ?? [String]()
    }

    static func setBoolList(_ key: String, _ value: [Bool]) {
        let prefs = UserDefaults.standard
        prefs.setValue(value, forKeyPath: key)
    }

    static func getBoolList(_ key: String, _ defaultKey: [Bool]) -> [Bool] {
        let prefs = UserDefaults.standard
        return prefs.object(forKey: key) as? [Bool] ?? defaultKey
    }
}
