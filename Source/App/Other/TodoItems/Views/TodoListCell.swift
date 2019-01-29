//
//  TodoListCell.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

public class TodoListCell: UITableViewCell {
    
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private lazy var checkBox: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let image = #imageLiteral(resourceName: "unchecked")
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.customLightGray.cgColor
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(checkboxPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    @objc private func checkboxPressed(sender: UIButton) {
        let impact = UIImpactFeedbackGenerator(style: .light)
        if sender.currentImage == #imageLiteral(resourceName: "unchecked") {
            sender.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            impact.impactOccurred()
        } else if sender.currentImage == #imageLiteral(resourceName: "checked") {
            sender.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
    }
    
    private func setupView() {
        detailTextLabel?.text = "Every day"
        detailTextLabel?.textColor = .customLightGray
        detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        backgroundColor = .customBlack
        textLabel?.textColor = .white
        textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        accessoryView = checkBox
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        selectedBackgroundView = view
    }
}
