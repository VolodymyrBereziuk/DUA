//
//  Location+Extensions.swift
//  DostupnoUA
//
//  Created by admin on 06.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

extension String {
    
    func gradeColor() -> UIColor? {
        let gradeType = Acc(rawValue: self)
        switch gradeType {
        case .bad:
            return R.color.redGradientTop()
        case .mid:
            return R.color.yellowOrange()
        case .good:
            return R.color.yellowishGreen()
        case .none:
            return R.color.silver()
        }
    }
    
    func gradeTitle(gradeStr: String? = nil) -> String? {
        let gradeType = Acc(rawValue: self)
        switch gradeType {
        case .bad:
            return R.string.localizable.genericGradeBad.localized()
        case .mid:
            return R.string.localizable.genericGradeNormal.localized()
        case .good:
            return R.string.localizable.genericGradeGood.localized()
        case .none:
            return nil
        }
    }
}
extension Location {
    
//    var gradeType: Acc? {
//        return Acc(rawValue: generalGrade ?? "")
//    }
    
    func getAcc(gradeStr: String? = nil) -> Acc? {
        let gradeTypeStr = gradeStr == nil ? generalGrade : gradeStr
        return Acc(rawValue: gradeTypeStr ?? "")
    }
    
    func getGradeColor(gradeStr: String? = nil) -> UIColor? {
        let gradeType = getAcc(gradeStr: gradeStr)
        switch gradeType {
        case .bad:
            return R.color.redGradientTop()
        case .mid:
            return R.color.yellowOrange()
        case .good:
            return R.color.yellowishGreen()
        case .none:
            return R.color.warmGrey()
        }
    }
    
    func getGradeTitle(gradeStr: String? = nil) -> String? {
        let gradeType = getAcc(gradeStr: gradeStr)
        switch gradeType {
        case .bad:
            return R.string.localizable.genericGradeBad.localized()
        case .mid:
            return R.string.localizable.genericGradeNormal.localized()
        case .good:
            return R.string.localizable.genericGradeGood.localized()
        case .none:
            return nil
        }
    }
    
    func allPhotosUrl() -> [String]? {
        let thumbPhotos = [thumbnail?.sizes?.sliderMain?.url].compactMap({ $0 })
        let entrancePhotos = getPhotosUrls(photos: enterPhotos)
        let bathroomPhotos = getPhotosUrls(photos: self.bathroomPhotos)
        let indoorPhotos = getPhotosUrls(photos: self.indoorPhotos)
        let childPhotos = getPhotosUrls(photos: self.childPhotos)
        let arr = thumbPhotos + entrancePhotos + bathroomPhotos + indoorPhotos + childPhotos
        return arr
    }
    
    private func getPhotosUrls(photos: [Photo]?) -> [String] {
        return photos?.compactMap({ $0.sizes?.sliderMain?.url }) ?? []
    }
    
//    var gradeColor: UIColor? {
//        switch gradeType {
//        case .bad:
//            return R.color.redGradientTop()
//        case .mid:
//            return R.color.yellowOrange()
//        case .good:
//            return R.color.yellowishGreen()
//        case .none:
//            return R.color.warmGrey()
//        }
//    }
    
//    var gradeTitle: String? {
//        switch gradeType {
//        case .bad:
//            return R.string.localizable.genericGradeBad.localized()
//        case .mid:
//            return R.string.localizable.genericGradeNormal.localized()
//        case .good:
//            return R.string.localizable.genericGradeGood.localized()
//        case .none:
//            return nil
//        }
//    }
}
