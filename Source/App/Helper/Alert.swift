//
//  Alert.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 31/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

public class Alert {
    public static func displayMessage(with message: String,
                                      title: String) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok",
                                        style: .default,
                                        handler: nil)
        alertController.addAction(alertAction)
        return alertController
    }
}
