//
//  MapScreenViewController.swift
//  MobileAudioGuide
//
//  Created by Настя on 31.05.2022.
//

import UIKit
import CoreLocation
import MapKit

class MapScreenViewController: UIViewController, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    let mapScreenView = MapScreenView()
    // Менять selectedPointNumber при выборе новой точки и обновлять данные во вьюхах
    var selectedPointNumber = 1
    private var excursionInfo = ExcursionInfo()
    
    init(excursionInfo: ExcursionInfo) {
        self.excursionInfo = excursionInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Initializing from Storyboard isn't supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationManager()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationEnabled()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = excursionInfo.shortTitle
    }
    
    private func setupViews() {
        navigationController?.navigationBar.topItem?.title = ""
        view.addSubview(mapScreenView)
        view.backgroundColor = .white

        mapScreenView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            mapScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapScreenView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapScreenView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        mapScreenView.mapView.delegate = self
        mapScreenView.imageView.image = UIImage(named: excursionInfo.filenamePrefix + String(selectedPointNumber))
        if excursionInfo.tours.indices.contains(selectedPointNumber - 1) {
            mapScreenView.titleLabel.text = excursionInfo.tours[selectedPointNumber - 1].tourTitle
        }
        
        mapScreenView.purchaseButton.addTarget(self, action: #selector(makePurchase), for: .touchUpInside)
        mapScreenView.detailButton.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
        mapScreenView.moreButton.addTarget(self, action: #selector(showRouteScreen), for: .touchUpInside)
    }
    
    @objc private func makePurchase() {
        let purchaseViewController = PurchaseViewController(excursionInfo: excursionInfo)
        navigationController?.pushViewController(purchaseViewController, animated: true)
    }
    
    @objc private func showDetails() {
        let detailsViewController = DetailsScreenViewController(excursionInfo: excursionInfo, viewpointIndex: selectedPointNumber)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    @objc private func showRouteScreen() {
        let routeViewController = RouteViewController(excursionInfo: excursionInfo)
        navigationController?.pushViewController(routeViewController, animated: true)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkAuthorization()
            mapScreenView.mapView.showsUserLocation = true
            let location = CLLocationCoordinate2D(latitude: excursionInfo.mapScreenCoordinates.latitude,
                                                  longitude: excursionInfo.mapScreenCoordinates.longitude)
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapScreenView.mapView.setRegion(region, animated: true)
        } else {
            showAlertLocation(title: "Your location service is turned off", message: "Do you want to enable?", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
        }
    }
    
    private func checkAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func showAlertLocation(title: String, message: String, url: URL?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "Settings", style: .default) { (alert) in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(settingAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
extension MapScreenViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapScreenView.mapView.setRegion(region, animated: true)
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
}
