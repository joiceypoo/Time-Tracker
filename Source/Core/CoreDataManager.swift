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
    
    func fetchTodos() -> [TodoItem] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        do {
            let todos = try context.fetch(fetchRequest)
            return todos
        } catch let err {
            print("Error", err)
            return []
        }
    }
    
    private func createTodo(todo title: String,
                            repeatDays: [String],
                            category: String,
                            isRepeating: Bool,
                            notes: String) {
        
        let context = persistentContainer.viewContext
        let todoItem = NSEntityDescription.insertNewObject(forEntityName: "TodoItem", into: context) as! TodoItem
        todoItem.setValue(title, forKey: "title")
        todoItem.setValue(notes, forKey: "notes")
        todoItem.category?.name = category        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: repeatDays,
                                                        requiringSecureCoding: false)
            todoItem.repeatTodos?.weekday = data
            
        } catch let err {
            print(err)
        }
        
        do {
            try context.save()
        } catch let err {
            print("Error \(err)")
        }
    }
    
//    func fetchCompanies() -> [Company] {
//        let context = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
//
//        do {
//            let companies = try context.fetch(fetchRequest)
//            return companies
//        } catch let err {
//            print("Fetch failed: \(err)")
//            return []
//        }
//    }
    
//    func createEmployee(employeeName: String,
//                        employeeType: String,
//                        birthdayDate: Date,
//                        company: Company) -> (Employee?, Error?) {
//        let context = persistentContainer.viewContext
//        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee",
//                                                           into: context) as! Employee
//        
//        employee.company = company
//        employee.type = employeeType
//        employee.setValue(employeeName, forKey: "name")
//        
//        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation",
//                                                                      into: context) as! EmployeeInformation
//        employeeInformation.birthday = birthdayDate
//        employee.employeeInformation = employeeInformation
//        
//        do {
//            try context.save()
//            return (employee, nil)
//        } catch let err {
//            print("Failed to save employee: ", err)
//            return (nil, err)
//        }
//    }
}
