//
//  File.swift
//  Alarm
//
//  Created by Wang Sheng Ping on 2021/1/9.
//

import Foundation

struct Time: Codable {
    var time: Date = Date()
    var label: String = "Alarm"
    var selectedDays : Set<WeekDay> = []
    var infoArray = ["Repeat", "Label", "Sound", "Snooze"]
    
    var selectedWeek : String {
        switch selectedDays{
        case [.Sunday,.Saturday]:
            return "Weekends"
        case [.Monday,.Tuesday,.Wednesday,.Thursday,.Friday]:
            return "Weekdays"
        case [.Sunday,.Monday,.Tuesday,.Wednesday,.Thursday,.Friday,.Saturday]:
            return "Every day"
        case []:
            return "Never"
        default:
            return selectedDays
                .sorted(by: { $0.rawValue < $1.rawValue })
                .map({$0.title}).joined(separator: " ")
        }
    }

}

enum WeekDay: Int, CaseIterable, Codable {
    case Sunday = 0, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    
    var title: String {
        switch self{
        case .Sunday:    return "Sun"
        case .Monday:    return "Mon"
        case .Tuesday:   return "Tue"
        case .Wednesday: return "Wed"
        case .Thursday:  return "Thu"
        case .Friday:    return "Fri"
        case .Saturday:  return "Sat"
        }
    }
}



