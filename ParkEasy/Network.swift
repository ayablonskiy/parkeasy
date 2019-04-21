//
//  Network.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 2/26/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit //Apple UI framework / library used for displaying UI elements and interacting with them
import CoreLocation //Apple library used for location services

class Network: NSObject {
    
    let londonCoordinates: CLLocationCoordinate2D =
        CLLocationCoordinate2DMake(51.509865, -0.118092)
    
    func fetchParkingSpot() {
//        
//        let urlSession = URLSession.shared.dataTask(with: <#T##URL#>) { (data, response, error) in
//            
//            guard error == nil else {
//                
//                return
//            }
//        }
        
    }

    
    func processParkingSpotsData() {
        
        
    }
}

struct ParkingSpot {
    let location: CLLocationCoordinate2D
    let price: CGFloat
    
    
}
