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
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Repeat"
        view.backgroundColor = .customDarkBlack
        navigationController?.navigationBar.tintColor = .customOrange
        scheduleTable.separatorColor = .customLightGray
    }
    
    let schedules = [ScheduleEnum.sunday.rawValue,
                     ScheduleEnum.monday.rawValue,
                     ScheduleEnum.tuesday.rawValue,
                     ScheduleEnum.wednesday.rawValue,
                     ScheduleEnum.thursday.rawValue,
                     ScheduleEnum.friday.rawValue,
                     ScheduleEnum.saturday.rawValue
    ]
}
