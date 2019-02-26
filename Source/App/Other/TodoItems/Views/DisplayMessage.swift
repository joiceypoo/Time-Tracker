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
    
    public let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = #colorLiteral(red: 0.6039215686, green: 0.6156862745, blue: 0.6745098039, alpha: 1)
        return label
    }()
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(messageLabel)
        messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 70).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
