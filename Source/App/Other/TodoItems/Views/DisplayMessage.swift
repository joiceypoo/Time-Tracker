//
//  DisplayMessage.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 23/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

public class DisplayMessage: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nothing on your list yet, Tap the plus button below to add a new item"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .customLightGray
        return label
    }()
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(messageLabel)
        messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -32).isActive = true
    }
}
