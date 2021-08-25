//
//  DeepLinkOption.swift
//  DostupnoUA
//
//  Created by admin on 9/22/19.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

//Constants for push notification types
enum DeepLinkURLConstants: String {
    case something = ""
}

enum DeepLinkOption: String {
    
    case somethingElse
    case somethingElse2
    
    static func build(with userActivity: NSUserActivity) -> DeepLinkOption? {
       if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
         let url = userActivity.webpageURL,
         let component = URLComponents(url: url, resolvingAgainstBaseURL: true) {
         print(component)
       }
       return nil
     }
    
    static func build(with dictionary: [String: AnyObject]?) -> DeepLinkOption? {
        guard let id = dictionary?["launch_id"] as? String else {
            return nil
        }
        
        switch id {
        case DeepLinkOption.somethingElse.rawValue:
            return .somethingElse
        default:
            return nil
        }
    }
}
