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
    func didEditHabit(todo: TodoItem?, categoryName: String)
    func didDeleteHabit(todo: TodoItem?)
    func didDismissView()
    func showTextInputArea()
}

public class AddHabitView: UIView {
    
    // MARK: Instance Properties
    
    let calendar = Calendar.current
    var categories: [Category] = []
    var categoriesPlaceholder: [Category] = []
    var delegate: AddHabitViewDelegate?
    var keyboardHeight: CGFloat = 0
    var originalYPosition: CGFloat = 0
    var weekdays = [WeekdaysEnum.sunday.rawValue,
                    WeekdaysEnum.monday.rawValue,
                    WeekdaysEnum.tuesday.rawValue,
                    WeekdaysEnum.wednesday.rawValue,
                    WeekdaysEnum.thursday.rawValue,
                    WeekdaysEnum.friday.rawValue,
                    WeekdaysEnum.saturday.rawValue]
    var weekdayButtons: [UIButton]? = []
    
    var shouldShowCategories: Bool? {
        didSet {
            if let shouldShowCategories = shouldShowCategories, shouldShowCategories {
                categoriesTable.isHidden = false
            } else {
                categoriesTable.isHidden = true
            }
        }
    }
    
    private var buttonWidth: CGFloat {
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            return 32
        } else {
            return 40
        }
    }
    
    let weekdaysStackView = UIStackView()
    
    // MARK: Outlets
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoriesTable: UITableView!
    @IBOutlet weak var completedCountLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var firstLineSeparator: UIView!
    @IBOutlet weak var habitTitleTextField: UITextField!
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var lineSeparator: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var notesTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var secondLineSeparator: UIView!
    
    // MARK: Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupKeyboardObservers()
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: ViewModel
    
    var viewModel: AddHabitViewModel? {
        didSet { bindViewModel() }
    }
    
    lazy var mondayButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.isSelected = true
        button.layer.cornerRadius = buttonWidth / 2
        button.backgroundColor = UIColor.customBlue
        button.setTitle("M", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(weekdayButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var tuesdayButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.isSelected = true
        button.layer.cornerRadius = buttonWidth / 2
        button.backgroundColor = UIColor.customBlue
        button.setTitle("T", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(weekdayButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var wednesdayButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.isSelected = true
        button.layer.cornerRadius = buttonWidth / 2
        button.backgroundColor = UIColor.customBlue
        button.setTitle("W", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(weekdayButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var thursdayButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.isSelected = true
        button.layer.cornerRadius = buttonWidth / 2
        button.backgroundColor = UIColor.customBlue
        button.setTitle("TH", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(weekdayButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var fridayButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.isSelected = true
        button.layer.cornerRadius = buttonWidth / 2
        button.backgroundColor = UIColor.customBlue
        button.setTitle("F", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(weekdayButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var saturdayButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.isSelected = true
        button.layer.cornerRadius = buttonWidth / 2
        button.backgroundColor = UIColor.customBlue
        button.setTitle("S", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(weekdayButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var sundayButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.isSelected = true
        button.layer.cornerRadius = buttonWidth / 2
        button.backgroundColor = UIColor.customBlue
        button.setTitle("SU", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(weekdayButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    
    func setupStackView() {
        weekdaysStackView.addArrangedSubview(mondayButton)
        weekdaysStackView.addArrangedSubview(tuesdayButton)
        weekdaysStackView.addArrangedSubview(wednesdayButton)
        weekdaysStackView.addArrangedSubview(thursdayButton)
        weekdaysStackView.addArrangedSubview(fridayButton)
        weekdaysStackView.addArrangedSubview(saturdayButton)
        weekdaysStackView.addArrangedSubview(sundayButton)
        
        weekdaysStackView.axis = NSLayoutConstraint.Axis.horizontal
        weekdaysStackView.distribution = UIStackView.Distribution.equalSpacing
        weekdaysStackView.alignment = UIStackView.Alignment.fill
        weekdaysStackView.spacing = 10
        
        contentView.addSubview(weekdaysStackView)
        setStackViewConstraints()
    }
    
    func setStackViewConstraints() {
        weekdaysStackView.translatesAutoresizingMaskIntoConstraints = false
        weekdaysStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15.5).isActive = true
        weekdaysStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15.5).isActive = true
        weekdaysStackView.topAnchor.constraint(equalTo: firstLineSeparator.bottomAnchor, constant: 20).isActive = true        
    }
    
    // MARK: Private Instance Methods
    
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
    
    private func appendDay(from day: String) {
        if !weekdays.contains(day) {
            weekdays.append(day)
        }
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        if viewModel.todo == nil {
            completedCountLabel.isHidden = true
            deleteButton.isHidden = true
            lineSeparator.isHidden = true
            categories = viewModel.categories
            categoriesPlaceholder = viewModel.categories
            categories = categories.filter { $0.name != "" }
        } else {
            let data = viewModel.todo?.repeatTodos?.weekday
            let dateStringsData = viewModel.todo?.isDone
            let completionDateStrings = Unarchive.unarchiveStringArrayData(from: dateStringsData)
            let count = completionDateStrings.count
            let creationDate = viewModel.todo?.creationDate
            
            weekdays = Unarchive.unarchiveStringArrayData(from: data)
            
            let attributedText = constructAttributedString(for: count, dateString: creationDate)
            cancelButton.isHidden = true
            categories = viewModel.categories
            categoriesPlaceholder = viewModel.categories
            categories = categories.filter { $0.name != "" }
            categoryTextField.text = viewModel.todo?.categoryName == "None" ? "" : viewModel.todo?.categoryName
            completedCountLabel.attributedText = attributedText
            habitTitleTextField.text = viewModel.todo?.title
            notesTextView.text = viewModel.todo?.notes
            saveButton.setTitle("Done", for: .normal)
            
            if notesTextView.text != "Add notes" {
                notesTextView.textColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1843137255, alpha: 1)
            }
            
            let textSize = estimateFrame(for: notesTextView.text)
            notesTextViewHeightConstraint.constant = textSize.height + 30
            
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
    
    @IBAction private func cancelButtonPressed(_ sender: UIButton) {
        delegate?.didDismissView()
    }
    
    private func constructAttributedString(for completionCount: Int, dateString: String?) -> NSMutableAttributedString?  {
        let currentTimeZone = UsedDates.shared.currentTimeZone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: currentTimeZone)
        
        var expectedCompletionCount = 0
        
        
        guard let dateString = dateString,
            var startDate = dateFormatter.date(from: dateString)
            else { return nil }
        
        let endDate = UsedDates.shared.currentDate
        
        while startDate.compare(endDate) != .orderedDescending {
            let weekday = calendar.weekdaySymbols[calendar.component(.weekday, from: startDate) - 1]
            if weekdays.contains(weekday) {
                expectedCompletionCount += 1
            }
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
            
        let completionCountString = "\(completionCount)"
        let expectedCompletionCountString = " / \(expectedCompletionCount)"
        
        let attributedText = NSMutableAttributedString(string: completionCountString, attributes: [NSAttributedString.Key.foregroundColor : UIColor.customBlue])
        
        attributedText.append(NSMutableAttributedString(string: expectedCompletionCountString, attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)]))
        return attributedText
    }
    
    private func createHabit() {
        
        guard let habitTitle = habitTitleTextField.text,
            !habitTitle.trimmingCharacters(in: .whitespaces).isEmpty,
            var categoryName = categoryTextField.text?.capitalized.trimmingCharacters(in: .whitespaces), !weekdays.isEmpty else { return }
        
        let currentTimeZone = UsedDates.shared.currentTimeZone
        var dateComponent = DateComponents()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: currentTimeZone)
        
        
        var currentDayIntegerValue = Int(Dates.getDateString(format: "d", date: Date())) ?? 0
        let month = Dates.getDateString(format: "MMMM", date: Date())
        let year = Int(Dates.getDateString(format: "yyyy", date: Date())) ?? 0
        let currentWeekdayInt = calendar.component(.weekday, from: Date())
        
        var newWeekdaysIntValue: [Int] = []
        let weekdaysIntValues = Weekdays.getWeekdayIntValue(for: weekdays)
        
        weekdaysIntValues.forEach { weekdayInt in
            var diff = weekdayInt - currentWeekdayInt
            if diff < 0 {
                diff += 7
                newWeekdaysIntValue.append(diff)
            } else {
                newWeekdaysIntValue.append(diff)
            }
        }
        
        guard
            let minValue = newWeekdaysIntValue.min(),
            let range = calendar.range(of: .day, in: .month, for: Date())
            else { return }
        
        var monthInt = dateFormatter.monthSymbols.index(of: month)! + 1
        let numDays = range.count
        currentDayIntegerValue += minValue
        
        if numDays == 31 && currentDayIntegerValue > 31 {
            currentDayIntegerValue -= 31
            monthInt += 1
        } else if numDays == 30 && currentDayIntegerValue > 30 {
            currentDayIntegerValue -= 30
            monthInt += 1
        } else if numDays == 29 && currentDayIntegerValue > 29 {
            currentDayIntegerValue -= 29
            monthInt += 1
        } else if numDays == 28 && currentDayIntegerValue > 28 {
            currentDayIntegerValue -= 28
            monthInt += 1
        }
        
        let components = calendar.dateComponents([.hour, .minute, .second], from: Date())
        dateComponent.day = currentDayIntegerValue
        dateComponent.month = monthInt
        dateComponent.year = year
        dateComponent.hour = components.hour
        dateComponent.minute = components.minute
        dateComponent.second = components.second
        dateComponent.timeZone = TimeZone(abbreviation: currentTimeZone)
        
        guard let startDate = calendar.date(from: dateComponent) else { return }
        
        let isRepeating = weekdays.count == 7 ? true : false
        let dateString = Dates.getDateString(format: "EEEE, MMMM d, yyyy", date: startDate)
        
        categoryName = categoryName.isEmpty ? "None": categoryName
        
        let todo = CoreDataManager.shared.createTodo(todo: habitTitle,
                                                     repeatDays: weekdays,
                                                     categoryName: categoryName,
                                                     isRepeating: isRepeating,
                                                     creationDate: dateString,
                                                     notes: notesTextView.text)
        removeFromSuperview()
        delegate?.didAddHabit(todo: todo)
    }
    
    @IBAction private func deleteButtonPressed(_ sender: UIButton) {
        let todo = viewModel?.todo
        let title = viewModel?.todo?.title ?? ""
        let alertController = UIAlertController(title: "Delete \(title)",
                                                message: "Are you sure you want to delete this habit? \n It'll delete this and all future occurrences.",
                                                preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes",
                                      style: .default,
                                      handler: { _ in
                                        self.delegate?.didDeleteHabit(todo: todo)
                                        self.removeFromSuperview()
        })
        
        
        alertController.addAction(yesAction)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        
        var currentWindow = self.window?.rootViewController
        
        while currentWindow?.presentedViewController != nil {
            currentWindow = currentWindow?.presentedViewController
        }
        
        currentWindow?.present(alertController, animated: true, completion: nil)
    }
    
    @objc func dismissView() {
        delegate?.didDismissView()
    }
    
    private func displayAlertMessage(with message: String, title: String) {
        let alertController = Alert.displayMessage(with: message,
                                                   title: title, actionTitle: "Ok")
        
        var currentWindow = self.window?.rootViewController
        
        while currentWindow?.presentedViewController != nil {
            currentWindow = currentWindow?.presentedViewController
        }
        
        currentWindow?.present(alertController, animated: true, completion: nil)
    }
    
    private func editHabitHandler() {
        
        guard let habitTitle = habitTitleTextField.text,
            !habitTitle.trimmingCharacters(in: .whitespaces).isEmpty,
            var categoryName = categoryTextField.text?.capitalized.trimmingCharacters(in: .whitespaces),
            let persistedCategoryName = viewModel?.todo?.categoryName else { return }
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: weekdays,
                                                        requiringSecureCoding: false)
            
            categoryName = categoryName.isEmpty ? "None": categoryName
            viewModel?.todo?.categoryName = categoryName
            viewModel?.todo?.notes = notesTextView.text
            viewModel?.todo?.title = habitTitle
            viewModel?.todo?.repeatTodos?.weekday = data
            let todo = viewModel?.todo
            try context.save()
            delegate?.didEditHabit(todo: todo, categoryName: persistedCategoryName)
            removeFromSuperview()
        } catch let error {
            print("Failed to save data", error)
        }
    }
    
    private func removeDay(from day: String) {
        if weekdays.contains(day), let index = weekdays.index(of: day) {
            weekdays.remove(at: index)
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
    
    @IBAction private func saveButtonPressed(_ sender: UIButton) {
        validateUsersInput()
        if viewModel?.todo == nil, let categoryName = categoryTextField.text?.capitalized.trimmingCharacters(in: .whitespacesAndNewlines) {
      
            let filteredCategory = categoriesPlaceholder.filter { $0.name == categoryName}
            if filteredCategory.isEmpty {
                CoreDataManager.shared.createCategory(from: categoryName)
                createHabit()
            } else if !filteredCategory.isEmpty {
                createHabit()
            }
        } else if let categoryName = categoryTextField.text?.capitalized.trimmingCharacters(in: .whitespacesAndNewlines) {
            let filteredCategory = categoriesPlaceholder.filter { $0.name == categoryName}
            if filteredCategory.isEmpty {
                CoreDataManager.shared.createCategory(from: categoryName)
                editHabitHandler()
            } else if !filteredCategory.isEmpty {
                editHabitHandler()
            }
        }
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("AddHabitView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(dismissView))
        gestureRecognizer.delegate = self
                self.addGestureRecognizer(gestureRecognizer)
        setupStackView()
        contentView.layer.cornerRadius = 4
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
        categoriesTable.tableFooterView = UIView()
        shouldShowCategories = false
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
    
    @objc private func weekdayButtonPressed(_ sender: UIButton) {
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
    
    private func validateUsersInput() {
        guard let habitTitle = habitTitleTextField.text else { return }
        
        if habitTitle.isEmpty || habitTitle.trimmingCharacters(in: .whitespaces).isEmpty {
            displayAlertMessage(with: "The name field for the habit should not be empty",
                                title: "Empty field")
            
        } else if weekdays.isEmpty  {
            displayAlertMessage(with: "Please select a week day(s)",
                                title: "Unselected weekday")
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyBoardInf = notification.userInfo else { return }
        
        if let keyboardSize = (keyBoardInf[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            keyboardHeight = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        keyboardHeight = 0
    }
    
    public func estimateFrame(for text: String) -> CGRect {
        let size = CGSize(width: frame.width - 16, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [.font: UIFont.systemFont(ofSize: 14)],
                                                   context: nil)
    }
}
