//
//  MapViewController.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 2/15/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit
import MapKit  //Handles all the maps for the app


class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let parkingSpots: [(String, CLLocationCoordinate2D)] = [
    
    ("Central London", CLLocationCoordinate2D(latitude: 51.509865, longitude: -0.118092)),
    ("Sommerset House", CLLocationCoordinate2D(latitude: 51.510995, longitude: -0.117136)),
    ("Transport Museum", CLLocationCoordinate2D(latitude: 51.512198, longitude: -0.120916)),
    ("Queens Building", CLLocationCoordinate2D(latitude: 51.523229, longitude: -0.040396)),
    ("Bancroft Road", CLLocationCoordinate2D(latitude: 51.523322, longitude: -0.042311)),
    ("Mile End Road", CLLocationCoordinate2D(latitude: 51.522608, longitude: -0.041428)),
    ]
    
    //Reference to our map view in the interface builder
    @IBOutlet weak var mapView: MKMapView!
    
    let network = Network()
    let locationManager = LocationManager()
    
    @IBOutlet weak var sessionsButton: UIButton!
   
    var selectedAnnotation: MKAnnotation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestPermission()
        locationManager.locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
        mapView.delegate = self
        
        for spot in parkingSpots {
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = spot.1
            
            annotation.title = spot.0
            
            mapView.addAnnotation(annotation)
        }
        
        sessionsButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          fetchActiveSessions()
    }
    
    func fetchActiveSessions() {
        
        let storageManager = StorageManager()
        
        let sessions = storageManager.fetchActiveSessions()
        
        sessionsButton.isHidden = sessions.isEmpty
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
        
        
        
        self.selectedAnnotation = view.annotation
        
        let storageManager = StorageManager()
        
        if let _ = storageManager.fetchCardDetails() {
            
            self.performSegue(withIdentifier: "ToBooking", sender: self)
        }
        
        else {
            
            let alert = UIAlertController(title: "No card registered", message: "You must register a card before continuing", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { (action) in
                
                self.performSegue(withIdentifier: "ToSettings", sender: self)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        
    }
    
    
    func fetchBookings() {
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToBooking" {
            
            let nav = segue.destination as? UINavigationController
            
            let vc = nav?.topViewController as? BookingViewController
            
            vc?.latitude = self.selectedAnnotation?.coordinate.latitude ?? 0
            
            vc?.longitude = self.selectedAnnotation?.coordinate.longitude ?? 0
            vc?.locationName = self.selectedAnnotation!.title! ?? ""
            
            vc?.onDismiss = {
                self.fetchBookings()
            }
        }
    }
}
