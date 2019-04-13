//
//  TodoListCell.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit
import Foundation

protocol TodoListCellDelegate {
    func showRewardView(for doneDate: Date)
}

public class TodoListCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    var delegate: TodoListCellDelegate?
    let calendar = Calendar.current
    
    var viewModel: TodoItem? {
        didSet { bindViewModel() }
    }
    
    private func getDaysString(from data: Data?) -> [String] {
        let daysArray = Unarchive.unarchiveStringArrayData(from: data)
        var newDaysArray: [String] = []
        for day in calendar.weekdaySymbols {
            if daysArray.contains(day) {
                let shortWeekday = Weekdays.getShortWeekday(for: day)
                newDaysArray.append(shortWeekday)
            }
        }
        return newDaysArray
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        let data = viewModel.repeatTodos?.weekday
        let daysArray = getDaysString(from: data)
        let daysString = daysArray.joined(separator: " ")
        
        let currentDate = UsedDates.shared.currentDate
        let dateString = Dates.getDateString(format: "EEEE, d MMMM yyyy",
                                                    date: currentDate)
        
        let datesArray = Unarchive.unarchiveStringArrayData(from: viewModel.doneDateData)
        if datesArray.contains(dateString) {
            checkBox.setImage(#imageLiteral(resourceName: "Checked"), for: .normal)
        } else {
            checkBox.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
        
        if daysArray.count == 7 {
            detailTextLabel?.text = "Weekdays"
        } else {
            detailTextLabel?.text = daysString
        }
        
        textLabel?.text = viewModel.title
    }
    
    private lazy var checkBox: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        let image = #imageLiteral(resourceName: "unchecked")
        button.layer.cornerRadius = button.frame.width / 2
        button.layer.masksToBounds = true
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(checkboxPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    @objc private func checkboxPressed(sender: UIButton) {
        let impact = UIImpactFeedbackGenerator(style: .light)
        let currentDate = UsedDates.shared.displayedDate
        if sender.currentImage == #imageLiteral(resourceName: "unchecked") {
            sender.setImage(#imageLiteral(resourceName: "Checked"), for: .normal)
            sender.animateButton()
            impact.impactOccurred()
            updateDateRecord(from: currentDate)
            handleCheckedItem(for: currentDate, isChecked: true)
            delegate?.showRewardView(for: currentDate)
        } else if sender.currentImage == #imageLiteral(resourceName: "Checked") {
            sender.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            updateDateRecord(from: currentDate)
            handleCheckedItem(for: currentDate, isChecked: false)
        }
    }
    
    private func setupView() {
        detailTextLabel?.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textLabel?.textColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1843137255, alpha: 1)
        textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        accessoryView = checkBox
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        selectionStyle = .none
        selectedBackgroundView = view
    }
    
    private func updateDateRecord(from date: Date) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        guard let todo = viewModel else { return }
        do {
            var datesArray = Unarchive.unarchiveStringArrayData(from: todo.doneDateData)
            let dateString = Dates.getDateString(format: "EEEE, d MMMM yyyy",
                                                               date: date)
            if !datesArray.contains(dateString) {
                datesArray.append(dateString)
            } else if let currentIndex = datesArray.index(of: dateString) {
                datesArray.remove(at: currentIndex)
            }
            
            let doneDateData = try NSKeyedArchiver.archivedData(withRootObject: datesArray,
                                                        requiringSecureCoding: false)
            todo.doneDateData = doneDateData
            try context.save()
        } catch let error {
            print("Failed to archive data", error )
        }
    }
    
    private func handleCheckedItem(for date: Date, isChecked: Bool) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
         guard let todo = viewModel else { return }
        do {
            var checkedItems = Unarchive.unarchiveDictionaryArray(from: todo.checkedItems)
            let dateString = Dates.getDateString(format: "EEEE, d MMMM yyyy",
                                                        date: date)
            if isChecked {
                checkedItems[dateString] = 1
            } else if let value = checkedItems[dateString] {
                checkedItems[dateString] = value - 1
            }
            
            let checkedItemsData = try NSKeyedArchiver.archivedData(withRootObject: checkedItems,
                                                                    requiringSecureCoding: false)
            todo.checkedItems = checkedItemsData
            try context.save()
        } catch let error {
            print("Failed to archive data", error )
        }
    }
}
