//
//  MapTilesLoader.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 20.07.2022.
//

import Foundation
import MapboxMaps

class MapTilesLoader {
    
    static let shared = MapTilesLoader()
    private init() {}
    
    private var tileStore: TileStore?
    private var downloads: [Cancelable] = []
    private let istanbulZoom: CGFloat = 13.2
    private let tileRegionId = "myTileRegion"
    private let loadedTilesKey = "MobileGuideTilesLoaded"
    var tilesLoaded: Bool { UserDefaults.standard.bool(forKey: loadedTilesKey) }
    var istanbulCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.0102, longitude: 28.9743)
    
    lazy var mapInitOptions: MapInitOptions = {
        MapInitOptions(cameraOptions: CameraOptions(center: istanbulCoord, zoom: istanbulZoom),
                       styleURI: .outdoors)
    }()
    
    lazy var offlineManager: OfflineManager = {
        return OfflineManager(resourceOptions: mapInitOptions.resourceOptions)
    }()
    
    var state: MapBoxDownloadState = .unknown {
        didSet {
            NSLog("Changing state from \(oldValue) -> \(state)")
            
            switch (oldValue, state) {
            case (_, .initial):
                let tileStore = TileStore.default
                let accessToken = ResourceOptionsManager.default.resourceOptions.accessToken
                tileStore.setOptionForKey(TileStoreOptions.mapboxAccessToken, value: accessToken)
                self.tileStore = tileStore
                OfflineSwitch.shared.isMapboxStackConnected = true
                
            case (.initial, .downloading):
                print("Start downloading")
            case (.downloading, .downloaded):
                OfflineSwitch.shared.isMapboxStackConnected = false
            case (.downloaded, .mapViewDisplayed):
                print("MapView can be displayed")
            case (.mapViewDisplayed, .finished), (.downloading, .finished):
                print("Finish downloading")
            case (_, .downloading):
                print("")
            case (_, .noConnection):
                print("No Internet connection")
            default:
                fatalError("Invalid transition from \(oldValue) to \(state)")
            }
        }
    }
    
    public func loadTiles() {
        guard NetworkService.isConnected() else {
            state = .noConnection
            return
        }
        guard let tileStore = tileStore else { preconditionFailure() }
        
        precondition(downloads.isEmpty)
        
        let dispatchGroup = DispatchGroup()
        var downloadError = false
        
        let stylePackLoadOptions = StylePackLoadOptions(glyphsRasterizationMode: .ideographsRasterizedLocally, metadata: ["tag": "my-outdoors-style-pack"])!
        dispatchGroup.enter()
        let stylePackDownload = offlineManager.loadStylePack(for: .outdoors, loadOptions: stylePackLoadOptions) { progress in
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
                    NSLog("StylePack download completed = \(stylePack)")
                case let .failure(error):
                    NSLog("stylePack download Error = \(error)")
                    downloadError = true
                }
            }
        }
        
        let outdoorsOptions = TilesetDescriptorOptions(styleURI: .outdoors, zoomRange: 14...16)
        let outdoorsDescriptor = offlineManager.createTilesetDescriptor(for: outdoorsOptions)
        
        let tileRegionLoadOptions = TileRegionLoadOptions(
            geometry: .point(Point(istanbulCoord)),
            descriptors: [outdoorsDescriptor],
            metadata: ["tag": "my-outdoors-tile-region"],
            acceptExpired: true)!
        
        dispatchGroup.enter()
        let tileRegionDownload = tileStore.loadTileRegion(forId: tileRegionId,
                                                          loadOptions: tileRegionLoadOptions) { (progress) in
            DispatchQueue.main.async { NSLog("\(progress)") }
        } completion: { result in
            DispatchQueue.main.async {
                defer { dispatchGroup.leave() }
                
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
                UserDefaults.standard.set(true, forKey: loadedTilesKey)
                state = .mapViewDisplayed
            }
        }
        
        downloads = [stylePackDownload, tileRegionDownload]
        state = .downloading
    }
}
