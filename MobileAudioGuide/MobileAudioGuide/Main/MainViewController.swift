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
    let namesTours = ["Istanbul in 1 day: The most popular route", "From Galata Bridge\nto Taksim Square", "Non-touristic Istanbul and\nthe legacy of Constantinople"]
    let tagsColors = [Colors.hitBanner, Colors.newBanner, Colors.specialBanner]
    let tagsNames = ["hit","new","special"]
    let excursionsInfo: [ExcursionInfo]
    
    init(excursionsInfo: [ExcursionInfo]) {
        self.excursionsInfo = excursionsInfo
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Initializing from Storyboard isn't supported")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        mainView.tableView.reloadData()
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
        
        mainView.hotelsButton.addTarget(self, action: #selector(openHotelsURL), for: .touchUpInside)
        mainView.ticketsButton.addTarget(self, action: #selector(openTicketsURL), for: .touchUpInside)
    }
    
    @objc func openHotelsURL() {
        guard let url = URL(string: "https://www.booking.com/city/tr/istanbul.ru.html?aid=334407&no_rooms=1&group_adults=2&label=alex-app-istanbul-ios") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func openTicketsURL() {
        guard let url = URL(string: "https://experience.tripster.ru/experience/Istanbul/?sorting=rating&type=private&utm_campaign=affiliates&utm_medium=link&utm_source=travelpayouts") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.imageToursView.image = UIImage(named: (excursionsInfo[indexPath.row].filenamePrefix) + "0")
        cell.infoLabel.text = namesTours[indexPath.row]
        cell.backgroundColor = .clear
        cell.tagLabel.text = tagsNames[indexPath.row]
        cell.tagLabel.backgroundColor = tagsColors[indexPath.row]
        cell.greenCheckMarkView.isHidden = !excursionsInfo[indexPath.row].isCompleted()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let guideScreenViewController = GuideScreenViewController(excursionInfo: excursionsInfo[indexPath.row],
                                                                  textLoader: TextLoader(),
                                                                  excursionIndex: indexPath.row)
        navigationController?.pushViewController(guideScreenViewController, animated: true)
    }
}
