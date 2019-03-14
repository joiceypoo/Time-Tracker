//
//  UsedDates.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 30/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

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
    var currentDate = Date()
    var selectedWeekday = String()
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
        startComponents.year = 2001
        startComponents.month = 1
        startComponents.day = 1
        startComponents.timeZone = TimeZone(abbreviation: currentTimeZone)
        
        let res = Calendar.current.date(from: startComponents) ?? Date()
        
        return res
        
    }
    
    var endDate: Date {
        var startComponents = DateComponents()
        startComponents.year = 2034
        startComponents.month = 12
        startComponents.day = 31
        startComponents.timeZone = TimeZone(abbreviation: currentTimeZone)
        return Calendar.current.date(from: startComponents) ?? Date()
    }
    
    func getDayOfWeekLetterFromDayOfWeekNumber(dayOfWeekNumber: Int) -> String {
        switch dayOfWeekNumber {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return "Sun"
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
            longDateFormatter.dateFormat = "MMMM"
            return longDateFormatter.string(from: displayedDate)
        }
    }
    
    var currentTimeZone: String {
        return TimeZone.current.abbreviation() ?? "PST"
    }
}

