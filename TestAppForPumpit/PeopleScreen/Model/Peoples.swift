//
//  Peoples.swift
//  TestAppForPumpit
//
//  Created by Admin on 30.06.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import Foundation

class Peoples {
    var id: String
    var name: String
    var batteryLevel: String
    var status: String
    var photoURL: URL
    
    init(id: String, name: String, batteryLevel: String, status: String, photoURL: URL) {
        self.id = id
        self.name = name
        self.batteryLevel = batteryLevel
        self.status = status
        self.photoURL = photoURL
    }
}
