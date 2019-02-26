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
    var displayHabitView = false
    var feedbackGenerator : UISelectionFeedbackGenerator? = nil
    var isNoteTextViewTapped: Bool?
    var isTextInputAreaTapped: Bool?
    private var lastContentOffSet: CGFloat = 0
    var selectedCellIndexPath: [IndexPath] = []
    var todos: [(key: String, value: [TodoItem])] = []
    
    var categoryTextField: UITextField?
    var noteTextView: UITextView?

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var todoListsTable: UITableView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    var displayedDayOfWeek: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObservers()
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
    
    var setMonthTitle: String? {
        didSet {
            guard let title = setMonthTitle else { return }
            navigationItem.title = title
            navigationController?.navigationBar.largeTitleTextAttributes
                = [NSAttributedString.Key.foregroundColor: UIColor.customBlue]
            navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
    
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
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navBarViewTapped))
        
        navigationBar.addGestureRecognizer(gestureRecognizer)
        
        let todayButton = UIButton()
        todayButton.addTarget(self, action: #selector(displayTodayDate),
                              for: .touchUpInside)
        todayButton.setImage(#imageLiteral(resourceName: "today"), for: .normal)
        navigationBar.addSubview(todayButton)
        todayButton.translatesAutoresizingMaskIntoConstraints = false
        todayButton.layer.cornerRadius = 4
        todayButton.layer.masksToBounds = true
        todayButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                           constant: -20).isActive = true
        todayButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                            constant: -15).isActive = true
        todayButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        todayButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        todoListsTable.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        todoListsTable.separatorColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
        todoListsTable.tableFooterView = UIView()
    }
    
    
    @objc func displayTodayDate() {
       scrollToDate(date: Date())
    }
    
    @objc private func navBarViewTapped() {
        if let view = view.viewWithTag(1), view == addHabitView {
            dismissViewHandler()
        }
    }
    
    func dismissViewHandler() {
        displayHabitView = false
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            self.addHabitView?.center.y += self.view.bounds.height + 100
        }) { _ in
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.addHabitView?.removeFromSuperview()
        }
    }
    
    @IBAction private func addTodoItemButtonPressed(_ sender: AddButton) {
        displayHabitView.toggle()
        setupAddHabitView(for: nil)
    }
    
    internal func setupAddHabitView(for habit: TodoItem?) {
        addHabitView = AddHabitView(frame: view.frame)
        guard let addHabitView = addHabitView else { return }
        addHabitView.viewModel = AddHabitViewModel(todo: habit, categories: getCategories)
        addHabitView.translatesAutoresizingMaskIntoConstraints = false
        addHabitView.delegate = self
        categoryTextField = addHabitView.categoryTextField
        noteTextView = addHabitView.notesTextView
        if displayHabitView {
            addHabitView.tag = 1
            view.addSubview(addHabitView)
            addHabitView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            addHabitView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            addHabitView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            addHabitView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                addHabitView.center.y -= self.view.bounds.height - 100
            }, completion: { _ in
                self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
            })
        } else {
            return
        }
    }
    
    public func deleteHandler(action: UITableViewRowAction, indexPath: IndexPath) {
        let section = indexPath.section
        let todo = todos[section].value[indexPath.row]
        todos[section].value.remove(at: indexPath.row)
        todoListsTable.deleteRows(at: [indexPath], with: .automatic)
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(todo)
        do {
            try context.save()
        } catch {
            print("Failed deletion: \(error)")
        }
    }
    
    public func editHandler(action: UITableViewRowAction, indexPath: IndexPath) {
        guard let editTodoController = EditTodoController.instantiate(from: .main)
            else { return }
        let navigationController = CustomNavigationController(rootViewController: editTodoController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func displayDate(date: Date) {
        UsedDates.shared.displayedDate = date
        UsedDates.shared.selectdDayOfWeek = Calendar.current.component(.weekday, from: date)
        setMonthTitle = UsedDates.shared.displayedDateString
        let dayString = Weekdays.getDay(dayOfWeekNumber: UsedDates.shared.selectdDayOfWeek)
        displayedDayOfWeek = dayString
        UsedDates.shared.currentDate = date
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
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func animateKeyboard(_ duration: TimeInterval, _ options: UIView.AnimationOptions) {
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: options,
                       animations: ({
                        self.view.layoutIfNeeded()
                       }))
    }
    
    @objc
    private func keyboardWillChange(notification: Notification) {
        guard
            let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let rawCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
            else { return }
        
        let options = UIView.AnimationOptions(rawValue: rawCurve << 16)
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {

            if let success = isTextInputAreaTapped, success == true {
                addHabitView?.frame.origin.y = -keyboardFrame.height + 170
                isTextInputAreaTapped = false
            }
            animateKeyboard(duration, options)
        } else {
            addHabitView?.frame.origin.y = 0
            animateKeyboard(duration, options)
            isTextInputAreaTapped = false
        }
    }
    
}




