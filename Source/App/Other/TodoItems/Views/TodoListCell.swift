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
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        if sender.currentImage == #imageLiteral(resourceName: "unchecked") {
            sender.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        } else if sender.currentImage == #imageLiteral(resourceName: "checked") {
            sender.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
    }
    
    private func setupView() {
        backgroundColor = .customDarkGray
        textLabel?.textColor = .white
        selectionStyle = .none
        accessoryView = checkBox
    }
}
