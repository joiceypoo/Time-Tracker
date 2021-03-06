//
//  AddHabitView+Delegates.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 18/02/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension AddHabitView: UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row].name
        categoryTextField.text = category
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == categoryTextField {
            hashTagLabel.textColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1843137255, alpha: 1)
            shouldShowCategories = true
            notesTextView.alpha = 0
            if contentViewBottomConstraint.constant != -100 && changedYPosition == 0 {
                contentViewBottomConstraint.constant -= 100
            }
            
            if textField == categoryTextField && contentViewBottomConstraint.constant == 0 {
                hashTagLabel.textColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1843137255, alpha: 1)
                shouldShowCategories = true
                notesTextView.alpha = 0
                contentViewBottomConstraint.constant -= 100
            }
        }
    }
    
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == categoryTextField {
            shouldShowCategories = false
            notesTextView.alpha = 1
            contentViewBottomConstraint.constant = 0
        } else if textField == habitTitleTextField && contentViewBottomConstraint.constant == -100 {
            shouldShowCategories = shouldShowCategories == true ? false: true
            notesTextView.alpha = 1
            contentViewBottomConstraint.constant = 0
        }
        
        if contentViewBottomConstraint.constant == changedYPosition {
            categoryTextField.isEnabled = true
            contentViewBottomConstraint.constant -= changedYPosition
        }
        
        if contentViewBottomConstraint.constant == -100 && changedYPosition != 0 {
            contentViewBottomConstraint.constant += 100
        }
        textField.resignFirstResponder()
        return true
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        delegate?.showTextInputArea()
        categoryTextField.isEnabled = false
        if originalYPosition == 0 {
            originalYPosition = frame.origin.y
            let yValue = frame.origin.y
            changedYPosition = yValue - (keyboardHeight + categoriesTable.frame.height)
            contentViewBottomConstraint.constant += changedYPosition
        } else {
            contentViewBottomConstraint.constant = changedYPosition
        }
        if viewModel?.todo != nil {
            notesTextViewHeightConstraint.constant = 120
        }
        if textView.text == "Add notes" {
            textView.text = ""
        }
        return true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        if textField == categoryTextField {
            if string == "#" {
                return false
            }
        }
        
        return true
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                         replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            contentViewBottomConstraint.constant -= changedYPosition
            categoryTextField.isEnabled = true
            return false
        }
        
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        let textSize = estimateFrame(for: notesTextView.text)
        if textSize.height + 30 > 120 {
            notesTextViewHeightConstraint.constant = textSize.height + 30
        }
        notesTextViewHeightConstraint.constant = 120
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: contentView) {
            return false
        }
        return true
    }
}
