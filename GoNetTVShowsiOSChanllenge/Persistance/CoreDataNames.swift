//
//  CoreDataNames.swift
//  GoNetTVShowsiOSChanllenge
//
//  Created by Leon Yannik Lopez Rojas on 11/9/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import Foundation

struct Entity {
    let show = "Show"
    let property = Properties()
}
struct Properties {
    let id = "id"
    let name = "name"
    let thumb = "thumb"
    let image = "image"
    let thumbURL = "thumbURL"
    let imageURL = "imageURL"
    let imdb = "imdb"
    let language = "language"
    let site = "site"
    let isFavorite = "isFavorite"
}

let entity = Entity()
