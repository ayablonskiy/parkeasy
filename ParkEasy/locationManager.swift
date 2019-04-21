//
//  locationManager.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 2/26/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit //Apple UI framework / library used for displaying UI elements and interacting with them
import CoreLocation //Apple library used for location services

class LocationManager: NSObject {

    let locationManager = CLLocationManager()
    
    func requestPermission() {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            
            locationManager.requestWhenInUseAuthorization()
            
        default:
            
            break
        }        
    }
}
