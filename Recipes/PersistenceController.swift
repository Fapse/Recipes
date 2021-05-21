//
//  PersistenceController.swift
//  CoreDataDemo
//
//  Created by Fabian Braig on 16.05.21.
//

import Foundation
import CoreData

class PersistenceController {
	static let shared = PersistenceController()
	let container: NSPersistentContainer

	static var preview: PersistenceController = {
		let controller = PersistenceController(inMemory: true)
		let recipeNames = ["Apfelstrudel", "Kaiserschmarrn", "Käsespatzen"]
		
		for count in 0..<recipeNames.count {
			let recipe = Recipe(context: controller.container.viewContext)
			recipe.name = recipeNames[count]
			recipe.created = Date()
			recipe.uuid = UUID()
		}
		
		try! controller.container.viewContext.save()
		
		return controller
	}()
	
	init(inMemory: Bool = false) {
		container = NSPersistentContainer(name: "Recipes")
		
		if inMemory {
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		}
		
		container.loadPersistentStores(completionHandler: {description, error in
			if error != nil {
				fatalError(error!.localizedDescription)
			}
		})
	}
}

#if DEBUG
var previewRecipe: Recipe = {
	let recipe = Recipe(context: PersistenceController.preview.container.viewContext)
	recipe.name = "Käsespatzen"
	recipe.created = Date()
	recipe.uuid = UUID()
	return recipe
}()
#endif
