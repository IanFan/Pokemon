//
//  DateHelper.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation

class DateHelper {
    static func getTodayString(date: Date = Date(), dateFromat: String = "yyyy-MM-dd") -> String {
        let format = DateFormatter()
        format.dateFormat = dateFromat
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "UTC" }
        format.locale = Locale.init(identifier: localTimeZoneAbbreviation)
        format.timeZone = NSTimeZone.local

        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    static func isSameDay(key: String, saveToday: Bool = true) -> Bool {
        func getStoredTimeInterval(_ key: String) -> TimeInterval {
            let storedTimeInterval = UserDefaults.standard.double(forKey: key)
            return storedTimeInterval
        }

        func setStoredTimeInterval(_ key: String, _ timeInterval: TimeInterval) {
            UserDefaults.standard.set(timeInterval, forKey: key)
        }
        
        let todayTimeInterval: TimeInterval = Date().timeIntervalSince1970
            
        let storedDateTimeInterval: TimeInterval = getStoredTimeInterval(key)
            
        let isSameDay: Bool = Calendar.current.isDate(Date(timeIntervalSince1970: storedDateTimeInterval), inSameDayAs: Date(timeIntervalSince1970: todayTimeInterval))

        if todayTimeInterval < storedDateTimeInterval {
            return true
        }
        if isSameDay {
            return true
        } else {
            if saveToday {
                setStoredTimeInterval(key, todayTimeInterval)
            }
            return false
        }
    }
    
    static func getCurrentTimeString() -> String {
        return date2String(Date(), dateFormat: "yyyy/MM/dd HH:mm:ss")
    }
    
    static func date2String(_ date: Date, dateFormat: String = "yyyy/MM/dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }

    static func string2Date(_ string: String, dateFormat: String = "yyyy/MM/dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        return date
    }
    
    static func string2TimeInterval(_ string: String, dateFormat: String = "yyyy/MM/dd HH:mm:ss") -> TimeInterval? {
        guard let date = string2Date(string, dateFormat: dateFormat) else {
            return nil
        }
        return date.timeIntervalSince1970
    }
    
    static func string2TimeDouble(_ string: String, dateFormat: String = "yyyy/MM/dd HH:mm:ss") -> Double? {
        guard let date = string2Date(string, dateFormat: dateFormat) else {
            return nil
        }
        return Double(date.timeIntervalSince1970)
    }
}
