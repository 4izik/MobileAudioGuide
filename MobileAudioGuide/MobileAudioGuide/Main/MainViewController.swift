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
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
            return cell
    }
    
    
}

