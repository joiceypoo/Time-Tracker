//
//  ViewController.swift
//  Time-Tracker
//
//  Created by Joiceypoo 🎉 on 12/11/18.
//  Copyright © 2018 Team Sweet Cheeks. All rights reserved.
//

import UIKit
import CoreData

class TodoItemsController: UIViewController, Storyboarded {
    
    // MARK: Private Instance Properties

    private var addHabitView: AddHabitView?
    private var lastContentOffSet: CGFloat = 0
    private var selectedDay = String()
    private let addButton = UIButton()
    private let todayButton = UIButton()
    
    // MARK: Internal Instance Properties
    
    internal var activeSelectedDateIndexPath: IndexPath?
    internal var addHabitViewBottonConstraint: NSLayoutConstraint?
    internal var categories: [String] = []
    internal var currentIndexPath: IndexPath?
    internal var displayedDayOfWeek: String?
    internal var feedbackGenerator : UISelectionFeedbackGenerator? = nil
    internal var isTextInputAreaTapped: Bool?
    internal var selectedCellIndexPath: [IndexPath] = []
    internal var todos: [(key: String, value: [TodoItem])] = []
    

    // MARK: Internal IBOutlet's
    
    @IBOutlet internal weak var dateCollectionView: UICollectionView!
    @IBOutlet internal weak var todoListsTable: UITableView!
    @IBOutlet internal weak var rewardView: UIView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()
        let longPressedGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                        action: #selector(handleLongPress(recognizer:)))
        todoListsTable.addGestureRecognizer(longPressedGestureRecognizer)
        let day = Calendar.current.component(.weekday, from: Date())
        let weekday = Weekdays.getDay(dayOfWeekNumber: day)
        selectedDay = weekday
        setupView()
        fetchTodos(from: weekday)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.todoListsTable.indexPathForSelectedRow {
            self.todoListsTable.deselectRow(at: index, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        scrollToDate(date: Date())
    }
    
    private var monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.customBlue
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var monthLabelText: String? {
        didSet { setMonthLabel() }
    }
    
    private func setMonthLabel() {
        guard let monthLabelText = monthLabelText else { return }
        monthLabel.text = monthLabelText
    }
    
    private var getCategories: [Category] {
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
    
    @objc private func handleLongPress(recognizer: UILongPressGestureRecognizer) {
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
    
    private func setupAddButton() {
        addButton.layer.cornerRadius = 30
        addButton.setImage(UIImage(named: "add"), for: .normal)
        addButton.addTarget(self, action: #selector(addTodoItemButtonPressed), for: .touchUpInside)
        addButton.layer.shadowColor = #colorLiteral(red: 0, green: 0.05098039216, blue: 0.5137254902, alpha: 0.1634203767)
        addButton.layer.shadowRadius = 3
        addButton.layer.shadowOffset = CGSize(width: 2, height: 12)
        addButton.layer.shadowOpacity = 0.3
        
        view.addSubview(addButton)
        setAddButtonConstraints()
    }
    
    private func setAddButtonConstraints() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 7).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -26).isActive = true
    }
    
    private func setupView() {
        navigationController?.view.backgroundColor = .white
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.addSubview(monthLabel)
        monthLabel.leftAnchor.constraint(equalTo: navigationBar.leftAnchor,
                                         constant: 8).isActive = true
        monthLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        monthLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        monthLabel.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                           constant: -2).isActive = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(displayTodayDate))
        todayButton.addGestureRecognizer(tapGestureRecognizer)
        todayButton.setImage(#imageLiteral(resourceName: "today"), for: .normal)
        navigationBar.addSubview(todayButton)
        todayButton.translatesAutoresizingMaskIntoConstraints = false
        todayButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                           constant: -20).isActive = true
        todayButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        todayButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        todayButton.bottomAnchor.constraint(equalTo: monthLabel.bottomAnchor,
                                            constant: -2).isActive = true
        monthLabel.text = Dates.getDateString(format: "MMMM", date: Date())
        
        setupAddButton()
        
