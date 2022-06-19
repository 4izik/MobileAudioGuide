//
//  RouteViewController.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 04.06.2022.
//

import UIKit

/// Возможные варианты установки изображения для кнопки Play в ячейке
enum PlayButtonOption {
    /// Изображение "play.circle.fill"
    case playImage
    /// Изображение берется из самой ячейки в зависимости от состояния воспроизведения
    case smallAudioPlayerButtonImage
}

/// ViewController для экрана "Маршрут экскурсии"
final class RouteViewController: UIViewController {
    
    private let excursionInfo: ExcursionInfo
    private var isFullVersionPurchased = true
    private var numberOfFreePoints = 5
    
    /// Индекс ячейки, в которой нужно будет изменить изображение кнопки play при изменении источника воспроизведения
    lazy var indexOfCellToPause: Int? = {
        guard let nowPlayingFileName = nowPlayingFileName,
              let nowPlayingAudioNumberString = nowPlayingFileName.components(separatedBy: excursionInfo.filenamePrefix).last,
              let nowPlayingAudioNumber = Int(nowPlayingAudioNumberString)
        else { return nil }
        return nowPlayingAudioNumber - 1
    }()
    
    /// Имя аудиофайла, воспроизводимого на момент перехода на экран
    var nowPlayingFileName: String? {
        AudioPlayer.shared.nowPlayingFileName
    }
    
    /// View с аудиопроигрываетелм
    lazy var audioPlayerView: AudioPlayerView = {
        let audioPlayerView = AudioPlayerView(audioFileName: nowPlayingFileName ?? excursionInfo.filenamePrefix + "1")
        audioPlayerView.isHidden = (nowPlayingFileName != nil) ? false : true
        audioPlayerView.alpha = (nowPlayingFileName != nil) ? 1 : 0
        audioPlayerView.playButton.tag = indexOfCellToPause ?? 0
        audioPlayerView.playButton.addTarget(self, action: #selector(audioPlayerViewPlayButtonTapped), for: .touchUpInside)
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
        tableView.contentInset.top = 30
        tableView.contentInset.bottom = 70
        tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: false)
        return tableView
    }()
    
    /// Инициализатор
    /// - Parameter excursionInfo: модель текущей экскурсии
    init(excursionInfo: ExcursionInfo) {
        self.excursionInfo = excursionInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Initializing from Storyboard isn't supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupRouteTableView()
        setupViews()
        activateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Excursion route"
        
        audioPlayerView.isHidden = (nowPlayingFileName != nil) ? false : true
        audioPlayerView.alpha = (nowPlayingFileName != nil) ? 1 : 0
        
        if let nowPlayingFileName = nowPlayingFileName, AudioPlayer.shared.isPlaying {
            audioPlayerView.playButtonTappedFor(filename: nowPlayingFileName, continuePlaying: AudioPlayer.shared.isPlaying)
        }
        
        setCellPlayAudioButtonImageTo(.smallAudioPlayerButtonImage)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setCellPlayAudioButtonImageTo(.playImage)
    }
    
    private func setupViewController() {
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
    
    @objc private func audioPlayerViewPlayButtonTapped(sender: UIButton) {
        if let cell = routeTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? PointOfInterestTableViewCell {
            cell.playAudioButton.setImage(cell.smallAudioPlayerButtonImage, for: .normal)
            
            guard let nowPlayingFileName = nowPlayingFileName,
                  let nowPlayingAudioNumberString = nowPlayingFileName.components(separatedBy: excursionInfo.filenamePrefix).last,
                  let nowPlayingAudioNumber = Int(nowPlayingAudioNumberString)
            else { return }
            
            audioPlayerView.playButton.tag = nowPlayingAudioNumber - 1
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
    
    private func setCellPlayAudioButtonImageTo(_ option: PlayButtonOption) {
        if let indexOfCellToPause = indexOfCellToPause,
           let cell = routeTableView.cellForRow(at: IndexPath(row: indexOfCellToPause, section: 0)) as? PointOfInterestTableViewCell {
            
            switch option {
            case .playImage:
                cell.playAudioButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            case .smallAudioPlayerButtonImage:
                cell.playAudioButton.setImage(cell.smallAudioPlayerButtonImage, for: .normal)
            }
        }
    }
}

// MARK: - Table view data source
extension RouteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFullVersionPurchased ? excursionInfo.tours.count : numberOfFreePoints + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (isFullVersionPurchased, indexPath.row) {
            
        case (true, excursionInfo.tours.count - 1):
            return getPointOfInterestCellIn(tableView: tableView,
                                            forIndexPath: indexPath,
                                            isLast: true)
            
        case (true, _), (false, ..<numberOfFreePoints):
            return getPointOfInterestCellIn(tableView: tableView,
                                            forIndexPath: indexPath,
                                            isLast: false)
            
        case (false, numberOfFreePoints):
            return getPointOfInterestCellIn(tableView: tableView,
                                            forIndexPath: indexPath,
                                            isLast: false,
                                            isActive: false)
            
        case (false, numberOfFreePoints + 1):
            return getBuyFullVersionCellIn(tableView: tableView,
                                           forIndexPath: indexPath)
            
        default: return UITableViewCell()
        }
    }
    
    private func getBuyFullVersionCellIn(tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BuyFullVersionTableViewCell.identifier,
                                                       for: indexPath) as? BuyFullVersionTableViewCell
        else { return UITableViewCell() }
        
        cell.totalPointsNumber = excursionInfo.tours.count
        cell.buyFullVersionButton.addTarget(self, action: #selector(purchaseButtonTapped), for: .touchUpInside)
        return cell
    }
    
    private func getPointOfInterestCellIn(tableView: UITableView,
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
            cell.playAudioButton.tag = indexPath.row
            cell.showDetailsButton.addTarget(self, action: #selector(showDetailsButtonTapped), for: .touchUpInside)
            cell.playAudioButton.addTarget(self, action: #selector(cellPlayAudioButtonTapped), for: .touchUpInside)
            cell.playAudioButton.setImage(cell.smallAudioPlayerButtonImage, for: .normal)
        }
        return cell
    }
    
    @objc private func purchaseButtonTapped() {
        let purchaseViewController = PurchaseViewController(excursionInfo: excursionInfo)
        navigationController?.pushViewController(purchaseViewController, animated: true)
    }
    
    @objc private func showDetailsButtonTapped(sender: UIButton) {
        let detailsViewController = DetailsScreenViewController(excursionInfo: excursionInfo, viewpointIndex: sender.tag + 1)
        detailsViewController.delegate = self
        navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
    
    @objc private func cellPlayAudioButtonTapped(sender: UIButton) {
        audioPlayerView.playButtonTappedFor(filename: excursionInfo.filenamePrefix + String(sender.tag + 1))
        audioPlayerView.isHidden = false
        audioPlayerView.alpha = 1
        
        setSmallPlayButtonImagesForPlaying(cellIndex: sender.tag)
        audioPlayerView.playButton.tag = sender.tag
    }
    
    private func setSmallPlayButtonImagesForPlaying(cellIndex: Int) {
        setCellPlayAudioButtonImageTo(.smallAudioPlayerButtonImage)
        
        guard let thisCell = routeTableView.cellForRow(at: IndexPath(row: cellIndex, section: 0)) as? PointOfInterestTableViewCell else { return }
        thisCell.playAudioButton.setImage(thisCell.smallAudioPlayerButtonImage, for: .normal)
        indexOfCellToPause = cellIndex
    }
}
