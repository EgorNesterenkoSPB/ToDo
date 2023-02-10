//
//  NoteImage+CoreDataProperties.swift
//  
//
//  Created by no name on 31.01.2023.
//
//

import Foundation
import CoreData


extension NoteImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteImage> {
        return NSFetchRequest<NoteImage>(entityName: "NoteImage")
    }

    @NSManaged public var image: Data?
    @NSManaged public var note: Note?

}
