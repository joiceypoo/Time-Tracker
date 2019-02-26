//
//  AddHabitViewModel.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 18/02/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import Foundation

class AddHabitViewModel {
    let todo: TodoItem?
    let categories: [Category]
    init(todo: TodoItem?, categories: [Category]) {
        self.todo = todo
        self.categories = categories
    }
}
