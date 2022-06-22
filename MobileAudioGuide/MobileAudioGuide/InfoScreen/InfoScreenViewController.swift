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
        setupViews()
    }
    
    private func setupViews() {
        title = "Author"
        view.addSubview(infoScreenView)
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = ""

        infoScreenView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            infoScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            infoScreenView.widthAnchor.constraint(equalTo: view.widthAnchor),
            infoScreenView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        infoScreenView.segmentedControl.addTarget(self, action: #selector(changeView), for: .valueChanged)
        infoScreenView.instagramButton.addTarget(self, action: #selector(openInstagram), for: .touchUpInside)
        infoScreenView.facebookButton.addTarget(self, action: #selector(openFacebook), for: .touchUpInside)
        loaderInfo()
    }
    
    @objc func openInstagram() {
        guard let url = URL(string: "https://www.instagram.com/") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func openFacebook() {
        guard let url = URL(string: "https://www.facebook.com/") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func changeView() {
        let value = infoScreenView.segmentedControl.selectedSegmentIndex
        infoScreenView.showView(selectedSegment: value)
    }
    
    private func loaderInfo() {
        if let path = Bundle.main.path(forResource: "infoAboutAuthor", ofType: "txt"),
           let text = try? String(contentsOfFile: path) {
                infoScreenView.infoAboutAuthorTextView.text = text
        }
    }
}