        todoListsTable.separatorInset = .zero
        todoListsTable.layoutMargins = .zero
        todoListsTable.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9725490196, alpha: 1)
        todoListsTable.separatorColor = #colorLiteral(red: 0.937254902, green: 0.9529411765, blue: 0.9568627451, alpha: 1)
        todoListsTable.tableFooterView = UIView()
    }
    
    
    @objc private func displayTodayDate() {
        let day = Calendar.current.component(.weekday, from: Date())
        let weekday = Weekdays.getDay(dayOfWeekNumber: day)
        selectedDay = weekday
        scrollToDate(date: Date())
        fetchTodos(from: weekday)
        if categories.count > 0 {
            todoListsTable.reloadData()
        }
    }
    
    internal func dismissViewHandler() {
        UIView.animate(withDuration: 0.28, delay: 0, options: .curveEaseIn, animations: {
            self.addHabitView?.center.y += self.view.bounds.height + 100
            self.navigationController?.removeBlurredBackgroundView()
        }, completion: { _ in
            self.addHabitView?.removeFromSuperview()
        })
    }
    
    @objc private func addTodoItemButtonPressed(_ sender: UIButton) {
        setupAddHabitView(for: nil)
    }
    
    internal func setupAddHabitView(for habit: TodoItem?) {
        let addHabitViewModel = AddHabitViewModel(todo: habit, categories: getCategories)
        addHabitView = AddHabitView(frame: view.frame)
        guard
            let addHabitView = addHabitView,
            let navigationBar = navigationController?.navigationBar
            else { return }

        addHabitView.viewModel = addHabitViewModel
        addHabitView.translatesAutoresizingMaskIntoConstraints = false
        addHabitView.delegate = self
        let currentWindow = UIApplication.shared.keyWindow
        currentWindow?.addSubview(addHabitView)
        addHabitView.topAnchor.constraint(equalTo: navigationBar.topAnchor).isActive = true
        addHabitView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        addHabitView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        addHabitViewBottonConstraint = addHabitView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        addHabitViewBottonConstraint?.isActive = true
        
        navigationController?.overlayBlurredBackgroundView()
        UIView.animate(withDuration: 0.28, delay: 0, options: .curveEaseIn, animations: {
            addHabitView.center.y -= self.view.bounds.height - 100
        }, completion: nil)
    }
 
    internal func deleteHandler(action: UITableViewRowAction, indexPath: IndexPath) {
        let section = indexPath.section
        let todo = todos[section].value[indexPath.row]
        
        if self.todos[section].value.count == 1 {
            let sectionIndexSet = IndexSet(integer: section)
            self.categories.remove(at: section)
            self.todos.remove(at: section)
            self.todoListsTable.deleteSections(sectionIndexSet, with: .automatic)
            self.todoListsTable.reloadData()
        } else {
            self.todos[section].value.remove(at: indexPath.row)
            self.todoListsTable.deleteRows(at: [indexPath], with: .automatic)
        }
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(todo)
        CoreDataManager.shared.recreateHabit(for: todo)
        do {
            try context.save()
        } catch {
            print("Failed deletion: \(error)")
        }
    }
    
    internal func displayDate(date: Date) {
        UsedDates.shared.displayedDate = date
        UsedDates.shared.currentDate = date
        UsedDates.shared.selectdDayOfWeek = Calendar.current.component(.weekday, from: date)
        monthLabelText = UsedDates.shared.displayedDateString
        let dayString = Weekdays.getDay(dayOfWeekNumber: UsedDates.shared.selectdDayOfWeek)
        selectedDay = dayString
        displayedDayOfWeek = dayString
    }
    
    internal func resetNavBar() {
        navigationController?.removeBlurredBackgroundView()
    }
    
    private func scrollToDate(date: Date) {
        let startDate = UsedDates.shared.startDate
        let cal = Calendar.current
        if let numberOfDays = cal.dateComponents([.day],
                                                 from: startDate,
                                                 to: date).day {
            let extraDays: Int = numberOfDays % 7
            let scrolledNumberOfDays = numberOfDays - extraDays
            let indexPath = IndexPath(row: scrolledNumberOfDays,
                                      section: 0)
            dateCollectionView.scrollToItem(at: indexPath,
                                            at: .left ,
                                            animated: false)
            
            for cell in dateCollectionView.visibleCells as! [DateCollectionViewCell]{
                if cell.contentView.backgroundColor == .customBlue {
                    cell.contentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9725490196, alpha: 1)
                    cell.dayOfMonthLabel.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
                    cell.dayOfWeekLabel.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
                }
            }
            
            if let activeSelectedDateIndexPath = activeSelectedDateIndexPath, let cell = dateCollectionView.cellForItem(at: activeSelectedDateIndexPath) as? DateCollectionViewCell {
                cell.dayOfMonthLabel.textColor = .customBlue
                cell.dayOfWeekLabel.textColor = .customBlue
            }
        }
        displayDate(date: date)
    }
    
    private func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if lastContentOffSet < scrollView.contentOffset.x,
            let displayedDayOfWeek = displayedDayOfWeek {
            let visibleCells = dateCollectionView.visibleCells as! [DateCollectionViewCell]
            for cell in visibleCells {
                if cell.dayOfWeekLabel.text == Weekdays.getShortWeekday(for: displayedDayOfWeek) {
                    UsedDates.shared.currentDate = cell.date
                }
            }
            displayWeek()
            fetchTodos(from: displayedDayOfWeek)
            if categories.count > 0 {
                todoListsTable.reloadData()
            }
        }
    }
    
    private func displayWeek() {
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
        let cell = visibleCells.first as! DateCollectionViewCell
        displayDate(date: UsedDates.shared.currentDate)
        monthLabelText = Dates.getDateString(format: "MMMM", date: cell.date)
    }
}



