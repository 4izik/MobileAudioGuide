//
//  CameraLocationConsumer.swift
//  MobileAudioGuide
//
//  Created by Настя on 13.06.2022.
//
import MapboxMaps

public class CameraLocationConsumer: LocationConsumer {
    weak var mapView: MapView?
 
    init(mapView: MapView) {
        self.mapView = mapView
    }
 
    public func locationUpdate(newLocation: Location) {
        mapView?.camera.ease(
            to: CameraOptions(center: newLocation.coordinate, zoom: 15),
            duration: 1.3)
    }
}
