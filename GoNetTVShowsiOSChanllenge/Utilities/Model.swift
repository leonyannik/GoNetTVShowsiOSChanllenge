//
//  Model.swift
//  GoNetTVShowsiOSChanllenge
//
//  Created by Leon Yannik Lopez Rojas on 11/9/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import Foundation
import UIKit

struct ShowSt {
    var id: String
    var name: String
    var summary: String
    var imageURL: String
    var thumbURL: String
    var IMDb: String
    var language: String
    var site: String
    var isFavorite = false
    
    init(id: String, name: String, summary: String, imageURL: String, thumbURL: String, IMDb: String, language: String, site: String) {
        self.id = id
        self.name = name
        self.summary = summary
        self.imageURL = imageURL
        self.thumbURL = thumbURL
        self.IMDb = IMDb
        self.language = language
        self.site = site
    }
}

