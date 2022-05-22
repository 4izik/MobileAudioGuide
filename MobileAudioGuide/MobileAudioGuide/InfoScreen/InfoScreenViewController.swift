//
//  InfoViewController.swift
//  MobileAudioGuide
//
//  Created by Настя on 21.05.2022.
//

import UIKit

class InfoScreenViewController: UIViewController {
    
    let infoScreenView = InfoScreenView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupViews() {
        title = "Author"
        view.addSubview(infoScreenView)
        view.backgroundColor = .white

        infoScreenView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoScreenView.widthAnchor.constraint(equalTo: view.widthAnchor),
            infoScreenView.heightAnchor.constraint(equalTo: view.heightAnchor),
            infoScreenView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        loaderInfo()
    }
    
    private func setupNavigationController() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .systemBlue
    }
    
    private func loaderInfo() {
        if let path = Bundle.main.path(forResource: "infoAboutAuthor", ofType: "txt") {
            if let text = try? String(contentsOfFile: path) {
                infoScreenView.textView.text = text
            }
        }
    }
}
