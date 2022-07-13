//
//  InfoViewController.swift
//  MobileAudioGuide
//
//  Created by Настя on 21.05.2022.
//

import UIKit

class InfoScreenViewController: UIViewController {
    
    let infoScreenView = InfoScreenView()
    var creativeCommonUrl: String = "https://creativecommons.org/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    init(creativeCommonUrl: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        guard let creativeCommonUrl = creativeCommonUrl else { return }
        self.creativeCommonUrl = creativeCommonUrl
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        title = "Author"
        view.addSubview(infoScreenView)
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        infoScreenView.infoAboutAuthorTextView.text = TextLoader.loadFromTxtFile(named: "infoAboutAuthor")
        infoScreenView.photoAuthorsTextView.addHyperLinksToText(hyperLinks: ["Creative common license" : creativeCommonUrl])

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
}
