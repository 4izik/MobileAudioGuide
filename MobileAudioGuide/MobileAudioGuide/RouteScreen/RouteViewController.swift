//
//  RouteViewController.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 04.06.2022.
//

import UIKit

/// ViewController для экрана "Маршрут экскурсии"
final class RouteViewController: UIViewController {
    
    // TODO: Передавать в excursions массив с моделями точек на маршруте
    private let excursionInfo: ExcursionInfo
    private var isFullVersionPurchsded = false
    private var numberOfFreePoints = 5
    
    private lazy var audioPlayerView: AudioPlayerView = {
        // TODO: Подставлять актуальное имя файла для каждого экрана
        // TODO: Скрывать изначально, отображать при нажатии на кнопку play в ячейке
        let audioPlayerView = AudioPlayerView(audioFileName: "Tour1About")
        return audioPlayerView
    }()
    
    private lazy var routeTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = 135
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 70, right: 0)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupRouteTableView()
        setupViews()
        activateConstraints()
        routeTableView.layoutIfNeeded()
    }
    
    /// Инициализатор
    /// - Parameter excursionInfo: модель текущей экскурсии
    init(excursionInfo: ExcursionInfo) {
        self.excursionInfo = excursionInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Initializing from Storyboard isn't supported")
    }
    
    private func setupViewController() {
        title = "Excursion route"
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setupRouteTableView() {
        routeTableView.register(PointOfInterestTableViewCell.self,
                                forCellReuseIdentifier: PointOfInterestTableViewCell.identifier)
        routeTableView.register(BuyFullVersionTableViewCell.self,
                                forCellReuseIdentifier: BuyFullVersionTableViewCell.identifier)
    }
    
    private func setupViews() {
        [routeTableView, audioPlayerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            routeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            routeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            routeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            routeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            audioPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            audioPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            audioPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            audioPlayerView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}

extension RouteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFullVersionPurchsded ? excursionInfo.tours.count : numberOfFreePoints + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (isFullVersionPurchsded, indexPath.row) {
        
        case (true, excursionInfo.tours.count - 1):
            return getPointOfInterestCellIn(tableView, forIndexPath: indexPath, isLast: true)
            
        case (true, _), (false, ..<numberOfFreePoints):
            return getPointOfInterestCellIn(tableView, forIndexPath: indexPath, isLast: false)
            
        case (false, numberOfFreePoints):
            return getPointOfInterestCellIn(tableView, forIndexPath: indexPath, isLast: false, isActive: false)
            
        case (false, numberOfFreePoints + 1):
            return getBuyFullVersionCellIn(tableView, forIndexPath: indexPath)
            
        default: return UITableViewCell()
        }
    }
    
    private func getBuyFullVersionCellIn(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BuyFullVersionTableViewCell.identifier,
                                                       for: indexPath) as? BuyFullVersionTableViewCell
        else { return UITableViewCell() }
        cell.totalPointsNumber = excursionInfo.tours.count
        cell.buyFullVersionButton.addTarget(self, action: #selector(purchaseButtonTapped), for: .touchUpInside)
        return cell
    }
    
    private func getPointOfInterestCellIn(_ tableView: UITableView,
                                          forIndexPath indexPath: IndexPath,
                                          isLast: Bool,
                                          isActive: Bool = true) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PointOfInterestTableViewCell.identifier, for: indexPath) as? PointOfInterestTableViewCell,
              excursionInfo.tours.indices.contains(indexPath.row)
        else { return UITableViewCell() }
        
        cell.cellIndex = indexPath.row
        cell.excursionInfo = excursionInfo
        cell.isActive = isActive
        cell.isLast = isLast
        if isActive {
            cell.showDetailsButton.tag = indexPath.row
            cell.showDetailsButton.addTarget(self, action: #selector(showDetailsButtonTapped), for: .touchUpInside)
        }
        return cell
    }
    
    @objc private func purchaseButtonTapped() {
        let purchaseViewController = PurchaseViewController(excursionInfo: excursionInfo)
        navigationController?.pushViewController(purchaseViewController, animated: true)
    }
    
    @objc private func showDetailsButtonTapped(sender: UIButton) {
        let detailsViewController = DetailsScreenViewController(excursionInfo: excursionInfo, viewpointIndex: sender.tag + 1)
        navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
}
