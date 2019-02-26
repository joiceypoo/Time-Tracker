//
//  AddHabitView.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 16/02/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

protocol AddHabitViewDelegate {
    func didAddHabit(todo: TodoItem)
    func didEditHabit(todo: TodoItem?)
    func didDeleteHabit(todo: TodoItem?)
    func didDismissView()
    func showTextInputArea()
}

public class AddHabitView: UIView {
    
    var categories: [Category] = []
    var delegate: AddHabitViewDelegate?
    var categoriesPlaceholder: [Category] = []
    var weekdays = [WeekdaysEnum.sunday.rawValue,
                    WeekdaysEnum.monday.rawValue,
                    WeekdaysEnum.tuesday.rawValue,
                    WeekdaysEnum.wednesday.rawValue,
                    WeekdaysEnum.thursday.rawValue,
                    WeekdaysEnum.friday.rawValue,
                    WeekdaysEnum.saturday.rawValue]
    var weekdayButtons: [UIButton]? = []
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoriesTable: UITableView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var completedCountLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var habitTitleTextField: UITextField!
    @IBOutlet weak var lineSeparator: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var weekdaysStackView: UIStackView!
    

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var viewModel: AddHabitViewModel? {
        didSet { bindViewModel() }
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        if viewModel.todo == nil {
            completedCountLabel.isHidden = true
            deleteButton.isHidden = true
            lineSeparator.isHidden = true
            categories = viewModel.categories
            categoriesPlaceholder = viewModel.categories
            categories = categories.filter { $0.name != "None" }
        } else {
            let data = viewModel.todo?.repeatTodos?.weekday
            let dateStringsData = viewModel.todo?.isDone
            let completionDateStrings = Unarchive.unarchiveStringArrayData(from: dateStringsData)
            let count = completionDateStrings.count
            let creationDate = viewModel.todo?.creationDate
            let attributedText = constructAttributedString(for: count, dateString: creationDate)
          
            categories = viewModel.categories
            categoriesPlaceholder = viewModel.categories
            categories = categories.filter { $0.name != "None" }
            categoryTextField.text = viewModel.todo?.categoryName == "None" ? "" : viewModel.todo?.categoryName
            completedCountLabel.attributedText = attributedText
            habitTitleTextField.text = viewModel.todo?.title
            notesTextView.text = viewModel.todo?.notes
            weekdays = Unarchive.unarchiveStringArrayData(from: data)
            
            let weekdaysPlaceholder = weekdays.map { transformDay(for: $0)}
            weekdayButtons?.forEach { button in
                if let title = button.titleLabel?.text, !weekdaysPlaceholder.contains(title) {
                    button.isSelected = false
                    button.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9725490196, alpha: 1)
                    button.setTitleColor(#colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1), for: .normal)
                }
            }
            
        }
    }
    
    private func constructAttributedString(for completionCount: Int, dateString: String?) -> NSMutableAttributedString?  {
        let currentTimeZone = UsedDates.shared.currentTimeZone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: currentTimeZone)
        
        let currentDateString = dateFormatter.string(from: Date())
        
        guard let dateString = dateString,
            let date = dateFormatter.date(from: dateString),
            let currentDate = dateFormatter.date(from: currentDateString)
            else { return nil }
        
        let differenceInDays = Calendar.current.dateComponents([.day], from: currentDate, to: date).day ?? 0
        let differenceInDaysString = " / \(differenceInDays + 1)"
        let completionCountString = "\(completionCount)"
        
        let attributedText = NSMutableAttributedString(string: completionCountString, attributes: [NSAttributedString.Key.foregroundColor : UIColor.customBlue])
        
