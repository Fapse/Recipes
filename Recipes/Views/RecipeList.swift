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
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				VStack {
					NavigationLink(destination: RecipeEdit(), isActive: $showingNew) {}
					Button(action: {
						showingNew = true
					}) {
						Image(systemName: "note.text.badge.plus")
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
