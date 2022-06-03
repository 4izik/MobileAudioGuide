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
    
    private lazy var GuideScreenTableView: UITableView = {
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
        return audioPlayerView
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
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupViewController() {
        title = "Istanbul"
        view.backgroundColor = .white
    }
    
    private func setupTableView() {
        view.addSubview(GuideScreenTableView)
        GuideScreenTableView.translatesAutoresizingMaskIntoConstraints = false
        GuideScreenTableView.allowsSelection = false
        GuideScreenTableView.showsVerticalScrollIndicator = false
        GuideScreenTableView.backgroundColor = .white
        GuideScreenTableView.separatorStyle = .none
        GuideScreenTableView.register(UITableViewCell.self, forCellReuseIdentifier: "GuideTextCell")
        
        NSLayoutConstraint.activate([
            GuideScreenTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            GuideScreenTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            GuideScreenTableView.topAnchor.constraint(equalTo: view.topAnchor),
            GuideScreenTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        let infoScreenViewController = InfoScreenViewController()
        navigationController?.pushViewController(infoScreenViewController, animated: true)
    }
    
    @objc private func aboutExcursionButtonTapped() {
        switch view.subviews.contains(audioPlayerView) {
        case true: removeAudioPlayerView()
        case false: setupAudioPlayerView()
        }
    }
    
    private func removeAudioPlayerView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.audioPlayerView.alpha = 0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.audioPlayerView.removeFromSuperview()
        }
    }
    
    private func setupAudioPlayerView() {
        audioPlayerView.translatesAutoresizingMaskIntoConstraints = false
        audioPlayerView.alpha = 0
        view.addSubview(audioPlayerView)
        
        NSLayoutConstraint.activate([
            audioPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            audioPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            audioPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            audioPlayerView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.audioPlayerView.alpha = 1
        }
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
        return headerView
    }
}
