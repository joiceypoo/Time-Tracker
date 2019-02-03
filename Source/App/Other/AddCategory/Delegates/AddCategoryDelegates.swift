//
//  AddCategoryDelegates.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 31/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension AddCategoryController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (categoryTextField.text?.isEmpty)! {
            categoryTextField.resignFirstResponder()
            return false
        } else {
            createCategory(from: categoryTextField.text)
            return true
        }
    }
}
