//
//  PeoplesOnMapViewController.swift
//  TestAppForPumpit
//
//  Created by Admin on 30.06.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit
import MapKit

class PeoplesOnMapViewController: UIViewController, MKMapViewDelegate {

//MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var chekingForUpdateView: UIView!
    
    
//MARK: - Properties
    private let locationManager = CLLocationManager()
    private var mapPeoples: [MapPeoples] = []
    
//MARK: - Body
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        setupMapManager()
        
        mapView.register(MapMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        loadInitialData()
        mapView.addAnnotations(mapPeoples)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkLocationEnabled()
        if mapPeoples.count > 0 {
            UIView.animate(withDuration: 1.5, delay: 2.5, options: [], animations: {
                self.chekingForUpdateView.alpha = 0
            }, completion: nil)
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//Загрузка данных из MapData.geojson и добавление полученных данных в массив с метками mapPeople
    private func loadInitialData() {
        
        guard
            let fileName = Bundle.main.url(forResource: "MapData", withExtension: "geojson"),
            let mapPeoplesData = try? Data(contentsOf: fileName)
        else {
            print("no data")
            return
            
        }
        
        do {
            let features = try MKGeoJSONDecoder()
                .decode(mapPeoplesData)
                .compactMap {$0 as? MKGeoJSONFeature}
            
            let validWorks = features.compactMap(MapPeoples.init)
            mapPeoples.append(contentsOf: validWorks)
        } catch {
            print("unexpected error: \(error)")
        }
    }
    
//Проверка доступа к службе геолокации
    func checkLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
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
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 2000, longitudinalMeters: 2000)
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAccessToGeolocation()
    }
}

