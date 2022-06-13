//
//  File.swift
//  MobileAudioGuide
//
//  Created by Настя on 13.06.2022.
//

import Foundation
import MapboxMaps
import UIKit

final class OfflineManagerViewController: UIViewController {
    
    private var mapViewContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let myGeoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "geo"), for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    private var mapView: MapView?
    private var tileStore: TileStore?
    let excursionInfo: ExcursionInfo
    
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

    private let istanbulCoord = CLLocationCoordinate2D(latitude: 41.011225, longitude: 28.978151)
    private let istanbulZoom: CGFloat = 12
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
        
        state = .initial
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(mapViewContainer)
        view.addSubview(myGeoButton)

        mapViewContainer.translatesAutoresizingMaskIntoConstraints = false
        myGeoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapViewContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            mapViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            myGeoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            myGeoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            myGeoButton.heightAnchor.constraint(equalToConstant: 40),
            myGeoButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        downloadTileRegions()
        
        myGeoButton.addTarget(self, action: #selector(showMyGeo), for: .touchUpInside)
    }
    
    @objc func showMyGeo() {
        mapView?.location.options.puckType = .puck2D()
        if let locationCoordinate = mapView?.location.latestLocation?.coordinate {
            mapView?.mapboxMap.setCamera(to: CameraOptions(center: locationCoordinate, zoom: 15))
        }
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
        
        for tour in tours {
            var pointAnnotation = PointAnnotation(coordinate: CLLocationCoordinate2D(latitude: tour.latitude, longitude: tour.longitude))

            // Make the annotation show a red pin
            pointAnnotation.image = .init(image: UIImage(named: "mapbox-marker-icon-20px-blue")!, name: "mapbox-marker-icon-20px-blue")
            pointAnnotation.iconAnchor = .bottom
            points.append(pointAnnotation)
        }
        // Create the `PointAnnotationManager` which will be responsible for handling this annotation
        let pointAnnotationManager = mapView?.annotations.makePointAnnotationManager()
        // Add the annotation to the manager in order to render it on the map.
        pointAnnotationManager?.annotations = points

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

            var pointAnnotation = PointAnnotation(coordinate: self.istanbulCoord)
            //pointAnnotation.image = .init(image: UIImage(named: "custom_marker")!, name: "custom-marker")

            let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
            pointAnnotationManager.annotations = [pointAnnotation]
        }

        self.mapView = mapView
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
