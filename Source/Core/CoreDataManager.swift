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
                    notes: String) -> (TodoItem, String) {
        
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
        
        return (todo, categoryName!)
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
    
    func fetchAllTodos() -> [String: [TodoItem]]  {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        let sortDescriptor = NSSortDescriptor(key: "creationDate",
                                              ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var todosDictionary: [String: [TodoItem]] = [:]
        do {
            let todos = try context.fetch(fetchRequest)
            for todo in todos {
                guard let name = todo.categoryName else { return [:] }
                if name == "Uncategorized" && todosDictionary[name] == nil {
                    todosDictionary["Uncategorized"] = [todo]
                } else if name == "Uncategorized" && todosDictionary[name] != nil {
                    todosDictionary["Uncategorized"]?.append(todo)
                } else if todosDictionary[name] == nil && name != "Uncategorized" {
                    todosDictionary[name] = [todo]
                } else if todosDictionary[name] != nil && name != "Uncategorized"  {
                    todosDictionary[name]?.append(todo)
                }
                
            }
        } catch let error {
            print("Failed in fetching todos", error)
        }
        let sortedTodos = todosDictionary.sorted { (a, b) -> Bool in
            a.key > b.key
        }
        print("I am sorted \(sortedTodos.count)")
        print(Array(todosDictionary.keys))
        return todosDictionary
    }
}

