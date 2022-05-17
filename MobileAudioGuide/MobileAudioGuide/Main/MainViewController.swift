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
    let namesTours = ["Istanbul in 1 day: The most popular route", "From Galata Bridge to Taksim Square", "Non-touristic Istanbul and the legacy of Constantinople"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell
        cell?.imageToursView.image = UIImage(named: "Image\(indexPath.row + 1)")
        cell?.infoLabel.text = namesTours[indexPath.row]
        cell?.backgroundColor = .clear
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? MainTableViewCell
        cell?.imageToursView.alpha = 1
        let guideScreenViewController = GuideScreenTableViewController(indexOfSelectedItem: indexPath.row,
                                                                       textLoader: TextLoader())
        navigationController?.pushViewController(guideScreenViewController, animated: true)
    }
}
