//
//  locationManager.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 2/26/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit
import CoreLocation

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
