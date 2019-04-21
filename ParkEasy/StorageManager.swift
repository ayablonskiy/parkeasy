//
//  StorageManager.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 2/28/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class StorageManager: NSObject {
    
    var realm: Realm!
    
    override init() {
        super.init()
        
        self.realm = try! Realm()
    }
    
    func saveCardDetails(card: CardDetails) {
        
        //delete all existing card details
        if let card = fetchCardDetails(){
            
            try! realm.write {
                realm.delete(card)
                
            }
        }
        
        try! realm.write {
            realm.add(card)
        }
        
    }
    
    func fetchCardDetails() -> CardDetails? {
        
        return realm.objects(CardDetails.self).first
    }

    func saveUserDetails(firstName: String, lastName: String, phoneNumber: String){
        
        let user = fetchUserDetails()
        
        try! realm.write {
            
            user.firstName = firstName
            user.lastName = lastName
            user.phoneNumber = phoneNumber
        }
    }
    
    func fetchUser() -> User? {
        
        return realm.objects(User.self).first
    }
    
    func fetchUserDetails() -> User {
        
        if let user = realm.objects(User.self).first {
            
            return user
        }
            
        else {
            
            let user = User()
            
            try! realm.write {
                realm.add(user)
            }
            
            return user
        }
    }
    
    func fetchMyVehicles() -> [Vehicle] {
        
        return Array(realm.objects(Vehicle.self))
    }
    
    func saveVehicle(vehicle: Vehicle) {
        
        try! realm.write {
            realm.add(vehicle)
            
        }
    }
    
    func deleteVehicle(vehicle: Vehicle) {
        
        try! realm.write {
            realm.delete(vehicle)
        }
    }
    
    func updateSession(licensePlate: String, endTime: Date) {
        
        guard let session = fetchActiveSessions().first(where: { $0.endTime == nil || $0.endTime! > Date() && $0.vehicleLicensePlate == licensePlate }) else {
            return
        }
        
        try! realm.write {
            session.endTime = endTime
            realm.add(session)
        }
    }
    
    func saveSession(session: Session) {

        try! realm.write {
            realm.add(session)
        }
    }
    
    func fetchActiveSessions() -> [Session] {
        
        let sessions = Array(realm.objects(Session.self))
        
        return sessions.filter({ $0.endTime == nil || $0.endTime! > Date() })
    }
}




class CardDetails: Object {
    
    @objc dynamic var cardHolderName: String = ""
    @objc dynamic var cardNumber: Int = 0
    @objc dynamic var expiryDateMonth: Int = 0
    @objc dynamic var expiryDateYear: Int = 0
    @objc dynamic var securityCOde: Int = 0
    
}

class User: Object{
    
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var phoneNumber: String = ""
    
    
}

class Vehicle: Object {
    
    
    @objc dynamic var licensePlate: String = ""
    @objc dynamic var vehicleModel: String = ""
    @objc dynamic var carMaker: String = ""
}

class Session: Object {
    
    @objc dynamic var vehicleLicensePlate: String = ""
    @objc dynamic var startTime: Date = Date()
    @objc dynamic var endTime: Date?
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var locationName: String = ""
    
    
}
