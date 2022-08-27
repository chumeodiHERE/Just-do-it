//
//  ToDoListItem+CoreDataProperties.swift
//  Just do it
//
//  Created by Gia Huy on 27/08/2022.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var content: String?
    @NSManaged public var history: Date?

}

extension ToDoListItem : Identifiable {

}
