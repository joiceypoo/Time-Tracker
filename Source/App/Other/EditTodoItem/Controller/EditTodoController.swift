//
//  EditTodoController.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 23/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit
protocol EditTodoControllerDelegate {
    func handleTodoDeletion(todoItem: TodoItem?)
    func didEditTodo(todoItem: TodoItem?)
}

public class EditTodoController: UIViewController {

    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var todoItemDetailTable: UITableView!
    
    var habitTitle: String?
    var delegate: EditTodoControllerDelegate?
    var weekdays: [String] = []
    var category: String?
    
    
    var todo: TodoItem?
   
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.todoItemDetailTable.indexPathForSelectedRow {
            self.todoItemDetailTable.deselectRow(at: index, animated: true)
        }
    }
    
    private func setupView() {
        view.backgroundColor = .customDarkBlack
        navigationItem.title = "Edit"
        navigationController?.navigationBar.prefersLargeTitles = false
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                style: .plain,
                                                target: self,
                                                action: #selector(handleCancel))
        let rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(handleDoneAction))
        leftBarButtonItem.tintColor = .customOrange
        rightBarButtonItem.tintColor = .customOrange
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        notesTextView.delegate = self
        notesTextView.text = todo?.notes
        notesTextView.backgroundColor = .customBlack
        notesTextView.textColor = .customLightGray
        todoItemDetailTable.separatorColor = .customLightGray
        deleteView.backgroundColor = .customBlack
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleDoneAction() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: weekdays,
                                                        requiringSecureCoding: false)
            todo?.categoryName = category
            todo?.notes = notesTextView.text
            todo?.title = habitTitle
            todo?.repeatTodos?.weekday = data
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didEditTodo(todoItem: self.todo)
            }
        } catch let error {
            print("Failed to save data", error)
        }
    }
    
    @IBAction func handleTodoDelete(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate?.handleTodoDeletion(todoItem: self.todo)
        }
    }
    
}
