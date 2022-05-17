//
//  GuideScreenTableViewController.swift
//  MobileAudioGuide
//
//  Created by AlekseiPavlov on 17.05.2022.
//

import UIKit

class GuideScreenTableViewController: UITableViewController {
    
    private let infoImage = UIImage(systemName: "info.circle")
    let indexOfSelectedItem: Int
    let textLoader: TextLoader
    private var excursionInfo: ExcursionInfo? {
        textLoader.loadExcursionInfoFor(index: indexOfSelectedItem)
    }
    
    init(indexOfSelectedItem: Int, textLoader: TextLoader) {
        self.indexOfSelectedItem = indexOfSelectedItem
        self.textLoader = textLoader
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupViewController() {
        title = "Istanbul"
        tableView.separatorStyle = .none
    }
    
    private func setupNavigationController() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBar.barTintColor = .systemBlue
        navigationBar.tintColor = .white
        navigationBar.topItem?.title = ""
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21, weight: .bold)
        ]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: infoImage,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showInfo))
    }
    
    @objc private func showInfo() {
        // TODO: обработка нажатия на кнопку инфо
        print("button tapped")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "GuideTextCell")
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = .systemFont(ofSize: 15)
        cell.textLabel?.text = excursionInfo?.excursionDescription
        return cell
    }
}
