//
//  Inventory+CoreDataProperties.swift
//  BestSeller
//
//  Created by Roland Thomas on 11/10/16.
//  Copyright © 2016 Jedisware LLC. All rights reserved.
//

import Foundation
import CoreData


extension Inventory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Inventory> {
        return NSFetchRequest<Inventory>(entityName: "Books");
    }

    @NSManaged public var author: String?
    @NSManaged public var category: String?
    @NSManaged public var desc: String?
    @NSManaged public var img: NSData?
    @NSManaged public var rank: Int32
    @NSManaged public var title: String?

}
