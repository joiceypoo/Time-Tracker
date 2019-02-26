//
//  TodoListCell.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit
import Foundation

public class TodoListCell: UITableViewCell {
    
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    var viewModel: TodoItem? {
        didSet { bindViewModel() }
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        let data = viewModel.repeatTodos?.weekday
        
        var daysArray = Unarchive.unarchiveStringArrayData(from: data)
        daysArray = daysArray.map { day in
            return Weekdays.getShortWeekday(for: day)
        }
        
        let daysString = daysArray.joined(separator: " ")
        
        let currentDate = UsedDates.shared.currentDate
        let dateString = Dates.getDateString(format: "EEEE, d MMMM yyyy",
                                                    date: currentDate)
        
        let datesArray = Unarchive.unarchiveStringArrayData(from: viewModel.isDone)
        if datesArray.contains(dateString) {
            checkBox.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
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
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let image = #imageLiteral(resourceName: "unchecked")
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(checkboxPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    @objc private func checkboxPressed(sender: UIButton) {
        let impact = UIImpactFeedbackGenerator(style: .light)
        let currentDate = UsedDates.shared.displayedDate
        if sender.currentImage == #imageLiteral(resourceName: "unchecked") {
            sender.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            updateDateRecord(from: currentDate)
            impact.impactOccurred()
        } else if sender.currentImage == #imageLiteral(resourceName: "checked") {
            sender.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            updateDateRecord(from: currentDate)
        }
    }
    
    private func setupView() {
        detailTextLabel?.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textLabel?.textColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1843137255, alpha: 1)
        textLabel?.font = UIFont.systemFont(ofSize: 16)
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
            var datesArray = Unarchive.unarchiveStringArrayData(from: todo.isDone)
            let currentDateString = Dates.getDateString(format: "EEEE, d MMMM yyyy",
                                                               date: date)
            if !datesArray.contains(currentDateString) {
                datesArray.append(currentDateString)
                
            } else if let currentIndex = datesArray.index(of: currentDateString) {
                datesArray.remove(at: currentIndex)
            }
            let data = try NSKeyedArchiver.archivedData(withRootObject: datesArray,
                                                        requiringSecureCoding: false)
            todo.isDone = data
            try context.save()
        } catch let error {
            print("Failed to archive data", error )
        }

    }
    
}
