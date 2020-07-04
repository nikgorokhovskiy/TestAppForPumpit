//
//  CustomTableViewCell.swift
//  TestAppForPumpit
//
//  Created by Admin on 29.06.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
//MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var batteryStatusLabel: UILabel!
    @IBOutlet weak var batteryStatusImageView: UIImageView!
    @IBOutlet weak var batteryStateImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        avatarImageView.clipsToBounds = true
        batteryStateImageView.alpha = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func set(peoples: Peoples) {
        ImageService.diownloadImage(withURL: peoples.photoURL) { (image) in
            self.avatarImageView.image = image
        }
        
        nameLabel.text = peoples.name
        statusLabel.text = peoples.status
        
        guard let battery = Double(peoples.batteryLevel) else { return }
        batteryStatusLabel.text = String(Int(battery * 100)) + "%"
        if battery > 0.75 {
            batteryStatusImageView.image = UIImage(systemName: "battery.100")
            batteryStatusImageView.tintColor = .systemGreen
            batteryStatusLabel.textColor = .systemGreen
        } else if battery >= 0.4 && battery <= 0.75 {
            batteryStatusImageView.image = UIImage(systemName: "battery.25")
            batteryStatusImageView.tintColor = .systemGreen
            batteryStatusLabel.textColor = .systemGreen
        } else if battery >= 0.25 && battery < 0.4 {
            batteryStatusImageView.image = UIImage(systemName: "battery.25")
            batteryStatusImageView.tintColor = .systemYellow
            batteryStatusLabel.textColor = .systemYellow
        } else if battery < 0.25 && battery >= 0.05 {
            batteryStatusImageView.image = UIImage(systemName: "battery.25")
            batteryStatusImageView.tintColor = .systemRed
            batteryStatusLabel.textColor = .systemRed
        } else if battery < 0.05 {
            batteryStatusImageView.image = UIImage(systemName: "battery.0")
            batteryStatusImageView.tintColor = .systemRed
            batteryStatusLabel.textColor = .systemRed
            batteryStateImageView.tintColor = .red
            batteryStateImageView.alpha = 1
        }
        
    }
    
}
