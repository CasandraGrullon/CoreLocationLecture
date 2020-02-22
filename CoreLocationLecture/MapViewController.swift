//
//  ViewController.swift
//  CoreLocationLecture
//
//  Created by casandra grullon on 2/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationSession = CoreLocationSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //testing the convertCoordinateToPlacemark function
        convertCoordinateToPlacemark()
        //testing convertPlaceNameToCoordinate function
        convertPlaceNameToCoordinate()
        
        //configure map view
        //attempt to show user's current location if user location access is enabled
        mapView.showsUserLocation = true
        mapView.delegate = self
        loadMapView()
    }
    
    private func makeAnnotations() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()

        for location in Location.getLocations() {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = location.title
            annotations.append(annotation)
        }
        return annotations
    }

    private func loadMapView() {
        let annotations = makeAnnotations()
        mapView.addAnnotations(annotations)
        
        mapView.showAnnotations(annotations, animated: true)
    }
    
    private func convertCoordinateToPlacemark() {
        let location = Location.getLocations()[2]
        locationSession.convertCoordinateToPlacemark(coordinate: location.coordinate)
    }
    
    private func convertPlaceNameToCoordinate() {
        locationSession.convertPlaceNameToCoordinate(addressString: "Brooklyn Museum")
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("didselect")
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }
        let identifier = "location annotation"
        var annotationView: MKPinAnnotationView
        
        //try to dequeue and reuse annotation view
        //if it does exist
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            annotationView = dequeueView
        } else {
            //if it doesnt exist
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
        }
        return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
    }
}
