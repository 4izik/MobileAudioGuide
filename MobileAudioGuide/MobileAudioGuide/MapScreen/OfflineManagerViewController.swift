//
//  File.swift
//  MobileAudioGuide
//
//  Created by Настя on 13.06.2022.
//

import MapboxMaps
import UIKit

final class OfflineManagerViewController: UIViewController {
    
    private let excursionInfo: ExcursionInfo
    private let excursionIndex: Int
    private let mapFooterView = MapFooterView()
    private var markers: [UIImage] = []
    private var mapView: MapView?
    private let istanbulZoom: CGFloat = 13.2
    
    private var mapInitOptions: MapInitOptions {
        MapInitOptions(cameraOptions: CameraOptions(center: istanbulCoord, zoom: istanbulZoom), styleURI: .outdoors)
    }
    
    private lazy var istanbulCoord = CLLocationCoordinate2D(latitude: excursionInfo.mapScreenCoordinates.latitude, longitude: excursionInfo.mapScreenCoordinates.longitude)
    
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
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "more"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()
    
    /// Приобретена ли полная версия для этой экскурсии
    var isFullVersion: Bool {
        PurchaseManager.shared.isProductPurchased(withIdentifier: excursionIndex.getProductIdentifier())
    }
    
    /// Индекс проигрываемого на данный момент аудиофайла
    var indexOfNowPlayingFile: Int? {
        guard let nowPlayingFileName = AudioPlayer.shared.nowPlayingFileName,
              let nowPlayingAudioNumberString = nowPlayingFileName.components(separatedBy: excursionInfo.filenamePrefix).last,
              let nowPlayingAudioNumber = Int(nowPlayingAudioNumberString)
        else { return nil }
        return nowPlayingAudioNumber
    }
    // MARK: - init()
    init(excursionInfo: ExcursionInfo, excursionIndex: Int) {
        self.excursionInfo = excursionInfo
        self.excursionIndex = excursionIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage()
        setupUI()
        showMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = excursionInfo.shortTitle
        mapFooterView.updateAudioPlayerView()
        updateMapFooterView()
    }
    
    func setupUI() {
        navigationController?.navigationBar.topItem?.title = ""
        [activityIndicator, mapViewContainer, myGeoButton, moreButton, mapFooterView].forEach { view in
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
        
        myGeoButton.addTarget(self, action: #selector(showMyGeo), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(showAllTour), for: .touchUpInside)
    }
    
    private func setupImage() {
        for index in 0..<excursionInfo.tours.count {
            var image = UIImage()
            if !isFullVersion && index > 4 {
                image = textToImage(drawText: NSString(string: "\(index + 1)"), inImage: UIImage(named: "mapbox-marker-icon-20px-gray")!)
            } else {
                image = textToImage(drawText: NSString(string: "\(index + 1)"), inImage: UIImage(named: "mapbox-marker-icon-20px-blue")!)
            }
            markers.append(image)
        }
    }
    
    // MARK: - Load GeoJSON file from local bundle and decode into a `Feature`.
    private func decodeGeoJSON(from fileName: String) throws -> Feature? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "geojson") else {
            preconditionFailure("File '\(fileName)' not found.")
        }
        let filePath = URL(fileURLWithPath: path)
        var feature: Feature?
        do {
            let data = try Data(contentsOf: filePath)
            feature = try JSONDecoder().decode(Feature.self, from: data)
        } catch {
            print("Error parsing data: \(error)")
        }
        return feature
    }
    
