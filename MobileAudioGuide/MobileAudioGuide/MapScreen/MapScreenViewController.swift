//
//  MapScreenViewController.swift
//  MobileAudioGuide
//
//  Created by Настя on 31.05.2022.
//

import UIKit
import CoreLocation
import MapKit

class MapScreenViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    let mapScreenView = MapScreenView()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        setupViews()
        setupNavigationController()
        setupData()
    }
    
    private func setupViews() {
        title = "Istanbul"
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
    }
    
    private func setupNavigationController() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21, weight: .bold)
        ]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setupData() {
        // 1. check if system can monitor regions
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            // 2. region data
            let title = "Lorrenzillo' s"
            let coordinate = CLLocationCoordinate2DMake(37.703026, -121.759735)
            let regionRadius = 300.0

            // 3. setup region
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,longitude: coordinate.longitude), radius: regionRadius, identifier: title)

            // 4. setup annotation
            let restaurantAnnotation = MKPointAnnotation()
            restaurantAnnotation.coordinate = coordinate;
            restaurantAnnotation.title = "\(title)";
            self.mapScreenView.mapView.addAnnotation(restaurantAnnotation)

            // 5. setup circle
            let circle = MKCircle(center: coordinate, radius: 10)
            self.mapScreenView.mapView.addOverlay(circle)
        }
        else {
            print("System can't track regions")
        }

        // 6. draw circle
        func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.strokeColor = UIColor.red
            circleRenderer.lineWidth = 1.0
            return circleRenderer
        }
    }
}
