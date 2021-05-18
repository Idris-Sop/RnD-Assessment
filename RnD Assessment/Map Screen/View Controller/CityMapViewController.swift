//
//  CityMapViewController.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/17.
//

import UIKit
import MapKit

class CityMapViewController: BaseViewController {

    @IBOutlet private var mapView: MKMapView!
    private var selectedCity: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.centerToLocation(CLLocation(latitude: selectedCity?.cityCoordinate?.latitude ?? 0, longitude:  selectedCity?.cityCoordinate?.longitude ?? 0.0))
        let annotations = MKPointAnnotation()
        annotations.title = selectedCity?.cityName
        annotations.coordinate = CLLocationCoordinate2D(latitude: selectedCity?.cityCoordinate?.latitude ?? 0.0, longitude: selectedCity?.cityCoordinate?.longitude ?? 0.0)
        mapView.addAnnotation(annotations)
    }
    
    func setupPointAnnotationWith(city: City) {
        self.selectedCity = city
    }
}

private extension MKMapView {
    func centerToLocation( _ location: CLLocation, regionRadius: CLLocationDistance = 100000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
