//
//  Show+CoreDataProperties.swift
//  GoNetTVShowsiOSChanllenge
//
//  Created by Leon Yannik Lopez Rojas on 11/9/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//
//

import Foundation
import CoreData


extension Show {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Show> {
        return NSFetchRequest<Show>(entityName: "Show")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var thumb: NSData?
    @NSManaged public var image: NSData?
    @NSManaged public var imdb: String?
    @NSManaged public var language: String?
    @NSManaged public var site: String?
    @NSManaged public var summary: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var thumbURL: String?

}
