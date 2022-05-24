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
    
    private func setupViews() {
        title = "Author"
        view.addSubview(infoScreenView)
        view.backgroundColor = .white

        infoScreenView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            infoScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            infoScreenView.widthAnchor.constraint(equalTo: view.widthAnchor),
            infoScreenView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        infoScreenView.segmentedControl.addTarget(self, action: #selector(changeView), for: .valueChanged)
        loaderInfo()
    }
    
    @objc func changeView() {
        let value = infoScreenView.segmentedControl.selectedSegmentIndex
        infoScreenView.showView(selectedSegment: value)
    }
    
    private func setupNavigationController() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21, weight: .bold)
        ]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func loaderInfo() {
        if let path = Bundle.main.path(forResource: "infoAboutAuthor", ofType: "txt"),
           let text = try? String(contentsOfFile: path) {
                infoScreenView.infoAboutAuthorTextView.text = text
        }
    }
}
