//
//  Recipe.swift
//  CoreDataDemo
//
//  Created by Fabian Braig on 19.05.21.
//

import Foundation
import CoreData
import SwiftUI

@objc(Recipe)
public class Recipe: NSManagedObject, Identifiable
{
    @NSManaged public var uuid: UUID!	// must be force-unwrapped (probably bug in CoreData, with optional values)
										// see bug report here https://bugs.swift.org/browse/SR-6143
    @NSManaged public var created: Date
    @NSManaged public var name: String
    @NSManaged public var ingredients: String
    @NSManaged public var instructions: String
    @NSManaged public var image: Data?

    public override func awakeFromInsert()
    {
        setPrimitiveValue(UUID(), forKey: "uuid")
        setPrimitiveValue(Date(), forKey: "created")
        setPrimitiveValue("",     forKey: "name")
        setPrimitiveValue("", forKey: "ingredients")
        setPrimitiveValue("", forKey: "instructions")
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }
}
