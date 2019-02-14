//
//  AddTodoController.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

protocol AddHabitDelegate {
    func didAddHabit(todo: TodoItem)
}

class AddHabitController: UIViewController {

    @IBOutlet weak var addHabitTable: UITableView!
    @IBOutlet weak var notesTextView: UITextView!
    
    var category: String?
    var habitTitle: String?
    var delegate: AddHabitDelegate?
    var weekdays: [String] = ["Every day"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationItem.title = "Add Habit"
        navigationController?.navigationBar.prefersLargeTitles = false
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                            style: .plain,
                                            target: self,
                                            action: #selector(handleDismiss))
        let rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(addHabit))
        leftBarButtonItem.tintColor = .customOrange
        rightBarButtonItem.tintColor = .customGray
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.addHabitTable.indexPathForSelectedRow {
            self.addHabitTable.deselectRow(at: index, animated: true)
        }
    }
    
    @objc private func addHabit() {
        let dateString = DatesString.getDatesString(format: "EEEE, d MMMM yyyy",
                                                    date: Date())
        if let title = habitTitle, !title.trimmingCharacters(in: .whitespaces).isEmpty {
            let todo = CoreDataManager.shared.createTodo(todo: title,
                                                         repeatDays: weekdays,
                                                         categoryName: category,
                                                         isRepeating: isRepeating,
                                                         creationDate: dateString,
                                                         notes: notesTextView.text)
            dismiss(animated: true) {
                self.delegate?.didAddHabit(todo: todo)
            }
        }
    }
    
    var isRepeating: Bool {
        if weekdays[0] == "Every day" || weekdays.count == 7 {
            return true
        } else {
            return false
        }
    }
    
    @objc private func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupView() {
        view.backgroundColor = .customDarkBlack
        notesTextView.backgroundColor = .customBlack
        notesTextView.textColor = .customLightGray
        notesTextView.delegate = self
        addHabitTable.separatorColor = .customLightGray
    }
}
