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
                let isValidDay = daysArray.contains(day) || daysArray.contains("Every day")
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
    
    
    
    func reorderTodo(from todoOne: TodoItem, to todoTwo: TodoItem) {
        guard let oldTodo = fetchTodoFromCoreData(for: todoOne),
            let replacedTodo = fetchTodoFromCoreData(for: todoTwo) else { return}
         let context = persistentContainer.viewContext
        let temp = oldTodo
        oldTodo.categoryName = replacedTodo.categoryName
        oldTodo.title = replacedTodo.title
        oldTodo.creationDate = replacedTodo.creationDate
        oldTodo.notes = replacedTodo.notes
        oldTodo.repeatTodos = replacedTodo.repeatTodos
        oldTodo.isDone = replacedTodo.isDone
        replacedTodo.categoryName = temp.categoryName
        replacedTodo.title = temp.title
        replacedTodo.creationDate = temp.creationDate
        replacedTodo.notes = temp.notes
        replacedTodo.repeatTodos = temp.repeatTodos
        replacedTodo.isDone = temp.isDone
        do {
            try context.save()
        } catch let error {
            print("Failed to update records", error)
        }
    }
    
    func fetchTodoFromCoreData(for todo: TodoItem) -> TodoItem? {
        guard let categoryName = todo.categoryName, let title = todo.title else { return nil }
        let context = persistentContainer.viewContext
        let predicate = NSPredicate(format: "categoryName == %@ && title == %@",
                                    argumentArray: [categoryName, title])
        let request = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        request.predicate = predicate
        
        do {
            let todos = try context.fetch(request)
            return todos.first
        } catch let error {
            print("Failed to fetch todo", error)
            return nil
        }
    }
}

