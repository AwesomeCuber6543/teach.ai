//
//  AlertManager.swift
//  HackMIT
//
//  Created by yahia salman on 9/17/23.
//

import Foundation
import UIKit

class AlertManager {
    
    public static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}
