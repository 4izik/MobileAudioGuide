//
//  ViewController.swift
//  MobileAudioGuide
//
//  Created by Настя on 15.05.2022.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Properties
    let mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    private func setupUI() {
        view.addSubview(mainView)

        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mainView.heightAnchor.constraint(equalTo: view.heightAnchor),
            mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }


}

