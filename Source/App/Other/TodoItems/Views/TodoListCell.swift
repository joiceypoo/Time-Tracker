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
        let weekdays = viewModel.repeatTodos?.weekday
        let days = Unarchive.unarchiveDaysData(from: weekdays)
        let currentDate = UsedDates.shared.currentDate
        let dateString = DatesString.getDatesString(format: "EEEE, d MMMM yyyy", date: currentDate)
        let datesArray = Unarchive.unarchiveStringArrayData(from: viewModel.isDone)
        if datesArray.contains(dateString) {
            checkBox.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        } else {
            checkBox.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
        textLabel?.text = viewModel.title
        detailTextLabel?.text = days
    }
    
    private lazy var checkBox: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let image = #imageLiteral(resourceName: "unchecked")
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.customLightGray.cgColor
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
        detailTextLabel?.textColor = .customLightGray
        detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        backgroundColor = .customBlack
        textLabel?.textColor = .white
        textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        accessoryView = checkBox
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        selectedBackgroundView = view
    }
    
    private func updateDateRecord(from date: Date) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        guard let todo = viewModel else { return }
        do {
            var datesArray = Unarchive.unarchiveStringArrayData(from: todo.isDone)
            let currentDateString = DatesString.getDatesString(format: "EEEE, d MMMM yyyy",
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
