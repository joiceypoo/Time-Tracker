//
//  DatesString.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 06/02/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import Foundation

class Dates {
    static func getDateString(format: String, date: Date) -> String {
        let longDateFormatter = DateFormatter()
        longDateFormatter.dateFormat = format
        let dateString = longDateFormatter.string(from: date)
        return dateString
    }
    
    static func getDateFromString(dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: dateString)
        return date
    }
}
