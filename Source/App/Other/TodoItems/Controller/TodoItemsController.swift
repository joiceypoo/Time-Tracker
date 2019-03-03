//
//  ViewController.swift
//  Time-Tracker
//
//  Created by Joiceypoo 🎉 on 12/11/18.
//  Copyright © 2018 Team Sweet Cheeks. All rights reserved.
//

import UIKit
import CoreData

class TodoItemsController: UIViewController {
    
    var addHabitView: AddHabitView?
    var categories: [String] = []
    var currentIndexPath: IndexPath?
    let customView = UIView()
    var displayHabitView = false
    var feedbackGenerator : UISelectionFeedbackGenerator? = nil
    var isNoteTextViewTapped: Bool?
    var isTextInputAreaTapped: Bool?
    private var lastContentOffSet: CGFloat = 0
    var selectedCellIndexPath: [IndexPath] = []
    var todos: [(key: String, value: [TodoItem])] = []
    let todayButton = UIButton()
    
    var categoryTextField: UITextField?
    var noteTextView: UITextView?

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var todoListsTable: UITableView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    var displayedDayOfWeek: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
//        setupKeyboardObservers()
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()
        let longPressedGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                        action: #selector(handleLongPress(recognizer:)))
        todoListsTable.addGestureRecognizer(longPressedGestureRecognizer)
        let day = Calendar.current.component(.weekday, from: Date())
        let weekday = Weekdays.getDay(dayOfWeekNumber: day)
        setupView()
        fetchTodos(from: weekday)
    }
    
    @objc func calenderIcon() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.todoListsTable.indexPathForSelectedRow {
            self.todoListsTable.deselectRow(at: index, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        let date = Date()
        scrollToDate(date: date)
        
    }
    
    var monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.137254902, green: 0.431372549, blue: 1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var getCategories: [Category] {
        return CoreDataManager.shared.fetchCategories()
    }
    
    internal func fetchTodos(from day: String) {
        todos = CoreDataManager.shared.fetchAllTodos(for: day)
        var newCategories : [String] = []
        for tuple in todos {
            newCategories.append(tuple.key)
        }
        categories = newCategories
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        let state = recognizer.state
        let locationInView = recognizer.location(in: todoListsTable)
        let indexPath = todoListsTable.indexPathForRow(at: locationInView)
        switch state {
        case .began:
            gestureBeganHandler(indexPath, locationInView)
        case .changed:
            gestureChangedHandler(locationInView, indexPath)
        default:
            handleDefault()
        }
    }
    
    private func setupView() {
        navigationController?.view.backgroundColor = .white
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.backgroundColor = .white
        navigationBar.addSubview(customView)
        
        customView.leftAnchor.constraint(equalTo: navigationBar.leftAnchor).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        customView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor).isActive = true
        customView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        customView.widthAnchor.constraint(equalTo: navigationBar.widthAnchor).isActive = true
        
        navigationBar.addSubview(monthLabel)
        monthLabel.leftAnchor.constraint(equalTo: navigationBar.leftAnchor, constant: 20).isActive = true
        monthLabel.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 80).isActive = true
        monthLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        monthLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        todayButton.addTarget(self, action: #selector(displayTodayDate),
                              for: .touchUpInside)
        todayButton.setImage(#imageLiteral(resourceName: "today"), for: .normal)
        navigationBar.addSubview(todayButton)
        todayButton.translatesAutoresizingMaskIntoConstraints = false
        todayButton.layer.cornerRadius = 4
        todayButton.layer.masksToBounds = true
        
        todayButton.topAnchor.constraint(equalTo: monthLabel.topAnchor).isActive = true
        todayButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                           constant: -20).isActive = true
        todayButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        todayButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        monthLabel.text = Dates.getDateString(format: "MMMM", date: Date())
        
        
        todoListsTable.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        todoListsTable.separatorColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
        todoListsTable.tableFooterView = UIView()
    }
    
    
    @objc func displayTodayDate() {
        let day = Calendar.current.component(.weekday, from: Date())
        let weekday = Weekdays.getDay(dayOfWeekNumber: day)
        scrollToDate(date: Date())
        fetchTodos(from: weekday)
        todoListsTable.reloadData()
    }
    
    func dismissViewHandler() {
        displayHabitView = false
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            self.addHabitView?.center.y += self.view.bounds.height + 100
        }) { _ in
            self.customView.backgroundColor = .white
            self.navigationController?.view.backgroundColor = .white
            self.addHabitView?.removeFromSuperview()
        }
    }
    
    @IBAction private func addTodoItemButtonPressed(_ sender: AddButton) {
        displayHabitView.toggle()
        setupAddHabitView(for: nil)
    }
    
    internal func setupAddHabitView(for habit: TodoItem?) {
        let addHabitViewModel = AddHabitViewModel(todo: habit, categories: getCategories)
        addHabitView = AddHabitView(frame: view.frame, viewModel: addHabitViewModel)
        guard
            let addHabitView = addHabitView,
            let navigationBar = navigationController?.navigationBar
            else { return }
        
        addHabitView.translatesAutoresizingMaskIntoConstraints = false
        addHabitView.delegate = self
        categoryTextField = addHabitView.categoryTextField
        noteTextView = addHabitView.notesTextView
        if displayHabitView {
            let currentWindow = UIApplication.shared.keyWindow
            currentWindow?.addSubview(addHabitView)
            addHabitView.topAnchor.constraint(equalTo: navigationBar.topAnchor).isActive = true
            addHabitView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            addHabitView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            addHabitView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                addHabitView.center.y -= self.view.bounds.height - 100
            }, completion: { _ in
                self.customView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
                self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
            })
        } else {
            return
        }
    }
    
    public func deleteHandler(action: UITableViewRowAction, indexPath: IndexPath) {
        let section = indexPath.section
        let todo = todos[section].value[indexPath.row]
        if todos[section].value.count == 1 {
            let sectionIndexSet = IndexSet(integer: section)
            categories.remove(at: section)
            todos.remove(at: section)
            todoListsTable.deleteSections(sectionIndexSet, with: .automatic)
        } else {
            todos[section].value.remove(at: indexPath.row)
            todoListsTable.deleteRows(at: [indexPath], with: .automatic)
        }
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(todo)
        do {
            try context.save()
        } catch {
            print("Failed deletion: \(error)")
        }
    }
    
    func displayDate(date: Date) {
        UsedDates.shared.displayedDate = date
        UsedDates.shared.selectdDayOfWeek = Calendar.current.component(.weekday, from: date)
        monthLabel.text = UsedDates.shared.displayedDateString
        let dayString = Weekdays.getDay(dayOfWeekNumber: UsedDates.shared.selectdDayOfWeek)
        displayedDayOfWeek = dayString
        UsedDates.shared.currentDate = date
    }
    
    func resetNavBar() {
        displayHabitView = false
        customView.backgroundColor = .white
        navigationController?.view.backgroundColor = .white
        todayButton.isEnabled = true
    }
    
    func scrollToDate(date: Date)
    {
        let startDate = UsedDates.shared.startDate
        let cal = Calendar.current
        if let numberOfDays = cal.dateComponents([.day],
                                                 from: startDate,
                                                 to: date).day {
            let extraDays: Int = numberOfDays % 7
            let scrolledNumberOfDays = numberOfDays - extraDays
            let firstMondayIndexPath = IndexPath(row: scrolledNumberOfDays,
                                                 section: 0)
            dateCollectionView.scrollToItem(at: firstMondayIndexPath,
                                            at: .left ,
                                            animated: false)
        }
        displayDate(date: date)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if lastContentOffSet > scrollView.contentOffset.x,
            let displayedDayOfWeek = displayedDayOfWeek {
            displayWeek()
            fetchTodos(from: displayedDayOfWeek)
            todoListsTable.reloadData()
        } else if lastContentOffSet < scrollView.contentOffset.x,
            let displayedDayOfWeek = displayedDayOfWeek {
            displayWeek()
            fetchTodos(from: displayedDayOfWeek)
            todoListsTable.reloadData()
        }
        
        
    }
    
    func displayWeek() {
        var visibleCells = dateCollectionView.visibleCells
        visibleCells.sort { (cell1: UICollectionViewCell, cell2: UICollectionViewCell) -> Bool in
            guard let cell1 = cell1 as? DateCollectionViewCell else {
                return false
            }
            guard let cell2 = cell2 as? DateCollectionViewCell else {
                return false
            }
            let result = cell1.date!.compare(cell2.date!)
            return result == ComparisonResult.orderedAscending
            
        }
        let middleIndex = visibleCells.count / 2
        let middleCell = visibleCells[middleIndex] as! DateCollectionViewCell
        let displayedDate = UsedDates.shared.getDateOfAnotherDayOfTheSameWeek(selectedDate: middleCell.date!,
                                                                              requiredDayOfWeek: UsedDates.shared.selectdDayOfWeek)
        displayDate(date: displayedDate)
    }
    
//    private func setupKeyboardObservers() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(keyboardWillChange),
//                                               name: UIResponder.keyboardWillShowNotification,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(keyboardWillChange),
//                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(keyboardWillChange),
//                                               name: UIResponder.keyboardWillHideNotification,
//                                               object: nil)
//    }
//
//    private func animateKeyboard(_ duration: TimeInterval, _ options: UIView.AnimationOptions) {
//        UIView.animate(withDuration: duration,
//                       delay: 0,
//                       options: options,
//                       animations: ({
//                        self.view.layoutIfNeeded()
//                       }))
//    }
//
//    @objc
//    private func keyboardWillChange(notification: Notification) {
//        guard
//            let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
//            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
//            let rawCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
//            else { return }
//
//        let options = UIView.AnimationOptions(rawValue: rawCurve << 16)
//
//        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
////            if let success = isTextInputAreaTapped, success == true {
////                addHabitView?.frame.origin.y = -keyboardFrame.height + 170
////                isTextInputAreaTapped = false
////            }
////            animateKeyboard(duration, options)
//        } else {
////            addHabitView?.frame.origin.y = 0
////            animateKeyboard(duration, options)
////            isTextInputAreaTapped = false
//        }
//    }
    
}




