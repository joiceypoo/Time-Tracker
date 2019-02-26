//
//  Weekdays.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 19/02/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import Foundation

class Weekdays {
    class func getWeekday(for day: String) -> String {
        switch day {
        case "M":
            return "Monday"
        case "T":
            return "Tuesday"
        case "W":
            return "Wednesday"
        case "TH":
            return "Thursday"
        case "F":
            return "Friday"
        case "S":
            return "Saturday"
        default:
            return "Sunday"
        }
    }
    
    class func getShortWeekday(for day: String) -> String {
        switch day {
        case "Monday":
            return "Mon"
        case "Tuesday":
            return "Tue"
        case "Wednesday":
            return "Wed"
        case "Thursday":
            return "Thu"
        case "Friday":
            return "Fri"
        case "Saturday":
            return "Sat"
        default:
            return "Sun"
        }
    }
    
    class func getIntegerWeekDay(from: String) -> Int {
        switch from {
        case "Sunday":
            return 1
        case "Monday":
            return 2
        case "Tuesday":
            return 3
        case "Wednesday":
            return 4
        case "Thursday":
            return 5
        case "Friday":
            return 6
        default:
            return 0
        }
    }
    
    class func getDay(dayOfWeekNumber: Int) -> String {
        switch dayOfWeekNumber {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return "Sunday"
        }
    }
}
