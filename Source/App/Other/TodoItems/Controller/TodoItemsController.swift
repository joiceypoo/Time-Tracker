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
    var selectedDay = String()
    var todos: [(key: String, value: [TodoItem])] = []
    
    let addButton = UIButton()
    let todayButton = UIButton()

    @IBOutlet weak var todoListsTable: UITableView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    var displayedDayOfWeek: String?
    
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
    
    private func setupAddButton() {
        addButton.layer.cornerRadius = 30
        addButton.setImage(UIImage(named: "addIcon"), for: .normal)
        addButton.addTarget(self, action: #selector(addTodoItemButtonPressed), for: .touchUpInside)
        addButton.layer.shadowColor = #colorLiteral(red: 0, green: 0.05098039216, blue: 0.5137254902, alpha: 0.1634203767)
        addButton.layer.shadowRadius = 3
        addButton.layer.shadowOffset = CGSize(width: 2, height: 12)
        addButton.layer.shadowOpacity = 0.3
        addButton.layer.shouldRasterize = true
        
        view.addSubview(addButton)
        setAddButtonConstraints()
    }
    
    func setAddButtonConstraints() {
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
        
        setupAddButton()
        
        todoListsTable.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        todoListsTable.separatorColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
        todoListsTable.tableFooterView = UIView()
    }
    
    
    @objc func displayTodayDate() {
        let day = Calendar.current.component(.weekday, from: Date())
        let weekday = Weekdays.getDay(dayOfWeekNumber: day)
        selectedDay = weekday
        scrollToDate(date: Date())
        fetchTodos(from: weekday)
        if categories.count > 0 {
            todoListsTable.reloadData()
        }
    }
    
    func dismissViewHandler() {
        displayHabitView = false
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            self.addHabitView?.center.y += self.view.bounds.height + 100
            self.navigationController?.removeBlurredBackgroundView()
        }, completion: { _ in
            self.addHabitView?.removeFromSuperview()
        })
    }
    
    @objc private func addTodoItemButtonPressed(_ sender: UIButton) {
        displayHabitView.toggle()
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
        if displayHabitView {
            let currentWindow = UIApplication.shared.keyWindow
            currentWindow?.addSubview(addHabitView)
            addHabitView.topAnchor.constraint(equalTo: navigationBar.topAnchor).isActive = true
            addHabitView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            addHabitView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            addHabitView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
     
            navigationController?.overlayBlurredBackgroundView()
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
                addHabitView.center.y -= self.view.bounds.height - 100
            }, completion: nil)
        } else {
            return
        }
    }
 
    internal func deleteHandler(action: UITableViewRowAction, indexPath: IndexPath) {
        let section = indexPath.section
        let todo = todos[section].value[indexPath.row]
        let alertController = UIAlertController(title: "Delete habit",
                                                message: "Are you sure you want to delete this habit?", preferredStyle: .alert)
        present(alertController, animated: true,
                completion: nil)
        
        alertController.addAction(UIAlertAction(title: "Yes",
                                                style: .default,
                                                handler: { _ in
            if self.todos[section].value.count == 1 {
                let sectionIndexSet = IndexSet(integer: section)
                self.categories.remove(at: section)
                self.todos.remove(at: section)
                self.todoListsTable.deleteSections(sectionIndexSet, with: .automatic)
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
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel,
                                                handler: nil))
    }
    
//    internal func deleteAllHabitsHandler(action: UITableViewRowAction, indexPath: IndexPath) {
//        let section = indexPath.section
//        let todo = todos[section].value[indexPath.row]
//        let alertController = UIAlertController(title: "Delete All habits",
//                                                message: "Are you sure you want to delete all repeating habits?", preferredStyle: .alert)
//        present(alertController, animated: true,
//                completion: nil)
//        
//        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
//            if self.todos[section].value.count == 1 {
//                let sectionIndexSet = IndexSet(integer: section)
//                self.categories.remove(at: section)
//                self.todos.remove(at: section)
//                self.todoListsTable.deleteSections(sectionIndexSet, with: .automatic)
//            } else {
//                self.todos[section].value.remove(at: indexPath.row)
//                self.todoListsTable.deleteRows(at: [indexPath], with: .automatic)
//            }
//            let context = CoreDataManager.shared.persistentContainer.viewContext
//            context.delete(todo)
//            do {
//                try context.save()
//            } catch {
//                print("Failed deletion: \(error)")
//            }
//        }))
//        
//        alertController.addAction(UIAlertAction(title: "Cancel",
//                                                style: .cancel,
//                                                handler: nil))
//        
//    }
    
    func displayDate(date: Date) {
        UsedDates.shared.displayedDate = date
        UsedDates.shared.selectdDayOfWeek = Calendar.current.component(.weekday, from: date)
        monthLabel.text = UsedDates.shared.displayedDateString
        let dayString = Weekdays.getDay(dayOfWeekNumber: UsedDates.shared.selectdDayOfWeek)
        selectedDay = dayString
        displayedDayOfWeek = dayString
        UsedDates.shared.currentDate = date
    }
    
    func resetNavBar() {
        displayHabitView = false
        navigationController?.removeBlurredBackgroundView()
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
        if lastContentOffSet < scrollView.contentOffset.x,
            let displayedDayOfWeek = displayedDayOfWeek {
            displayWeek()
            fetchTodos(from: displayedDayOfWeek)
            if categories.count > 0 {
                todoListsTable.reloadData()
            }
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
}




