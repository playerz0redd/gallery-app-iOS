//
//  UIViewController+alert.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 16.12.25.
//

import UIKit

extension UIViewController {
    func showAler(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
