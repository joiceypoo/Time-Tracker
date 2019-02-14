//
//  AddTodoDelegate.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 23/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension AddHabitController: UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, CustomCellDelegate {
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
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            let cell = addHabitTable.cellForRow(at: indexPath) as! AddHabitCell
            guard let categoriesController = CategoriesController.instantiate(from: .main)
                else { return }
            categoriesController.detailLabelText = cell.detailTextLabel?.text
            navigationController?.pushViewController(categoriesController, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.isEmpty)! {
            let alertController = Alert.displayMessage(with: "The title field should not be empty",
                                                       title: "Empty Field")
            present(alertController, animated: true, completion: nil)
        }
        habitTitle = textField.text
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField,
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
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if notesTextView.text == "Notes (Optional)" {
            notesTextView.text = ""
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
