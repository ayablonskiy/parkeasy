//
//  MapViewController.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 2/15/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit
import MapKit  //Handles all the maps for the app


class MapViewController: UIViewController {
    
    //Reference to our map view in the interface builder
    @IBOutlet weak var mapVIew: MKMapView!
    
    
    let network = Network()
    let locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestPermission()
        locationManager.locationManager.startUpdatingLocation()
        
        mapVIew.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.509865, longitude: -0.118092)
        
        annotation.title = "Random Spot"
      
        
        mapVIew.addAnnotation(annotation)
    }

    func setupSearchController(){
        
        let searchController = UISearchController(searchResultsController: self)
        searchController.delegate = self
        
        navigationItem.titleView = searchController.searchBar
    
    }
}

extension MapViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
//Externsion of view controller which complies with MMapViewDelegate protocol
//We will be implementing delegate in this extension
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        for view  in views {
            
            view.canShowCallout = true
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        network.fetchParkingSpot()
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        
    }
    
}
