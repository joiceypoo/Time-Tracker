//
//  RepeatController.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 23/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

class RepeatController: UIViewController {
    
    @IBOutlet weak var scheduleTable: UITableView!
    private var weekDays: [String] = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat"
    ]
    
    let schedules = [WeekdaysEnum.sunday.rawValue,
                     WeekdaysEnum.monday.rawValue,
                     WeekdaysEnum.tuesday.rawValue,
                     WeekdaysEnum.wednesday.rawValue,
                     WeekdaysEnum.thursday.rawValue,
                     WeekdaysEnum.friday.rawValue,
                     WeekdaysEnum.saturday.rawValue
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Repeat"
        view.backgroundColor = .customDarkBlack
        navigationController?.navigationBar.tintColor = .customOrange
        scheduleTable.separatorColor = .customLightGray
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            NotificationCenter.default.post(name: .weekDays, object: nil, userInfo: ["weekDays": weekDays])
        }
    }
    
    internal func addItemToWeekDaysArray(item: String) {
        if weekDays.index(of: item) == nil {
            let index = item.index(item.startIndex, offsetBy: 2)
            weekDays.append(String(item[...index]))
        }
    }
    
    internal func removeItemFromWeekDaysArray(item: String) {
        let weekdayIndex = item.index(item.startIndex, offsetBy: 2)
        let weekday = String(item[...weekdayIndex])
        if let index = weekDays.index(of: weekday) {
            weekDays.remove(at: index)
        }
    }
    
}
