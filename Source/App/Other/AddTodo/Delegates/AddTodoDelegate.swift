//
//  AddTodoDelegate.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 23/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension AddTodoController: UITableViewDelegate, CustomCellDelegate {
    func postCategory(category: String) {
        self.category = category
    }
    
    func handleWeekdays(days: [String]) {
        weekdays = days
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            guard let repeatController = RepeatController.instantiate(from: .main)
                else { return }
            
            navigationController?.pushViewController(repeatController,
                                                     animated: true)
        }
        
        if indexPath.row == 3 {
            guard let categoriesController = CategoriesController.instantiate(from: .main)
                else { return }
            navigationController?.pushViewController(categoriesController, animated: true)
        }
    }
}
