//
//  RecipeList.swift
//  CoreDataDemo
//
//  Created by Fabian Braig on 16.05.21.
//

import SwiftUI
import CoreData

struct RecipeList: View {
	@Environment(\.managedObjectContext) var managedObjectContext
	@State private var showingNew = false

	@FetchRequest(
		entity: Recipe.entity(),
		sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.name, ascending: true)]
	) var recipes: FetchedResults<Recipe>
	  
    var body: some View {
		NavigationView {
			List {
				ForEach(recipes, id: \.uuid) { recipe in
					VStack {
						NavigationLink(
							destination: RecipeDetail(recipe: recipe)) {
								RecipeRow(recipe: recipe)
							}
					}
				}
				.onDelete(perform: deleteRecipes)
			}
			.navigationTitle("Rezepte")
			.toolbar {
				VStack {
					NavigationLink(destination: RecipeNew(), isActive: $showingNew) {}
					Button("New") {
							showingNew = true
					}
				}
			}
		}
	}
        
	func deleteRecipes(at offsets: IndexSet) {
		for offset in offsets {
			managedObjectContext.delete(recipes[offset])
		}
		try? managedObjectContext.save()
	}
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeList()
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
