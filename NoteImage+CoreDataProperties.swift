//
//  NoteImage+CoreDataProperties.swift
//  ToDo
//
//  Created by no name on 10.02.2023.
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

extension NoteImage : Identifiable {

}
