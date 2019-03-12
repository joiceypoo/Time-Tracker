//
//  CoreDataManager.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 21/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HabbbitModels")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading persistent store failed: \(error)")
            }
        }
        return container
    }()
    
    func createTodo(todo title: String,
                    repeatDays: [String],
                    categoryName: String?,
                    isRepeating: Bool,
                    creationDate: String,
                    notes: String) -> TodoItem {
        let context = persistentContainer.viewContext
        
        let todosCount = getAllTodosCount()
        
        let todo = NSEntityDescription.insertNewObject(forEntityName: "TodoItem",
                                                       into: context) as! TodoItem
        
        let repeatTodo = Repeat(context: context)
        repeatTodo.isRepeating = isRepeating
        
        todo.displayOrder = todosCount
        todo.title = title
        todo.creationDate = creationDate
        todo.notes = notes
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: repeatDays,
                                                        requiringSecureCoding: false)
            repeatTodo.weekday = data
            todo.repeatTodos = repeatTodo
            todo.categoryName = categoryName
            try context.save()
        } catch let error {
            print("Failed to archive data", error )
        }
        
        return todo
    }
    
    func fetchCategories() -> [Category] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        do {
            let categories = try context.fetch(fetchRequest)
            return categories
        } catch let error {
            print("Failed to load Categories", error)
            return []
        }
    }

    
    func fetchAllTodos(for day: String) -> [(key: String, value: [TodoItem])]  {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        var todosDictionary: [String: [TodoItem]] = [:]
        UsedDates.shared.selectedWeekday = day
        do {
            let todos = try context.fetch(fetchRequest)
            for todo in todos {
                
                let data = todo.repeatTodos?.weekday
                let daysArray = Unarchive.unarchiveStringArrayData(from: data)
                let isValidDay = daysArray.contains(day) || daysArray.count == 7
                if let name = todo.categoryName, name == "None" && todosDictionary[name] == nil && isValidDay  {
                    todosDictionary["None"] = [todo]
                } else if let name = todo.categoryName, name == "None" && todosDictionary[name] != nil && isValidDay {
                    todosDictionary["None"]?.append(todo)
                } else if let name = todo.categoryName, todosDictionary[name] == nil && name != "None" && isValidDay  {
                    todosDictionary[todo.categoryName!] = [todo]
                } else if let name = todo.categoryName, todosDictionary[name] != nil && name != "None" && isValidDay {
                    todosDictionary[todo.categoryName!]?.append(todo)
                }
                
            }
        } catch let error {
            print("Failed in fetching todos", error)
        }
        
        let keys = Array(todosDictionary.keys)
        for key in keys {
            let sortedTodosList = todosDictionary[key]!.sorted { (todoA, todoB) -> Bool in
                todoA.displayOrder < todoB.displayOrder
            }
            todosDictionary[key] = sortedTodosList
        }
        
        
        let sortedTodos = todosDictionary.sorted { (todoA, todoB) -> Bool in
            todoA.key < todoB.key
        }
        
        return sortedTodos
    }
    
    func recreateHabit(for todo: TodoItem) {
        let selectedWeekday = UsedDates.shared.selectedWeekday
        var repeatWeekdays = Unarchive.unarchiveStringArrayData(from: todo.repeatTodos?.weekday)
        guard let habitTitle = todo.title,
            let categoryName = todo.categoryName,
            let creationDate = todo.creationDate,
            let isRepeating = todo.repeatTodos?.isRepeating,
            let indexOfSelectedWeekday = repeatWeekdays.index(of: selectedWeekday),
            let notes = todo.notes
            else { return }
        
        repeatWeekdays.remove(at: indexOfSelectedWeekday)
        
        if !repeatWeekdays.isEmpty {
            let _ = CoreDataManager.shared.createTodo(todo: habitTitle,
                                                      repeatDays: repeatWeekdays,
                                                      categoryName: categoryName,
                                                      isRepeating: isRepeating,
                                                      creationDate: creationDate,
                                                      notes: notes)
        }
    }
    
    func reorderTodo(from todoOne: TodoItem, to todoTwo: TodoItem) {
        let context = persistentContainer.viewContext
        let displayOrderOne = todoOne.displayOrder
        let displayOrderTwo = todoTwo.displayOrder
        let categoryNameOne = todoOne.categoryName ?? ""
        let categoryNameTwo = todoTwo.categoryName ?? ""
        todoOne.displayOrder = displayOrderTwo
        todoTwo.displayOrder = displayOrderOne
        
        if categoryNameOne != categoryNameTwo {
            todoOne.categoryName = categoryNameTwo
        }
        
        do {
            try context.save()
        } catch let error {
            print("Saved new positions", error)
        }
    }
    
    private func getAllTodosCount() -> Int16 {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        do {
            let todos = try context.fetch(fetchRequest)
            return Int16(todos.count)
        } catch let error {
            print("Failed in fetching todos", error)
            return 0
        }
    }
    
    func createCategory(from categoryName: String?) {
        let name = categoryName ?? ""
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category",
                                                           into: context) as! Category
        category.setValue(name,
                          forKey: "name")
        do {
            try context.save()
        } catch let error {
            print("Failed to save Category", error)
        }
    }
}

