//
//  ViewController.swift
//  Time-Tracker
//
//  Created by Joiceypoo 🎉 on 12/11/18.
//  Copyright © 2018 Team Sweet Cheeks. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var eventsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Time Tracker"
        eventsTable.delegate = self
        eventsTable.dataSource = self
        setupView()
        
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
    }
    
    private func setupView() {
        addButton.layer.cornerRadius = 20
        addButton.layer.masksToBounds = true
        addButton.tintColor = .blue
        let image = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(image, for: .normal)
    }
    
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
//        cell.backgroundColor = .red
        return cell
    }
    
    
}

