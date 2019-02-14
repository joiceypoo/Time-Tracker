//
//  EditTodoItemDelegates.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 25/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension EditTodoController: UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, CustomCellDelegate {
    func handleWeekdays(days: [String]) {
         weekdays = days
    }
    
    func postCategory(category: String) {
        self.category = category
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            guard let repeatController = RepeatController.instantiate(from: .main)
                else { return }
            
            navigationController?.pushViewController(repeatController,
                                                     animated: true)
        }
        
        if indexPath.row == 3 {
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            let cell = todoItemDetailTable.cellForRow(at: indexPath) as! CustomCell
            guard let categoriesController = CategoriesController.instantiate(from: .main)
                else { return }
            categoriesController.detailLabelText = cell.detailTextLabel?.text
            navigationController?.pushViewController(categoriesController, animated: true)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.isEmpty)! {
            let alertController = Alert.displayMessage(with: "The title field should not be empty",
                                                       title: "Empty Field")
            present(alertController, animated: true, completion: nil)
        } else {
            habitTitle = textField.text
        }
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            habitTitle = updatedText
        }
        return true
    }
    
    public func textView(_ textView: UITextView,
                         shouldChangeTextIn range: NSRange,
                         replacementText text: String) -> Bool {
        let resultRange = text.rangeOfCharacter(from: CharacterSet.newlines,
                                                options: .backwards)
        if text.count == 1 && resultRange != nil {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
