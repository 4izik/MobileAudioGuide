//
//  AlertService.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 20.07.2022.
//

import UIKit

class AlertService {
    
    func presentAlert(title: String, message: String, in viewController: UIViewController) {
        let alertVc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Got it", style: .cancel)
        alertVc.addAction(okAction)
        viewController.present(alertVc, animated: true)
    }
}
