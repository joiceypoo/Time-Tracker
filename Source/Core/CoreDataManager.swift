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
        
        let todo = NSEntityDescription.insertNewObject(forEntityName: "TodoItem",
                                                       into: context) as! TodoItem
        
        let repeatTodo = Repeat(context: context)
        repeatTodo.isRepeating = isRepeating
        
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
        do {
            let todos = try context.fetch(fetchRequest)
            for todo in todos {
                
                let daysArray = Unarchive.unarchiveStringArrayData(from: todo.repeatTodos?.weekday)
                let isValidDay = daysArray.contains(day) || todo.repeatTodos?.isRepeating ?? false
                if let name = todo.categoryName, name == "Uncategorized" && todosDictionary[name] == nil && isValidDay  {
                    todosDictionary["Uncategorized"] = [todo]
                } else if let name = todo.categoryName, name == "Uncategorized" && todosDictionary[name] != nil && isValidDay {
                    todosDictionary["Uncategorized"]?.append(todo)
                } else if let name = todo.categoryName, todosDictionary[name] == nil && name != "Uncategorized" && isValidDay  {
                    todosDictionary[todo.categoryName!] = [todo]
                } else if let name = todo.categoryName, todosDictionary[name] != nil && name != "Uncategorized" && isValidDay {
                    todosDictionary[todo.categoryName!]?.append(todo)
                }
                
            }
        } catch let error {
            print("Failed in fetching todos", error)
        }
        let sortedTodos = todosDictionary.sorted { (todoA, todoB) -> Bool in
            todoA.key < todoB.key
        }
        return sortedTodos
    }
    
    
    
    func reorderTodo(from todo: TodoItem, to newTodo: TodoItem) {
        let context = persistentContainer.viewContext
        let temporalHolder = todo
        todo.categoryName = newTodo.categoryName
        todo.title = newTodo.title
        todo.completed = newTodo.completed
        todo.creationDate = newTodo.creationDate
        todo.notes = newTodo.notes
        todo.repeatTodos = newTodo.repeatTodos
        
        newTodo.categoryName = temporalHolder.categoryName
        newTodo.title = temporalHolder.title
        newTodo.completed = temporalHolder.completed
        newTodo.creationDate = temporalHolder.creationDate
        newTodo.notes = temporalHolder.notes
        newTodo.repeatTodos = temporalHolder.repeatTodos
        
        do {
            try context.save()
        } catch let error {
            print("Failed to update records", error)
        }
        
    }
}

