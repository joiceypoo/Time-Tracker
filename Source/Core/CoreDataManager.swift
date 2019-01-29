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
