//
//  ImageService.swift
//  TestAppForPumpit
//
//  Created by Admin on 30.06.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    
    static func diownloadImage(withURL url: URL, complition: @escaping (_ image: UIImage?)->()) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, url, error in
            var downloadedImage: UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            DispatchQueue.main.async {
                complition(downloadedImage)
            }
        }
        dataTask.resume()
    }
}
