//
//  Days.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 04/02/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import Foundation

class Days {
    static func getDay(dayOfWeekNumber: Int) -> String {
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
}
