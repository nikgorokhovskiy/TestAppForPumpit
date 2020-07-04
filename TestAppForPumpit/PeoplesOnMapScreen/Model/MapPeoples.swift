//
//  MapPeoples.swift
//  TestAppForPumpit
//
//  Created by Admin on 02.07.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import Foundation
import MapKit
import FirebaseDatabase

class MapPeoples: NSObject, MKAnnotation {
    
    let id: String?
    let name: String? //username
    let status: String?
    let batteryLevel: String?
    let photoURL: URL?
    let coordinate: CLLocationCoordinate2D
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return status
    }
    
    var markerTintColor: UIColor {
        return .white
    }
    
    init(
        id: String?,
        name: String?,
        status: String?,
        batteryLevel: String?,
        photoURL: URL?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.batteryLevel = batteryLevel
        self.photoURL = photoURL
        self.coordinate = coordinate
        
        super.init()
    }
    
    
    init?(feature: MKGeoJSONFeature) {
        guard
            let point = feature.geometry.first as? MKPointAnnotation,
            let propertiesData = feature.properties,
            let json = try? JSONSerialization.jsonObject(with: propertiesData),
            let properties = json as? [String:Any]
            else {
            return nil
        }
        
        
        id = properties["id"] as? String
        name = properties["name"] as? String
        status = properties["status"] as? String
        batteryLevel = properties["batteryLevel"] as? String
        guard let url = properties["photo"] as? String else { return nil }
        photoURL = URL(string: url)
        coordinate = point.coordinate
        super.init()
    }
}
