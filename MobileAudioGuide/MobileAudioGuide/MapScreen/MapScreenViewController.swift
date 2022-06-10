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
        navigationItem.title = excursionInfo.excursionTitle
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
        mapScreenView.imageView.image = UIImage(named: "Image1")
        mapScreenView.titleLabel.text = excursionInfo.excursionTitle
        mapScreenView.purchaseButton.addTarget(self, action: #selector(makePurchase), for: .touchUpInside)
    }
    
    @objc func makePurchase() {
        let purchaseViewController = PurchaseViewController(excursionInfo: excursionInfo)
        navigationController?.pushViewController(purchaseViewController, animated: true)
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
            let location = CLLocationCoordinate2D(latitude: 41.011225, longitude: 28.978151)
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
