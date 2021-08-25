//
//  CellModels.swift
//  DostupnoUA
//
//  Created by Anton on 14.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

class LocationDetailsFilterCellModel {

    let name: String?
    let description: String?
    let iconImage: UIImage?
    let isHidden: Bool?
    
    init(name: String?, description: String?, iconImage: UIImage?, isHidden: Bool?) {
        self.name = name
        self.description = description
        self.iconImage = iconImage
        self.isHidden = isHidden
    }
}

class NoFilterCellModel: LocationDetailsFilterCellModel {
    
    let isLocation: Bool?
    
    init(name: String?, description: String?, iconImage: UIImage?, isLocation: Bool? = false, isHidden: Bool?) {
        self.isLocation = isLocation
        super.init(name: name, description: description, iconImage: iconImage, isHidden: isHidden)
    }
}

class OneFilterCellModel: LocationDetailsFilterCellModel {

    let gradeColor: UIColor?
    let firstFilterTitle: String?
    let firstFilterDescription: String?
    
    init(name: String?, description: String?, iconImage: UIImage?, gradeColor: UIColor?, firstFilterTitle: String?, firstFilterDescription: String?, isHidden: Bool?) {
        
        self.gradeColor = gradeColor
        self.firstFilterTitle = firstFilterTitle
        self.firstFilterDescription = firstFilterDescription
        super.init(name: name, description: description, iconImage: iconImage, isHidden: isHidden)
    }
}

class ThreeFilterCellModel: LocationDetailsFilterCellModel {

    let gradeColor: UIColor?
    let firstFilterTitle: String?
    let firstFilterDescription: String?
    let secondFilterTitle: String?
    let secondFilterDescription: String?
    let thirdFilterTitle: String?
    let thirdFilterDescription: String?
    
    init(name: String?, description: String?, iconImage: UIImage?, gradeColor: UIColor?, firstFilterTitle: String?, firstFilterDescription: String?, secondFilterTitle: String?, secondFilterDescription: String?, thirdFilterTitle: String?, thirdFilterDescription: String?, isHidden: Bool?) {

        self.gradeColor = gradeColor
        self.firstFilterTitle = firstFilterTitle
        self.firstFilterDescription = firstFilterDescription
        self.secondFilterTitle = secondFilterTitle
        self.secondFilterDescription = secondFilterDescription
        self.thirdFilterTitle = thirdFilterTitle
        self.thirdFilterDescription = thirdFilterDescription
        super.init(name: name, description: description, iconImage: iconImage, isHidden: isHidden)
    }
}
