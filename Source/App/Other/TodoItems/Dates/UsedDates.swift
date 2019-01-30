//
//  UsedDates.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 30/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import Foundation

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}


class UsedDates {
    static let shared = UsedDates()
    private let formatter: DateFormatter
    var displayedDate = Date()
    var displayedMondayDate = Date()
    var selectdDayOfWeek = 2
    
    init() {
        formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        displayedDate = startDate
    }
    
    var startDate: Date {
        var startComponents = DateComponents()
        startComponents.calendar = Calendar.current
        startComponents.year = 2000
        startComponents.month = 12
        startComponents.day = 31
        startComponents.timeZone = TimeZone(abbreviation: "GMT")
        
        let res = Calendar.current.date(from: startComponents) ?? Date()
        
        return res
        
    }
    
    var endDate: Date {
        var startComponents = DateComponents()
        startComponents.year = 2034
        startComponents.month = 12
        startComponents.day = 31
        return Calendar.current.date(from: startComponents) ?? Date()
    }
    
    func getDayOfWeekLetterFromDayOfWeekNumber(dayOfWeekNumber: Int) -> String {
        switch dayOfWeekNumber {
        case 1:
            return "S"
        case 2:
            return "M"
        case 3:
            return "T"
        case 4:
            return "W"
        case 5:
            return "T"
        case 6:
            return "F"
        case 7:
            return "S"
        default:
            return "S"
        }
    }
    
    func getDateOfAnotherDayOfTheSameWeek(selectedDate: Date, requiredDayOfWeek: Int) -> Date {
        let calendar = Calendar.current
        let inputDateDayOfWeek = calendar.component(.weekday,
                                                    from: selectedDate)
        if requiredDayOfWeek == inputDateDayOfWeek {
            return selectedDate
        }
        
        var usedDayOfWeek = requiredDayOfWeek
        if usedDayOfWeek == 1 || usedDayOfWeek == 2 {
            usedDayOfWeek += 7
        }
        
        let diff = requiredDayOfWeek - inputDateDayOfWeek
        let result = addDaysToDate(daysToAdd: diff,
                                   toDate: selectedDate)
        return result
    }
    
    
    func addDaysToDate(daysToAdd: Int, toDate: Date) -> Date {
        var addedDays = DateComponents()
        addedDays.day = daysToAdd
        if let displayedMondayDate = Calendar.current.date(byAdding: addedDays,
                                                           to: toDate) {
            return displayedMondayDate
        }
        else {
            return toDate
        }
    }
    
    var displayedDateString: String {
        get {
            let longDateFormatter = DateFormatter()
            longDateFormatter.dateFormat = "EEEE, d MMMM yyyy"
            return longDateFormatter.string(from: displayedDate)
            
        }
    }
    
}

