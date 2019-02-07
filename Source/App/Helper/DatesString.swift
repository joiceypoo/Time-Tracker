//
//  DatesString.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 06/02/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import Foundation

class DatesString {
    static func getDatesString(format: String, date: Date) -> String {
        let longDateFormatter = DateFormatter()
        longDateFormatter.dateFormat = format
        let dateString = longDateFormatter.string(from: date)
        return dateString
    }
}
