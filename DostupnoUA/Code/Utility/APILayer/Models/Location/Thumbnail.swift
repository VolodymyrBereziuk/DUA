//
//  Thumbnails.swift
//  DostupnoUA
//
//  Created by admin on 28.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

class Thumbnail: Codable {
    let id: Int
    let name: String?
    let alt: String?
    let url: String?
    let width: Int?
    let height: Int?
    let sizes: Sizes?
    let caption: String?

    init(id: Int, name: String?, alt: String?, url: String?, width: Int?, height: Int?, sizes: Sizes?, caption: String?) {
        self.id = id
        self.name = name
        self.alt = alt
        self.url = url
        self.width = width
        self.height = height
        self.sizes = sizes
        self.caption = caption
    }
}

// MARK: - Sizes
class Sizes: Codable {
    let original: Size?
    let sliderMain: Size?
    let square: Size?

    enum CodingKeys: String, CodingKey {
        case original
        case sliderMain = "slider_main"
        case square
    }

    init(original: Size?, sliderMain: Size?, square: Size?) {
        self.original = original
        self.sliderMain = sliderMain
        self.square = square
    }
}

// MARK: - Original
class Size: Codable {
    let width: Int?
    let height: Int?
    let url: String?

    init(width: Int?, height: Int?, url: String?) {
        self.width = width
        self.height = height
        self.url = url
    }
}