    // MARK: - Draw the route path.
    private func addLine() {
        guard let feature = try? decodeGeoJSON(from: excursionInfo.filenamePrefix) else { return }
        let geoJSONDataSourceIdentifier = "geoJSON-data-source"
        
        var geoJSONSource = GeoJSONSource()
        geoJSONSource.data = .feature(feature)
        
        var lineLayer = LineLayer(id: "line-layer")
        lineLayer.source = geoJSONDataSourceIdentifier
        lineLayer.lineColor = .constant(StyleColor(Colors.appAccentColor))
        lineLayer.lineWidth = .constant(2)
        lineLayer.lineCap = .constant(.round)
        lineLayer.lineJoin = .constant(.round)
        
        guard let mapView = mapView else { return }
        do {
            try mapView.mapboxMap.style.addSource(geoJSONSource, id: geoJSONDataSourceIdentifier)
            try mapView.mapboxMap.style.addLayer(lineLayer)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func showMyGeo() {
        mapView?.location.options.puckType = .puck2D()
        if let locationCoordinate = mapView?.location.latestLocation?.coordinate {
            mapView?.mapboxMap.setCamera(to: CameraOptions(center: locationCoordinate, zoom: 15))
        }
    }
    
    @objc func showAllTour() {
        let routeViewController = RouteViewController(excursionInfo: excursionInfo, excursionIndex: excursionIndex)
        navigationController?.pushViewController(routeViewController, animated: true)
    }
    
    // MARK: - Actions
    
    private func addMarkersOnMap() {
        let tours = excursionInfo.tours
        var points: [PointAnnotation] = []
        
        for (index,tour) in tours.enumerated() {
            var pointAnnotation = PointAnnotation(coordinate: CLLocationCoordinate2D(latitude: tour.latitude, longitude: tour.longitude))
            if !isFullVersion && index > 4 {
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
        mapFooterView.imageView.image = UIImage(named: excursionInfo.filenamePrefix + String(number + 1))
        mapFooterView.titleLabel.text = excursionInfo.tours[number].tourTitle
        mapFooterView.audioPlayerView.playButtonTappedFor(filename: excursionInfo.filenamePrefix + String(number + 1))
        mapFooterView.audioPlayerView.playButtonTapped()
        mapFooterView.purchaseButton.addTarget(self, action: #selector(showPurchaseScreen), for: .touchUpInside)
        mapFooterView.closeButton.addTarget(self, action: #selector(hideMapFooterView), for: .touchUpInside)
        mapFooterView.detailButton.addTarget(self, action: #selector(showDetailScreen), for: .touchUpInside)
    }
    
    
    
    // MARK: - UI changes
    
    private func showMapView() {
        if !MapTilesLoader.shared.tilesLoaded && MapTilesLoader.shared.state != .downloading { MapTilesLoader.shared.loadTiles() }
        guard MapTilesLoader.shared.state != .noConnection || MapTilesLoader.shared.tilesLoaded else {
            AlertService().presentAlert(title: "No Internet connection",
                                        message: """
                                                     
                                                     Map needs to be downloaded once to appear on screen.
                                                     
                                                     Please turn on your Internet connection. Once map data is downloaded you won't need Internet connection in the future.
                                                     """,
                                        in: self)
            return
        }
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        let mapView = MapView(frame: mapViewContainer.bounds, mapInitOptions: mapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapViewContainer.addSubview(mapView)
        
        mapView.mapboxMap.onNext(.styleLoaded) { [weak self] _ in
            guard let self = self,
                  let mapView = self.mapView else {
                return
            }
            
            let pointAnnotation = PointAnnotation(coordinate: self.istanbulCoord)
            
            let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
            pointAnnotationManager.annotations = [pointAnnotation]
            self.addLine()
            self.addMarkersOnMap()
        }
        
        self.mapView = mapView
    }
    
    private func updateMapFooterView() {
        guard let indexOfNowPlayingFile = indexOfNowPlayingFile,
              AudioPlayer.shared.nowPlayingFileName != excursionInfo.filenamePrefix + "0" else {
            mapFooterView.isHidden = true
            return
        }
        mapFooterView.isHidden = false
        mapFooterView.imageView.image = UIImage(named: excursionInfo.filenamePrefix + String(indexOfNowPlayingFile))
        mapFooterView.titleLabel.text = excursionInfo.tours[indexOfNowPlayingFile - 1].tourTitle
        mapFooterView.purchaseButton.addTarget(self, action: #selector(showPurchaseScreen), for: .touchUpInside)
        mapFooterView.closeButton.addTarget(self, action: #selector(hideMapFooterView), for: .touchUpInside)
        mapFooterView.detailButton.addTarget(self, action: #selector(showDetailScreen), for: .touchUpInside)
    }
    
    @objc func showPurchaseScreen() {
        let purchaseViewController = PurchaseViewController(excursionInfo: excursionInfo, excursionIndex: excursionIndex)
        navigationController?.pushViewController(purchaseViewController, animated: true)
    }
    
    @objc func hideMapFooterView() {
        mapFooterView.isHidden = true
    }
    
    @objc func showDetailScreen() {
        guard let indexOfNowPlayingFile = indexOfNowPlayingFile else { return }
        let detailScreenViewController = DetailsScreenViewController(excursionInfo: excursionInfo, viewpointIndex: indexOfNowPlayingFile)
        navigationController?.pushViewController(detailScreenViewController, animated: true)
    }
}

extension OfflineManagerViewController: AnnotationInteractionDelegate {
    public func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        guard let number = annotations.last?.userInfo?["number"] as? Int else { return }
        if !isFullVersion && number > 4 {
            mapFooterView.isHidden = true
            showPurchaseScreen()
        } else {
            setFooterView(number: number)
            mapFooterView.isHidden = false
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
