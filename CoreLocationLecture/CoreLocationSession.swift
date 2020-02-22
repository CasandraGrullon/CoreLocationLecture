//
//  CoreLocationSession.swift
//  CoreLocationLecture
//
//  Created by casandra grullon on 2/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {
  let title: String
  let body: String
  let coordinate: CLLocationCoordinate2D
  let imageName: String
  
  static func getLocations() -> [Location] {
    return [
      Location(title: "Pursuit", body: "We train adults with the most need and potential to get hired in tech, advance in their careers, and become the next generation of leaders in tech.", coordinate: CLLocationCoordinate2D(latitude: 40.74296, longitude: -73.94411), imageName: "team-6-3"),
      Location(title: "Brooklyn Museum", body: "The Brooklyn Museum is an art museum located in the New York City borough of Brooklyn. At 560,000 square feet (52,000 m2), the museum is New York City's third largest in physical size and holds an art collection with roughly 1.5 million works", coordinate: CLLocationCoordinate2D(latitude: 40.6712062, longitude: -73.9658193), imageName: "brooklyn-museum"),
      Location(title: "Central Park", body: "Central Park is an urban park in Manhattan, New York City, located between the Upper West Side and the Upper East Side. It is the fifth-largest park in New York City by area, covering 843 acres (3.41 km2). Central Park is the most visited urban park in the United States, with an estimated 37.5–38 million visitors annually, as well as one of the most filmed locations in the world.", coordinate: CLLocationCoordinate2D(latitude: 40.7828647, longitude: -73.9675438), imageName: "central-park")
    ]
  }
}

class CoreLocationSession: NSObject {
    //apple documentation states we need a strong reference to the CLLocation
    public var locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        //call super before calling self
        super.init()
        //without delegate you won't get updates on user's location
        locationManager.delegate = self
        
        //request the user's location
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        //the following keys need to be added to the info.plist file
        //NSLocationAlwaysAndWhenInUseUsageDescription
        //NSLocationWhenInUseUsageDescription
        
        //get updates for user location
        //most aggressive solution of gps data collection ==         locationManager.startUpdatingLocation()
        startSignificantLocationChanges()
        startMonitoringRegion()
    }
    
    private func startSignificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            //not available
            return
        }
        //less aggressive than .startUpdatingLocation
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    //CLLocationCoordinate2D is a struct that has two values (lat and long)
    public func convertCoordinateToPlacemark(coordinate: CLLocationCoordinate2D) {
        //create a CLLocation
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        //use the CLGeocoder() class to convert coordinate to a placemark
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("reverseGeocodeLocation error: \(error)")
            }
            if let firstPlacemark = placemarks?.first {
                print("placemark info \(firstPlacemark)")
            }
            
        }
    }
    
    public func convertPlaceNameToCoordinate(addressString: String) {
        //converting an address to a coordinate
        CLGeocoder().geocodeAddressString(addressString) { (placemarks, error) in
            if let error = error {
                print("geocodeAddressString error \(error) ")
            }
            if let firstPlaceMark = placemarks?.first,
                let location = firstPlaceMark.location {
                print("coordinate is \(location.coordinate)")
            }
        }
    }
    //monitor a CLRegion == made up of a central coordinate and a radius in meters
    private func startMonitoringRegion() {
        let location = Location.getLocations()[2]
        let identifier = "monitoring region"
        let region = CLCircularRegion(center: location.coordinate, radius: 500, identifier: identifier)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        locationManager.startMonitoring(for: region)
    }
}

extension CoreLocationSession: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations: \(locations)")
        //returns an array of locations, the last one is the most recent
        //different points in a route
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //current access to user location
        switch status {
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .denied:
            print("denied")
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        default: //at some future date, apple might add more cases so we need a default
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion: \(region)")
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion: \(region)")
    }
}
