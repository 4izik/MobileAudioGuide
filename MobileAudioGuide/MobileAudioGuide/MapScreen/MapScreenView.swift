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
    
    let audioPlayerView: AudioPlayerView = {
        let audioPlayerView = AudioPlayerView(audioFileName: "Tour1About")
        return audioPlayerView
    }()
    
    private let purchaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let purchaseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.borderColor = Colors.vwBlueColor.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Buy full version", for: .normal)
        button.setTitleColor(Colors.vwBlueColor, for: .normal)
        return button
    }()
    
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let detailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("More", for: .normal)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(Colors.vwBlueColor, for: .normal)
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .close)
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
        purchaseView.addSubview(purchaseButton)
        
        [imageView, titleLabel, detailButton, closeButton].forEach { view in
            infoView.addSubview(view)
        }
        
        [mapView, myGeoButton, moreButton, audioPlayerView, purchaseView, infoView].forEach { view in
            addSubview(view)
        }

        applyUIConstraints()
    }

    // MARK: - Add constraints

    func applyUIConstraints() {
        [mapView, myGeoButton, moreButton, audioPlayerView, purchaseView, purchaseButton, infoView, imageView, titleLabel, detailButton, closeButton].forEach { view in
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
            moreButton.widthAnchor.constraint(equalToConstant: 40),
            
            purchaseView.rightAnchor.constraint(equalTo: rightAnchor),
            purchaseView.leftAnchor.constraint(equalTo: leftAnchor),
            purchaseView.bottomAnchor.constraint(equalTo: bottomAnchor),
            purchaseView.heightAnchor.constraint(equalToConstant: 90),
            
            purchaseButton.leftAnchor.constraint(equalTo: purchaseView.leftAnchor, constant: 20),
            purchaseButton.rightAnchor.constraint(equalTo: purchaseView.rightAnchor, constant: -20),
            purchaseButton.topAnchor.constraint(equalTo: purchaseView.topAnchor, constant: 10),
            purchaseButton.heightAnchor.constraint(equalToConstant: 40),
            
            audioPlayerView.rightAnchor.constraint(equalTo: rightAnchor),
            audioPlayerView.leftAnchor.constraint(equalTo: leftAnchor),
            audioPlayerView.bottomAnchor.constraint(equalTo: purchaseView.topAnchor),
            audioPlayerView.heightAnchor.constraint(equalToConstant: 70),
            
            infoView.rightAnchor.constraint(equalTo: rightAnchor),
            infoView.leftAnchor.constraint(equalTo: leftAnchor),
            infoView.bottomAnchor.constraint(equalTo: audioPlayerView.topAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 120),
            
            imageView.leftAnchor.constraint(equalTo: infoView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: infoView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            
            titleLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 70),
            
            detailButton.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 15),
            detailButton.widthAnchor.constraint(equalToConstant: 50),
            detailButton.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -10),
            detailButton.heightAnchor.constraint(equalToConstant: 40),
            
            closeButton.topAnchor.constraint(equalTo: infoView.topAnchor),
            closeButton.rightAnchor.constraint(equalTo: infoView.rightAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

