//
//  PeoplesOnMapViewController.swift
//  TestAppForPumpit
//
//  Created by Admin on 30.06.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit
import MapKit

class PeoplesOnMapViewController: UIViewController {

//MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!

//MARK: - Attributes
    private let locationManager = CLLocationManager()
    
//MARK: - Body
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAnnotations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkLocationEnabled()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func addAnnotations() {
        
        var peoples: [[String:String]] = []
        var marks: [MKPointAnnotation] = []
        
        let uid0 = ["latitude": "56.835079", "longitude": "60.609401", "name":"Shepard"]
        peoples.append(uid0)
        let uid1 = ["latitude": "56.840197", "longitude": "60.611032", "name":"Garrus"]
        peoples.append(uid1)
        let uid2 = ["latitude": "56.825452", "longitude": "60.603478", "name":"Suzi"]
        peoples.append(uid2)
        let uid3 = ["latitude": "56.833107", "longitude": "60.591205", "name":"Liara"]
        peoples.append(uid3)
        
        for mark in peoples {
            if let name = mark["name"],
                let latitudeString = mark["latitude"],
                let longitudeString = mark["longitude"] {
                    let mapAnnotation = MKPointAnnotation()
                    mapAnnotation.title = name
                guard let latitude = Double(latitudeString), let longitude = Double(longitudeString) else { return }
                    mapAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marks.append(mapAnnotation)
            }
        }
        mapView.addAnnotations(marks)
    }
    
    func checkLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupMapManager()
            checkAccessToGeolocation()
        } else {
            showAlertLocation(
                title: "На вашем устройстве выключена служба геолокации",
                message: "Хотите включить?",
                url: URL(string: "App-Prefs:root=LOCATION_SERVICES")
            )
        }
    }
    
    //настройка параметров
    func setupMapManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy  = kCLLocationAccuracyBest //точность определения местоположения
    }
    
    
//получение разрешения пользователя для определения его метоположения
    func checkAccessToGeolocation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = false
            locationManager.startUpdatingLocation()
            break
        case .denied:
            showAlertLocation(
                title: "Необходимо разрешить определение Вашего местоположения, иначе приложение не сможет определить где вы находитесь",
                message: "Хотите исправить?",
                url: URL(string: UIApplication.openSettingsURLString)
            )
            break
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
//вызов оповещения
    func showAlertLocation(title: String, message: String?, url: URL?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}

extension PeoplesOnMapViewController: CLLocationManagerDelegate {
    
        //MARK: - LOCATION MANAGER DELEGATE
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last?.coordinate {
                let region = MKCoordinateRegion(center: location, latitudinalMeters: 3000, longitudinalMeters: 3000)
                mapView.setRegion(region, animated: true)
                
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkAccessToGeolocation()
        }
}
