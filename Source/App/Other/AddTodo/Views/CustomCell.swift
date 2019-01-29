//
//  CustomAddTodoCell.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
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
    
    var viewModel: DescriptionVM? {
        didSet {
            bindViewModel()
        }
    }
    
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
    
    private func bindViewModel() {
        guard let descriptionText = viewModel
            else { return }
        if descriptionText.title == "Repeat" {
            accessoryType = .disclosureIndicator
            detailText = descriptionText.details
        }
        detailTextLabel?.text = descriptionText.details
        textLabel?.text = descriptionText.title
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
                                               selector: #selector(updateRepeatLabel(notification:)),
                                               name: .weekDays,
                                               object: nil)
    }
    
    @objc private func updateRepeatLabel(notification: Notification) {
        if detailText.isEmpty == false,
            let userInfo = notification.userInfo as? [String: [String]],
            let weekdays = userInfo["weekDays"] {
            for weekday in weekDays {
                if weekdays.contains(weekday) {
                    days.append(weekday)
                }
            }
            
            self.detailTextLabel?.text = days.count == 7 ? "Every day": days.joined(separator: " ")
            days = []
        }
    }
}
