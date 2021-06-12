//
//  RecipesApp.swift
//  Recipes
//
//  Created by Fabian Braig on 21.05.21.
//

import SwiftUI
import CoreData

@main
struct RecipesApp: App {
	let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            RecipeList()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct RecipesApp_Previews: PreviewProvider {
	static var previews: some View {
		RecipeList()
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
