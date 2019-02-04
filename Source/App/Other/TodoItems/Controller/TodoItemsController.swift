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
    
    var todos: [(key: String, value: [TodoItem])] = []
    var categories: [String] = []
    private var lastContentOffSet: CGFloat = 0
    
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var todoListsTable: UITableView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    @IBOutlet weak var selectedDate: UILabel!
    
    let topBorder = CALayer()
    
    internal func fetchTodos(from day: String) {
        todos = CoreDataManager.shared.fetchAllTodos(for: day)
        var newCategories : [String] = []
        for tuple in todos {
            newCategories.append(tuple.key)
        }
        categories = newCategories
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "To do"
        let longPressedGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                        action: #selector(handleLongPress(recognizer:)))
        todoListsTable.addGestureRecognizer(longPressedGestureRecognizer)
        let day = Calendar.current.component(.weekday, from: Date())
        setupView()
        fetchTodos(from: UsedDates.shared.getDay(from: day))
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topBorder.frame = CGRect(x: 0, y: 1, width: calenderView.bounds.width, height: 0.3)
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
        topBorder.frame = CGRect(x: 0,
                                 y: 1,
                                 width: calenderView.bounds.width,
                                 height: 0.3)
        topBorder.backgroundColor = UIColor.customLightGray.cgColor
        calenderView.backgroundColor = .customBlack
        calenderView.layer.addSublayer(topBorder)
        
        todoListsTable.backgroundColor = .customDarkBlack
        todoListsTable.separatorColor = .customLightGray
        todoListsTable.tableFooterView = UIView()
    }
    
    @IBAction private func addTodoItemButtonPressed(_ sender: AddButton) {
        guard let addHabitController = AddHabitController.instantiate(from: .main)
            else { return }
        addHabitController.delegate = self
        let navController = CustomNavigationController(rootViewController: addHabitController)
        present(navController, animated: true, completion: nil)
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
    
    func displayDate(date: Date) -> String {
        UsedDates.shared.displayedDate = date
        UsedDates.shared.selectdDayOfWeek = Calendar.current.component(.weekday, from: date)
        self.selectedDate.text = UsedDates.shared.displayedDateString
        let dayString = UsedDates.shared.getDay(from: UsedDates.shared.selectdDayOfWeek)
        return dayString
    }
    
    func scrollToDate(date: Date)
    {
        let startDate = UsedDates.shared.startDate
        let cal = Calendar.current
        if let numberOfDays = cal.dateComponents([.day], from: startDate, to: date).day {
            let extraDays: Int = numberOfDays % 7 
            let scrolledNumberOfDays = numberOfDays - extraDays
            let firstMondayIndexPath = IndexPath(row: scrolledNumberOfDays, section: 0)
            dateCollectionView.scrollToItem(at: firstMondayIndexPath, at: .left , animated: false)
        }
        _ = displayDate(date: date)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if lastContentOffSet > scrollView.contentOffset.x {
            let dayString = displayWeek()
            fetchTodos(from: dayString)
            todoListsTable.reloadData()
        } else if lastContentOffSet < scrollView.contentOffset.x {
            let dayString = displayWeek()
            fetchTodos(from: dayString)
            todoListsTable.reloadData()
        }
    }
    
    func displayWeek() -> String {
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
        let dayString = displayDate(date: displayedDate)
        return dayString
    }

}




