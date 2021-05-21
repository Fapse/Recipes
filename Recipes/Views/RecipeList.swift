//
//  RecipeList.swift
//  CoreDataDemo
//
//  Created by Fabian Braig on 16.05.21.
//

import SwiftUI

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
				Button(action: makeRecipe) {
					Label("Add Recipe", systemImage: "person.crop.circle.badge.plus")
				}
			}
		}
		.sheet(isPresented: $showingNew) {
			RecipeEdit(recipe: recipes.sorted(by: { $1.created < $0.created }).first!)
		}
    }
    
	func makeRecipe() {
		let recipe = Recipe(context: managedObjectContext)
		recipe.uuid = UUID()
		
		showingNew = true
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
