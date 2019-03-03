//
//  AddHabitView+Delegates.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 18/02/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension AddHabitView: UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row].name
        categoryTextField.text = category
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == categoryTextField {
            shouldShowCategories = true
            moveTextField(textField: textField, moveDistance: -60, up: true)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == categoryTextField {
            moveTextField(textField: textField, moveDistance: -60, up: false)
            shouldShowCategories = false
        }
        textField.resignFirstResponder()
        return true
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        delegate?.showTextInputArea()
        textView.text = ""
        return true
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                         replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
