//
//  HistoryPlacesOnMapViewController.swift
//  TestAppForPumpit
//
//  Created by Admin on 05.07.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit
import MapKit

class HistoryPlacesOnMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet private var mapView: MKMapView!
    
    //set initial location
    let initialLocation = CLLocation(latitude: 56.838460, longitude: 60.605195)
    
    
    var user = CLLocationCoordinate2D()
    var users = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        mapView.centerToLocation(initialLocation)
        
        let ekaterinburgCenter = CLLocation(latitude: 56.838460, longitude: 60.605195)
        let region = MKCoordinateRegion(
            center: ekaterinburgCenter.coordinate,
            latitudinalMeters: 20000,
            longitudinalMeters: 20000)
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        
        users.append(CLLocationCoordinate2D(latitude: 56.831260, longitude: 60.602498))
        users.append(CLLocationCoordinate2D(latitude: 56.834165, longitude: 60.599744))
        users.append(CLLocationCoordinate2D(latitude: 56.833952, longitude: 60.596612))
        let annotations = annotationForUserLocation(users)
        mapView.addAnnotations(annotations)
        
        
        let firstItem = MKMapItem(placemark: MKPlacemark(coordinate: users.first!))
        let secondItem = MKMapItem(placemark: MKPlacemark(coordinate: users[2]))
        
        
        let request = MKDirections.Request()
        request.source = firstItem
        request.destination = secondItem
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
    
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] (response, error) in
            guard let unrappedResponse = response else {
                NSLog("Error of requesting: \(error.debugDescription)")
                return
            }
            for route in unrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    
    func annotationForUserLocation(_ locations: [CLLocationCoordinate2D]) -> [MKAnnotation] {
        var annotations: [MKAnnotation] = []
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotations.append(annotation)
        }
        return annotations
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}


private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 5000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}



