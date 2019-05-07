//
//  MDNote+CoreDataProperties.swift
//  MDSimpleNote
//
//  Created by MDLE on 2019-04-07.
//  Copyright © 2019 dcre8tive. All rights reserved.
//
//

import Foundation
import CoreData


extension MDNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MDNote> {
        return NSFetchRequest<MDNote>(entityName: "MDNote")
    }

    @NSManaged public var text: String?
    @NSManaged public var addDate: String?
}
