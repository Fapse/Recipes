//
//  RecipesApp.swift
//  Recipes
//
//  Created by Fabian Braig on 21.05.21.
//

import SwiftUI
import CoreData

@main
struct CoreDataDemoApp: App {
	let persistenceController = PersistenceController.preview
    var body: some Scene {
        WindowGroup {
            RecipeList()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct CoreDataDemoApp_Previews: PreviewProvider {
	static var previews: some View {
		RecipeList()
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
