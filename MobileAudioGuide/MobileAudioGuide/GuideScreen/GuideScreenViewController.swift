//
//  GuideScreenViewController.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 17.05.2022.
//

import UIKit

/// ViewController для экрана описания экскурсии
final class GuideScreenViewController: UIViewController {
    
    private let excursionInfo: ExcursionInfo
    private let infoImage = UIImage(systemName: "info.circle")
    private let textLoader: TextLoader
    private let excursionIndex: Int
    
    /// Приобретена ли полная версия для этой экскурсии
    var isFullVersion: Bool {
        PurchaseManager.shared.isProductPurchased(withIdentifier: excursionIndex.getProductIdentifier())
    }
    
    private lazy var guideScreenTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var audioPlayerView: AudioPlayerView = {
        let audioPlayerView = AudioPlayerView(audioFileName: excursionInfo.filenamePrefix + "0")
        audioPlayerView.isHidden = AudioPlayer.shared.isPlaying ? false : true
        audioPlayerView.alpha = AudioPlayer.shared.isPlaying ? 1 : 0
        return audioPlayerView
    }()
    
    private lazy var tableViewToSuperViewBottomAnchor: NSLayoutConstraint = {
        guideScreenTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    }()
    
    private lazy var tableViewToAudioPlayerViewBottomAnchor: NSLayoutConstraint = {
        guideScreenTableView.bottomAnchor.constraint(equalTo: audioPlayerView.topAnchor, constant: 0)
    }()
    
    /// Инициализатор
    /// - Parameters:
    ///   - excursionInfo: модель с информацией об экскурсии
    ///   - textLoader: экземпляр загрузчика текстовых файлов
    ///   - excursionIndex: индекс ячейки экскурсии с главного экрана
    init(excursionInfo: ExcursionInfo, textLoader: TextLoader, excursionIndex: Int) {
        self.excursionInfo = excursionInfo
        self.textLoader = textLoader
        self.excursionIndex = excursionIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Initializing from Storyboard isn't supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationController()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Istanbul"
        
        if AudioPlayer.shared.nowPlayingFileName != excursionInfo.filenamePrefix + "0" {
            AudioPlayer.shared.stopPlaying()
            audioPlayerView.isHidden = true
            audioPlayerView.alpha = 0
            tableViewToAudioPlayerViewBottomAnchor.isActive = false
            tableViewToSuperViewBottomAnchor.isActive = true
        }
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
    }
    
    private func setupViews() {
        [guideScreenTableView, audioPlayerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        guideScreenTableView.allowsSelection = false
        guideScreenTableView.showsVerticalScrollIndicator = false
        guideScreenTableView.showsHorizontalScrollIndicator = false
        guideScreenTableView.backgroundColor = .white
        guideScreenTableView.separatorStyle = .none
        guideScreenTableView.register(UITableViewCell.self, forCellReuseIdentifier: "GuideTextCell")
        
        NSLayoutConstraint.activate([
            guideScreenTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            guideScreenTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            guideScreenTableView.topAnchor.constraint(equalTo: view.topAnchor),
            
            AudioPlayer.shared.isPlaying ?
            tableViewToAudioPlayerViewBottomAnchor : tableViewToSuperViewBottomAnchor,
            
            audioPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            audioPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            audioPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            audioPlayerView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: infoImage,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showInfo))
    }
    
    @objc private func showInfo() {
        let infoScreenViewController = InfoScreenViewController()
        navigationController?.pushViewController(infoScreenViewController, animated: true)
    }
    
    @objc private func aboutExcursionButtonTapped() {
        switch audioPlayerView.isHidden {
        case false: hideAudioPlayerView()
        case true: showAudioPlayerView()
        }
    }
    
    @objc private func beginExcursionButtonTapped() {
        let mapScreenViewController = OfflineManagerViewController(excursionInfo: excursionInfo, excursionIndex: excursionIndex)
        navigationController?.pushViewController(mapScreenViewController, animated: true)
    }
    
    private func hideAudioPlayerView() {
        self.tableViewToAudioPlayerViewBottomAnchor.isActive = false
        self.tableViewToSuperViewBottomAnchor.isActive = true
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.audioPlayerView.alpha = 0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.audioPlayerView.isHidden = true
        }
    }
    
    private func showAudioPlayerView() {
        audioPlayerView.isHidden = false
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.audioPlayerView.alpha = 1
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.tableViewToSuperViewBottomAnchor.isActive = false
            self.tableViewToAudioPlayerViewBottomAnchor.isActive = true
        }
    }
    /// Обработка нажатия на кнопку покупки экскурсий
    @objc func purchaseButtonTapped() {
        let purchaseViewController = PurchaseViewController(excursionInfo: excursionInfo, excursionIndex: excursionIndex)
        navigationController?.pushViewController(purchaseViewController, animated: true)
    }
}

// MARK: - Table view data source
extension GuideScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuideTextCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        cell.textLabel?.text = excursionInfo.excursionDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = GuideHeaderView(excursionInfo: excursionInfo, guideFeatureViewBuilder: GuideFeatureViewBuilder(excursionInfo: excursionInfo))
        headerView.aboutExcursionButton.addTarget(self, action: #selector(aboutExcursionButtonTapped), for: .touchUpInside)
        headerView.beginExcursionButton.addTarget(self, action: #selector(beginExcursionButtonTapped), for: .touchUpInside)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard !isFullVersion else { return nil }
        let footerView = PurchaseButtonFooterView(reuseIdentifier: "FooterView")
        footerView.purchaseButton.addTarget(self, action: #selector(purchaseButtonTapped), for: .touchUpInside)
        return footerView
    }
}