        attributedText.append(NSMutableAttributedString(string: differenceInDaysString, attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)]))
        return attributedText
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        validateUsersInput()
        if viewModel?.todo == nil {
            guard let categoryName = categoryTextField.text?.capitalized.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            let filteredCategory = categoriesPlaceholder.filter { $0.name == categoryName}
            if filteredCategory.isEmpty {
                CoreDataManager.shared.createCategory(from: categoryName)
                createHabit()
            } else if !filteredCategory.isEmpty {
                createHabit()
            }
        } else {
           editHabitHandler()
        }
    }
    
    
    private func displayAlertMessage(with message: String, title: String) {
        let alertController = Alert.displayMessage(with: message,
                                                   title: title)
        self.window?.rootViewController?.present(alertController,
                                                 animated: true,
                                                 completion: nil)
    }
    
    private func validateUsersInput() {
        guard let habitTitle = habitTitleTextField.text else { return }
        
        if habitTitle.isEmpty || habitTitle.trimmingCharacters(in: .whitespaces).isEmpty {
            displayAlertMessage(with: "The habit name field should not be empty", title: "Empty field")
            
        } else if weekdays.isEmpty  {
            displayAlertMessage(with: "Please select a week day(s)", title: "Unselected weekday")
        }
    }
    
    
    private func createHabit() {
        
        guard let habitTitle = habitTitleTextField.text,
            !habitTitle.trimmingCharacters(in: .whitespaces).isEmpty,
            var categoryName = categoryTextField.text?.capitalized.trimmingCharacters(in: .whitespaces), !weekdays.isEmpty else { return }
        
        let calendar = Calendar.current
        let currentTimeZone = UsedDates.shared.currentTimeZone
        var dateComponent = DateComponents()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: currentTimeZone)
        
        let newWeekdays = dateFormatter.weekdaySymbols.filter { day in
            return weekdays.contains(day)
        }
        
        var currentDayIntegerValue = Int(Dates.getDateString(format: "d", date: Date())) ?? 0
        let month = Dates.getDateString(format: "MMMM", date: Date())
        let year = Int(Dates.getDateString(format: "yyyy", date: Date())) ?? 0
        let weekdayIntegerValue = Weekdays.getIntegerWeekDay(from: newWeekdays[0])
        let currentWeekdayIntegerValue = calendar.component(.weekday, from: Date())
        var diff = weekdayIntegerValue - currentWeekdayIntegerValue
        
        if diff < 0 {
            diff += 7
            currentDayIntegerValue = currentDayIntegerValue + diff
        } else {
            currentDayIntegerValue = currentDayIntegerValue + diff
        }
        
        
        dateComponent.day = currentDayIntegerValue
        dateComponent.month = dateFormatter.monthSymbols.index(of: month)! + 1
        dateComponent.year = year
        let date = calendar.date(from: dateComponent)
        
        
        let isRepeating = weekdays.count == 7 ? true : false
        let dateString = Dates.getDateString(format: "EEEE, MMMM d, yyyy", date: date!)
        
        if categoryName == "" {
            categoryName = "None"
        }
        
        let todo = CoreDataManager.shared.createTodo(todo: habitTitle,
                                                     repeatDays: weekdays,
                                                     categoryName: categoryName,
                                                     isRepeating: isRepeating,
                                                     creationDate: dateString,
                                                     notes: notesTextView.text)
        delegate?.didAddHabit(todo: todo)
        removeFromSuperview()
    }
    
    private func editHabitHandler() {
        
        guard let habitTitle = habitTitleTextField.text,
            !habitTitle.trimmingCharacters(in: .whitespaces).isEmpty,
            let categoryName = categoryTextField.text?.capitalized else { return }
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: weekdays,
                                                        requiringSecureCoding: false)
            viewModel?.todo?.categoryName = categoryName
            viewModel?.todo?.notes = notesTextView.text
            viewModel?.todo?.title = habitTitle
            viewModel?.todo?.repeatTodos?.weekday = data
            try context.save()
            let todo = viewModel?.todo
            delegate?.didEditHabit(todo: todo)
            removeFromSuperview()
        } catch let error {
            print("Failed to save data", error)
        }
    }
    
    @IBAction func weekdayButtonPressed(_ sender: UIButton) {
        let day = sender.titleLabel?.text ?? ""
        if sender.isSelected {
            sender.isSelected = false
            sender.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9725490196, alpha: 1)
            sender.setTitleColor(#colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1), for: .normal)
            removeItemFromWeekdays(for: day)
        } else {
            sender.isSelected = true
            sender.backgroundColor = UIColor.customBlue
            sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            addItemToWeekdays(from: day)
        }
        
    }
    
    var shouldShowCategories: Bool? {
        didSet {
            if let shouldShowCategories = shouldShowCategories, shouldShowCategories {
                categoriesTable.isHidden = false
            } else {
                categoriesTable.isHidden = true
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        delegate?.didDismissView()
    }
    
    private func addItemToWeekdays(from day: String) {
        let dayString = Weekdays.getWeekday(for: day)
        
        switch day {
        case "M":
           appendDay(from: dayString)
        case "T":
            appendDay(from: dayString)
        case "W":
            appendDay(from: dayString)
        case "TH":
            appendDay(from: dayString)
        case "F":
            appendDay(from: dayString)
        case "S":
            appendDay(from: dayString)
        default:
            appendDay(from: dayString)
        }
    }
    
    private func removeItemFromWeekdays(for day: String) {
        let dayString = Weekdays.getWeekday(for: day)
        switch day {
        case "M":
            removeDay(from: dayString)
        case "T":
            removeDay(from: dayString)
        case "W":
            removeDay(from: dayString)
        case "TH":
            removeDay(from: dayString)
        case "F":
            removeDay(from: dayString)
        case "S":
            removeDay(from: dayString)
        default:
            removeDay(from: dayString)
        }
    }
    
    private func transformDay(for day: String) -> String {
        switch day {
        case WeekdaysEnum.monday.rawValue:
            return "M"
        case WeekdaysEnum.tuesday.rawValue:
            return "T"
        case WeekdaysEnum.wednesday.rawValue:
            return "W"
        case WeekdaysEnum.thursday.rawValue:
            return "TH"
        case WeekdaysEnum.friday.rawValue:
            return "F"
        case WeekdaysEnum.saturday.rawValue:
            return "S"
        default:
            return "SU"
        }
    }
    
    private func appendDay(from day: String) {
        if !weekdays.contains(day) {
            weekdays.append(day)
        }
    }
    
    private func removeDay(from day: String) {
        if weekdays.contains(day), let index = weekdays.index(of: day) {
            weekdays.remove(at: index)
        }
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("AddHabitView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        categoriesTable.register(UITableViewCell.self, forCellReuseIdentifier: "CategoriesCell")
        categoriesTable.delegate = self
        categoriesTable.dataSource = self
        categoryTextField.delegate = self
        habitTitleTextField.delegate = self
        notesTextView.delegate = self
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        weekdayButtons = weekdaysStackView.arrangedSubviews as? [UIButton]
        guard let weekdayButtons = weekdayButtons  else { return }
        
        for button in weekdayButtons {
            button.backgroundColor = UIColor.customBlue
            button.isSelected = true
            button.tintColor = .clear
            button.layer.cornerRadius = button.frame.height / 2
            button.layer.masksToBounds = true
        }
        categoriesTable.tableFooterView = UIView()
        shouldShowCategories = false
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let todo = viewModel?.todo
        delegate?.didDeleteHabit(todo: todo)
        removeFromSuperview()
    }
}
