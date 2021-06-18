//
//  History+CoreDataProperties.swift
//  CWKSemua
//
//  Created by jona on 15/06/21.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var videoLink: String?
    @NSManaged public var videoId: NSNumber!
    @NSManaged public var videoDate: Date?

}

extension History : Identifiable {

}
