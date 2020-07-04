//
//  MapAnnotationView.swift
//  TestAppForPumpit
//
//  Created by Admin on 02.07.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapMarkerAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let mapPeoples = newValue as? MapPeoples else { return }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: 0, y: 5)
            centerOffset = CGPoint(x: 0, y: -30)
            
//MARK: - leftImage setup
            let leftImage = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 50, height: 50)))
            leftImage.image = UIImage(imageLiteralResourceName: "pin_image_1")
            leftImage.layer.cornerRadius = leftImage.bounds.height / 2
            leftImage.clipsToBounds = true
            leftCalloutAccessoryView = leftImage //set inside view
            

//MARK: - batteryLabel setup
            guard let batteryLabel = setBatteryLabel(mapPeoples: mapPeoples) else { return }
            batteryLabel.font = batteryLabel.font.withSize(15)
//MARK: - batteryImage setup
            guard let batteryImage = setBatteryImage(mapPeoples: mapPeoples) else { return }
//MARK: - Battery status and BatteryLabel stackView setup
            let stackView = UIStackView.init(frame: CGRect(origin: .zero, size: CGSize(width: 75, height: 22)))
            stackView.insertArrangedSubview(batteryLabel, at: 0)
            stackView.insertArrangedSubview(batteryImage, at: 1)
            stackView.axis = .horizontal
            stackView.spacing = 5
            stackView.alignment = .center
            stackView.distribution = .equalCentering
            stackView.contentMode = .scaleToFill
            stackView.translatesAutoresizingMaskIntoConstraints = false
//MARK: - infoImage status battery setup
            let infoImage = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 15, height: 15)))
            infoImage.image = UIImage(systemName: "exclamationmark.triangle")
            infoImage.tintColor = .systemRed
            if batteryImage.image == UIImage(systemName: "battery.0") {
                infoImage.alpha = 1
            } else {
                infoImage.alpha = 0
            }
//MARK: - battery status and infoImage stackView setup
            let vertStackView = UIStackView()
            vertStackView.insertArrangedSubview(stackView, at: 0)
            vertStackView.insertArrangedSubview(infoImage, at: 1)
            vertStackView.axis = .vertical
            vertStackView.spacing = 0
            vertStackView.alignment = .center
            vertStackView.distribution = .equalCentering
            vertStackView.contentMode = .scaleToFill
            vertStackView.translatesAutoresizingMaskIntoConstraints = false
//MARK: - BatteryView satus view setup
            let batteryView = UIView(
                frame: CGRect(
                    origin: CGPoint(x: 0, y: 0),
                    size: CGSize(
                        width: stackView.frame.size.width,
                        height: stackView.frame.size.height
                    )
                )
            )
            batteryView.addSubview(vertStackView)
            vertStackView.centerXAnchor.constraint(equalTo: batteryView.centerXAnchor).isActive = true
            vertStackView.centerYAnchor.constraint(equalTo: batteryView.centerYAnchor).isActive = true
            
            rightCalloutAccessoryView = batteryView //set iside view

//MARK: - avatarImageViewSetup
            let avatarImageView = UIImageView(frame: CGRect(origin: CGPoint(x: 25, y: 10), size: CGSize(width: 50, height: 50)))
            ImageService.diownloadImage(withURL: mapPeoples.photoURL!) { (image) in
                avatarImageView.image = image?.withRoundedCornres(radius: 0)
            }

            let avatarView = UIView()
            avatarView.addSubview(avatarImageView)
            
            image = UIImage(named: "map_pin_frame")
            addSubview(avatarView)
        }
    }
}

extension MapMarkerAnnotationView {
    
    private func setBatteryLabel(mapPeoples: MapPeoples) -> UILabel? {
        guard mapPeoples.batteryLevel != nil else { return nil }
        let battery: String = mapPeoples.batteryLevel.map{ $0 }!
        guard let batteryDouble = Double(battery) else { return nil }
        let batteryLabel = UILabel()
        batteryLabel.text = String(Int(batteryDouble * 100)) + "%"
        if batteryDouble > 0.4 {
            batteryLabel.tintColor = .systemGreen
        } else if batteryDouble > 0.25 && batteryDouble <= 0.4 {
            batteryLabel.tintColor = .systemYellow
        } else if batteryDouble <= 0.25 {
            batteryLabel.tintColor = .systemRed
        }
        return batteryLabel
    }
    
    private func setBatteryImage(mapPeoples: MapPeoples) -> UIImageView? {
        guard mapPeoples.batteryLevel != nil else { return nil }
        let battery: String = mapPeoples.batteryLevel.map{ $0 }!
        guard let batteryDouble = Double(battery) else { return nil }
        let batteryImage = UIImageView()
        if batteryDouble > 0.75 {
            batteryImage.image = UIImage(systemName: "battery.100")
            batteryImage.tintColor = .systemGreen
        } else if batteryDouble > 0.4 && batteryDouble <= 0.75 {
            batteryImage.image = UIImage(systemName: "battery.25")
            batteryImage.tintColor = .systemGreen
        } else if batteryDouble > 0.25 && batteryDouble <= 0.4 {
            batteryImage.image = UIImage(systemName: "battery.25")
            batteryImage.tintColor = .systemYellow
        } else if batteryDouble <= 0.25 && batteryDouble > 0.05 {
            batteryImage.image = UIImage(systemName: "battery.25")
            batteryImage.tintColor = .systemRed
        } else if batteryDouble < 0.05 {
            batteryImage.image = UIImage(systemName: "battery.0")
            batteryImage.tintColor = .systemRed
        }
        return batteryImage
    }

}

extension UIImage {
    public func withRoundedCornres(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius < maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
