//
//  GuideScreenViewController.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 17.05.2022.
//

import UIKit

/// ViewController для экрана описания экскурсии
final class GuideScreenViewController: UIViewController {
    
    private let infoImage = UIImage(systemName: "info.circle")
    let indexOfSelectedItem: Int
    let textLoader: TextLoader
    var isFullVersion = false
    
    private lazy var guideScreenTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var excursionInfo: ExcursionInfo? {
        textLoader.loadExcursionInfoFor(index: indexOfSelectedItem)
    }
    
    private lazy var audioPlayerView: AudioPlayerView = {
        // TODO: Подставлять актуальное имя файла для каждого экрана
        let audioPlayerView = AudioPlayerView(audioFileName: "Tour1About")
        audioPlayerView.isHidden = true
        audioPlayerView.alpha = 0
        return audioPlayerView
    }()
    
    private lazy var tableViewToSuperViewBottomAnchor: NSLayoutConstraint = {
        guideScreenTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    }()
    
    private lazy var tableViewToAudioPlayerViewBottomAnchor: NSLayoutConstraint = {
        guideScreenTableView.bottomAnchor.constraint(equalTo: audioPlayerView.topAnchor, constant: -15)
    }()
    
    /// Инициализатор
    /// - Parameters:
    ///   - indexOfSelectedItem: индекс ячейки главного экрана, с которой совершен переход
    ///   - textLoader: экземпляр загрузчика текста из файла
    init(indexOfSelectedItem: Int, textLoader: TextLoader) {
        self.indexOfSelectedItem = indexOfSelectedItem
        self.textLoader = textLoader
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
        guideScreenTableView.backgroundColor = .white
        guideScreenTableView.separatorStyle = .none
        guideScreenTableView.register(UITableViewCell.self, forCellReuseIdentifier: "GuideTextCell")
        
        NSLayoutConstraint.activate([
            guideScreenTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            guideScreenTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            guideScreenTableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableViewToSuperViewBottomAnchor,
            
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
        guard let excursionInfo = excursionInfo else { return }
        
        let mapScreenViewController = MapScreenViewController(excursionInfo: excursionInfo)
        navigationController?.pushViewController(mapScreenViewController, animated: true)
    }
    
    private func hideAudioPlayerView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.audioPlayerView.alpha = 0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.audioPlayerView.isHidden = true
            self.tableViewToSuperViewBottomAnchor.isActive = true
            self.tableViewToAudioPlayerViewBottomAnchor.isActive = false
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
    
    @objc func purchaseButtonTapped() {
        guard let excursionInfo = excursionInfo else { return }
        
        let purchaseViewController = PurchaseViewController(excursionInfo: excursionInfo)
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
        cell.textLabel?.text = excursionInfo?.excursionDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let excursionInfo = excursionInfo else { return nil }
        let imageName = "Image\(indexOfSelectedItem + 1)"
        let headerView = GuideHeaderView(excursionInfo: excursionInfo, imageName: imageName, guideFeatureViewBuilder: GuideFeatureViewBuilder(excursionInfo: excursionInfo))
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
