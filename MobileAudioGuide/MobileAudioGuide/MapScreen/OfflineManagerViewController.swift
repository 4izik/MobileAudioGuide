//
//  File.swift
//  MobileAudioGuide
//
//  Created by Настя on 13.06.2022.
//

import Foundation
import MapboxMaps
import UIKit
import Turf

final class OfflineManagerViewController: UIViewController {
    
    private var mapViewContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.isHidden = false
        indicator.startAnimating()
        return indicator
    }()
    
    private let myGeoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "geo"), for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "more"), for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    private let mapFooterView = MapFooterView()
    
    private var mapView: MapView?
    private var tileStore: TileStore?
    let excursionInfo: ExcursionInfo
    private var isFullVersionPurchased = false
    private var selectedIndex = 0
    private var markers: [UIImage] = []
    
    init(excursionInfo: ExcursionInfo) {
        self.excursionInfo = excursionInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var mapInitOptions: MapInitOptions = {
        MapInitOptions(cameraOptions: CameraOptions(center: istanbulCoord, zoom: istanbulZoom),
                       styleURI: .outdoors)
    }()

    private lazy var offlineManager: OfflineManager = {
        return OfflineManager(resourceOptions: mapInitOptions.resourceOptions)
    }()

    // Regions and style pack downloads
    private var downloads: [Cancelable] = []

    private var istanbulCoord = CLLocationCoordinate2D(latitude: 41.011225, longitude: 28.978151)
    private let istanbulZoom: CGFloat = 13
    private let tileRegionId = "myTileRegion"

    private enum State {
        case unknown
        case initial
        case downloading
        case downloaded
        case mapViewDisplayed
        case finished
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let index = excursionInfo.tours.count / 2
        istanbulCoord = CLLocationCoordinate2D(latitude: excursionInfo.tours[index].latitude, longitude: excursionInfo.tours[index].longitude)
        state = .initial
        setupImage()
        setupUI()
    }
    
    func setupUI() {
        [activityIndicator,mapViewContainer, myGeoButton, moreButton, mapFooterView].forEach { view in
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        mapFooterView.alpha = 0
        mapFooterView.isHidden = true

        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            mapViewContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            mapViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            myGeoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            myGeoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            myGeoButton.heightAnchor.constraint(equalToConstant: 40),
            myGeoButton.widthAnchor.constraint(equalToConstant: 40),
            
            moreButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            moreButton.topAnchor.constraint(equalTo: myGeoButton.bottomAnchor, constant: 20),
            moreButton.heightAnchor.constraint(equalToConstant: 40),
            moreButton.widthAnchor.constraint(equalToConstant: 40),
            
            mapFooterView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapFooterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapFooterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapFooterView.heightAnchor.constraint(equalToConstant: 300),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
        downloadTileRegions()
    
        myGeoButton.addTarget(self, action: #selector(showMyGeo), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(showAllTour), for: .touchUpInside)
    }
    
    private func setupImage() {
        for index in 0..<excursionInfo.tours.count {
            var image = UIImage()
            if !isFullVersionPurchased && index > 4 {
                image = textToImage(drawText: NSString(string: "\(index + 1)"), inImage: UIImage(named: "mapbox-marker-icon-20px-gray")!)
            } else {
                image = textToImage(drawText: NSString(string: "\(index + 1)"), inImage: UIImage(named: "mapbox-marker-icon-20px-blue")!)
            }
            markers.append(image)
        }
    }
    
    @objc func showMyGeo() {
        mapView?.location.options.puckType = .puck2D()
        if let locationCoordinate = mapView?.location.latestLocation?.coordinate {
            mapView?.mapboxMap.setCamera(to: CameraOptions(center: locationCoordinate, zoom: 15))
        }
    }
    
    @objc func showAllTour() {
        let routeViewController = RouteViewController(excursionInfo: excursionInfo)
        navigationController?.pushViewController(routeViewController, animated: true)
    }
    // MARK: - Actions
    private func downloadTileRegions() {
        guard let tileStore = tileStore else {
            preconditionFailure()
        }

        precondition(downloads.isEmpty)

        let dispatchGroup = DispatchGroup()
        var downloadError = false

        // Create style package with loadStylePack() call.
        let stylePackLoadOptions = StylePackLoadOptions(glyphsRasterizationMode: .ideographsRasterizedLocally,
                                                        metadata: ["tag": "my-outdoors-style-pack"])!

        dispatchGroup.enter()
        let stylePackDownload = offlineManager.loadStylePack(for: .outdoors, loadOptions: stylePackLoadOptions) { progress in
            NSLog("StylePack = \(progress)")
            DispatchQueue.main.async {
                NSLog("StylePack = \(progress)")
            }
        } completion: { result in
            DispatchQueue.main.async {
                defer {
                    dispatchGroup.leave()
                }

                switch result {
                case let .success(stylePack):
                    NSLog("StylePack = \(stylePack)")
                case let .failure(error):
                    NSLog("stylePack download Error = \(error)")
                    downloadError = true
                }
            }
        }
        // Create an offline region with tiles for the outdoors style
        let outdoorsOptions = TilesetDescriptorOptions(styleURI: .outdoors,
                                                       zoomRange: 10...16)

        let outdoorsDescriptor = offlineManager.createTilesetDescriptor(for: outdoorsOptions)

        // Load the tile region
        let tileRegionLoadOptions = TileRegionLoadOptions(
            geometry: .point(Point(istanbulCoord)),
            descriptors: [outdoorsDescriptor],
            metadata: ["tag": "my-outdoors-tile-region"],
            acceptExpired: true)!

        dispatchGroup.enter()
        let tileRegionDownload = tileStore.loadTileRegion(forId: tileRegionId,
                                                          loadOptions: tileRegionLoadOptions) { (progress) in
            DispatchQueue.main.async {
                NSLog("\(progress)")
            }
        } completion: { result in
            DispatchQueue.main.async {
                defer {
                    dispatchGroup.leave()
                }

                switch result {
                case let .success(tileRegion):
                    NSLog("tileRegion = \(tileRegion)")

                case let .failure(error):
                    NSLog("tileRegion download Error = \(error)")
                    downloadError = true
                }
            }
        }

        // Wait for both downloads before moving to the next state
        dispatchGroup.notify(queue: .main) { [self] in
            self.downloads = []
            self.state = downloadError ? .finished : .downloaded
            if state == .downloaded {
                state = .mapViewDisplayed
            }
        }
        
        downloads = [stylePackDownload, tileRegionDownload]
        state = .downloading
    }

    private func cancelDownloads() {
        // Canceling will trigger `.canceled` errors that will then change state
        downloads.forEach { $0.cancel() }
    }
    
    private func addMarkersOnMap() {
        let tours = excursionInfo.tours
        var points: [PointAnnotation] = []
    
        for (index,tour) in tours.enumerated() {
            var pointAnnotation = PointAnnotation(coordinate: CLLocationCoordinate2D(latitude: tour.latitude, longitude: tour.longitude))
            if !isFullVersionPurchased && index > 4 {
                pointAnnotation.image = .init(image: markers[index], name: "marker \(index)")
            } else {
                pointAnnotation.image = .init(image: markers[index], name: "marker \(index)")
            }
            pointAnnotation.iconAnchor = .bottom
            pointAnnotation.userInfo = ["number" : index]
            points.append(pointAnnotation)
        }
        // Create the `PointAnnotationManager` which will be responsible for handling this annotation
        let pointAnnotationManager = mapView?.annotations.makePointAnnotationManager()
        // Add the annotation to the manager in order to render it on the map.
        pointAnnotationManager?.annotations = points
        pointAnnotationManager?.delegate = self
    }
    
    private func textToImage(drawText text: NSString, inImage image: UIImage) -> UIImage {
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        let font = UIFont.systemFont(ofSize: 14)
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = NSTextAlignment.center

        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paraStyle]
        let height = font.lineHeight
        let y = (image.size.height-height) / 2
        let strRect = CGRect(x: 0, y: y, width: image.size.width, height: height)
        text.draw(in: strRect.integral, withAttributes: attributes)

        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage()}
        UIGraphicsEndImageContext()

        return result
    }
    
    private func setFooterView(number: Int) {
        mapFooterView.imageView.image = UIImage(named: excursionInfo.filenamePrefix + String(number))
        mapFooterView.titleLabel.text = excursionInfo.tours[number].tourTitle
        mapFooterView.audioPlayerView = AudioPlayerView(audioFileName: excursionInfo.filenamePrefix + String(number))
        mapFooterView.purchaseButton.addTarget(self, action: #selector(showPurchaseScreen), for: .touchUpInside)
        mapFooterView.closeButton.addTarget(self, action: #selector(hideMapFooterView), for: .touchUpInside)
        mapFooterView.detailButton.addTarget(self, action: #selector(showDetailScreen), for: .touchUpInside)
        selectedIndex = number
    }

    private func logDownloadResult<T, Error>(message: String, result: Result<[T], Error>) {
        switch result {
        case let .success(array):
            NSLog(message)
            for element in array {
                NSLog("\t\(element)")
            }

        case let .failure(error):
            NSLog("\(message) \(error)")
        }
    }

    private func downloadedRegions() {
        guard let tileStore = tileStore else {
            preconditionFailure()
        }

        offlineManager.allStylePacks { result in
            self.logDownloadResult(message: "Style packs:", result: result)
        }

        tileStore.allTileRegions { result in
            self.logDownloadResult(message: "Tile regions:", result: result)
        }
    }

    // Remove downloaded region and style pack
    private func removeTileRegionAndStylePack() {
        tileStore?.removeTileRegion(forId: tileRegionId)
        tileStore?.setOptionForKey(TileStoreOptions.diskQuota, value: 0)
        offlineManager.removeStylePack(for: .outdoors)
    }

    // MARK: - State changes
    @objc func didTapButton(_ button: UIButton) {
        switch state {
        case .unknown:
            state = .initial
        case .initial:
            downloadTileRegions()
        case .downloading:
            // Cancel
            cancelDownloads()
        case .downloaded:
            state = .mapViewDisplayed
        case .mapViewDisplayed:
            downloadedRegions()
            state = .finished
        case .finished:
            removeTileRegionAndStylePack()
            downloadedRegions()
            state = .initial
        }
    }

    private var state: State = .unknown {
        didSet {
            NSLog("Changing state from \(oldValue) -> \(state)")

            switch (oldValue, state) {
            case (_, .initial):
                resetUI()

                let tileStore = TileStore.default
                let accessToken = ResourceOptionsManager.default.resourceOptions.accessToken
                tileStore.setOptionForKey(TileStoreOptions.mapboxAccessToken, value: accessToken)

                self.tileStore = tileStore

                OfflineSwitch.shared.isMapboxStackConnected = true

            case (.initial, .downloading):
                // Can cancel
                print("Start downloading")
            case (.downloading, .downloaded):
                OfflineSwitch.shared.isMapboxStackConnected = false

            case (.downloaded, .mapViewDisplayed):
                showMapView()
                addLinesOnMap()
                addMarkersOnMap()

            case (.mapViewDisplayed, .finished),
                 (.downloading, .finished):
                print("Finish downloading")

            default:
                fatalError("Invalid transition from \(oldValue) to \(state)")
            }
        }
    }

    // MARK: - UI changes
    private func resetUI() {
        mapView?.removeFromSuperview()
        mapView = nil
    }

    private func showMapView() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        let mapView = MapView(frame: mapViewContainer.bounds, mapInitOptions: mapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapViewContainer.addSubview(mapView)

        // Add a point annotation that shows the point geometry that were passed
        // to the tile region API.
        mapView.mapboxMap.onNext(.styleLoaded) { [weak self] _ in
            guard let self = self,
                  let mapView = self.mapView else {
                return
            }

            let pointAnnotation = PointAnnotation(coordinate: self.istanbulCoord)

            let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
            pointAnnotationManager.annotations = [pointAnnotation]
        }

        self.mapView = mapView
    }
    
    @objc func showPurchaseScreen() {
        let purchaseViewController = PurchaseViewController(excursionInfo: excursionInfo)
        navigationController?.pushViewController(purchaseViewController, animated: true)
    }
    
    @objc func hideMapFooterView() {
        mapFooterView.isHidden = true
        mapFooterView.alpha = 0
    }
    
    @objc func showDetailScreen() {
        let detailScreenViewController = DetailsScreenViewController(excursionInfo: excursionInfo, viewpointIndex: selectedIndex)
        navigationController?.pushViewController(detailScreenViewController, animated: true)
    }
    
    private func addLinesOnMap() {
        let tours = excursionInfo.tours
        var lines: [PolylineAnnotation] = []
    
        for i in 0..<tours.count-1 {
            let lineCoordinates = [
                CLLocationCoordinate2DMake(tours[i].latitude, tours[i].longitude),
                CLLocationCoordinate2DMake(tours[i+1].latitude, tours[i+1].longitude)
            ]

            // Create the line annotation.
            var lineAnnotation = PolylineAnnotation(lineCoordinates: lineCoordinates)
            lineAnnotation.lineColor = StyleColor(.systemBlue)
            lines.append(lineAnnotation)
        }
        // Create the `PolylineAnnotationManager` which will be responsible for handling this annotation
        let lineAnnnotationManager = mapView?.annotations.makePolylineAnnotationManager()

        // Add the annotation to the manager.
        lineAnnnotationManager?.annotations = lines
    }
}

extension OfflineManagerViewController: AnnotationInteractionDelegate {
    public func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        guard let number = annotations.last?.userInfo?["number"] as? Int else { return }
        if !isFullVersionPurchased && number > 4 {
            mapFooterView.isHidden = false
            showPurchaseScreen()
        } else {
            setFooterView(number: number)
            mapFooterView.isHidden = false
            UIView.animate(withDuration: 0.3) { [self] in
                mapFooterView.alpha = 1
            }
        }
    }
}

// MARK: - Convenience classes for tile and style classes
extension TileRegionLoadProgress {
    public override var description: String {
        "TileRegionLoadProgress: \(completedResourceCount) / \(requiredResourceCount)"
    }
}

extension StylePackLoadProgress {
    public override var description: String {
        "StylePackLoadProgress: \(completedResourceCount) / \(requiredResourceCount)"
    }
}

extension TileRegion {
    public override var description: String {
        "TileRegion \(id): \(completedResourceCount) / \(requiredResourceCount)"
    }
}

extension StylePack {
    public override var description: String {
        "StylePack \(styleURI): \(completedResourceCount) / \(requiredResourceCount)"
    }
}
