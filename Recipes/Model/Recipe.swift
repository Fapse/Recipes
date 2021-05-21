//
//  Recipe.swift
//  CoreDataDemo
//
//  Created by Fabian Braig on 19.05.21.
//

import Foundation
import CoreData

@objc(Recipe)
public class Recipe: NSManagedObject, Identifiable
{
    @NSManaged public var uuid: UUID
    @NSManaged public var created: Date
    @NSManaged public var name: String

    public override func awakeFromInsert()
    {
        setPrimitiveValue(UUID(), forKey: "uuid")
        setPrimitiveValue(Date(), forKey: "created")
        setPrimitiveValue("",     forKey: "name")
    }
    

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }
    
}
