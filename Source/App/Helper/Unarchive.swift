//
//  Unarchive.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 02/02/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import Foundation

public class Unarchive {
    static func unarchiveDaysData(from data: Data?) -> String {
        guard let newData = data else { return "" }
        let stringArray = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(newData) as! [String]
        return stringArray.count == 7 ? "Weekdays": stringArray.joined(separator: " ")
    }
    
    static func unarchiveStringArrayData(from data: Data?) -> [String] {
        guard let newData = data else { return [] }
        let stringArray = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(newData) as! [String]
        return stringArray
    }
    
    static func unarchiveDictionaryArray(from data: Data?) -> [String: Int] {
        guard let newData = data else { return [:] }
        let dictArray = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(newData) as! [String: Int]
        return dictArray
    }
}
