//
//  ProfileViewController.swift
//  TestAppForPumpit
//
//  Created by Admin on 04.07.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var locationAccuracyMaxButton: UIButton!
    @IBOutlet weak var locationAccuracy10Button: UIButton!
    @IBOutlet weak var locationAccuracy100Button: UIButton!
    @IBOutlet weak var locationAccuracy1000Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setShadows()
        // Do any additional setup after loading the view.
    }
    
    func setShadows() {
        locationAccuracyMaxButton.addShadoowView()
        locationAccuracy10Button.addShadoowView()
        locationAccuracy100Button.addShadoowView()
        locationAccuracy1000Button.addShadoowView()
    }

}

private extension UIView {
    
    func addShadoowView(
        width: CGFloat = 0,
        height: CGFloat = 8,
        opacity: Float = 0.05,
        masksToBounds: Bool = false,
        radius: CGFloat = 2
    ) {
        self.layer.shadowColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = masksToBounds
    }
}
