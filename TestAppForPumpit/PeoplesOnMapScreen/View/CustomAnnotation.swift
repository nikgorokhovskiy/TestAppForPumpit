//
//  CustomAnnotation.swift
//  TestAppForPumpit
//
//  Created by Admin on 02.07.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import AddressBook

class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    let title: String?
    let annotationTitle: String
    init(coordinate: CLLocationCoordinate2D, title: String, annotationTitle: String = "") {
        self.coordinate = coordinate
        self.title = title
        self.annotationTitle = annotationTitle
    }
    
    
    
}
