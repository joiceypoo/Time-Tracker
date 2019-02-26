//
//  CustomCell.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 02/02/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        addObserver()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    var viewModel: EditViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    var delegate: CustomCellDelegate?
    let weekDays = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat"
    ]
    var detailText = ""
    var days: [String] = []
    var weekString: String?
    var completed: Int?
    var category: String?
    
    private func bindViewModel() {
        guard let viewM = viewModel
            else { return }
        let datesArray = Unarchive.unarchiveStringArrayData(from: viewM.todo.isDone)
        category = viewM.todo.categoryName
        let data = viewM.todo.repeatTodos?.weekday
        weekString = Unarchive.unarchiveDaysData(from: data)
        switch viewM.index {
        case 1:
            textLabel?.text = "Repeat"
            detailTextLabel?.text = weekString
            accessoryType = .disclosureIndicator
        case 2:
        textLabel?.text = "Completed"
        detailTextLabel?.text = "\(datesArray.count)"
        default:
            textLabel?.text = "Tag"
            detailTextLabel?.text = category
            accessoryType = .disclosureIndicator
        }
    }
    
    private func setupView() {
        backgroundColor = .customBlack
        textLabel?.textColor = .white
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        selectedBackgroundView = view
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateRepeat(notification:)),
                                               name: .weekDays,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCategory),
                                               name: .postCategory, object: nil)
    }
    
    @objc private func updateRepeat(notification: Notification) {
        if textLabel?.text == "Repeat",
            let userInfo = notification.userInfo as? [String: [String]],
            let weekdays = userInfo["weekDays"] {
            for weekday in weekDays {
                if weekdays.contains(weekday) {
                    days.append(weekday)
                }
            }
            delegate?.handleWeekdays(days: days)
            self.detailTextLabel?.text = days.count == 7 ? "Weekdays": days.joined(separator: " ")
            days = []
        }
    }
    
    @objc private func updateCategory(notification: Notification) {
        if let userInfo = notification.userInfo as? [String: String],
            let category = userInfo["postCategory"] {
            delegate?.postCategory(category: category)
            if textLabel?.text == "Tag" {
                detailTextLabel?.text = category
            }
        }
    }
}
