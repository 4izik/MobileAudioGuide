import UIKit
import MapKit

class MapScreenView: UIView {
    // MARK: - Definition UIElements
    let mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        return map
    }()
    
    let myGeoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "geo"), for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "more"), for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    init() {
        super.init(frame: UIScreen.main.bounds)
        setupViews()
    }

    // MARK: - Setup View

    private func setupViews() {
        [mapView, myGeoButton, moreButton].forEach { view in
            addSubview(view)
        }

        applyUIConstraints()
    }

    // MARK: - Add constraints

    func applyUIConstraints() {
        [mapView, myGeoButton, moreButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: leftAnchor),
            mapView.rightAnchor.constraint(equalTo: rightAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            myGeoButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
            myGeoButton.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            myGeoButton.heightAnchor.constraint(equalToConstant: 40),
            myGeoButton.widthAnchor.constraint(equalToConstant: 40),
            
            moreButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
            moreButton.topAnchor.constraint(equalTo: myGeoButton.bottomAnchor, constant: 20),
            moreButton.heightAnchor.constraint(equalToConstant: 40),
            moreButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}

