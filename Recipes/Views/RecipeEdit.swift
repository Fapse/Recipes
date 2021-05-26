//
//  RecipeEdit.swift
//  CoreDataDemo
//
//  Created by Fabian Braig on 20.05.21.
//

import SwiftUI

struct RecipeEdit: View {
	@Environment(\.managedObjectContext) var managedObjectContext
	@Environment(\.presentationMode) var presentationMode

	var recipe: Recipe
	
	@State private var name: String = ""
	@State private var ingredients: String = ""
	@State private var instructions: String = ""
	
	init(recipe: Recipe) {
		self.recipe = recipe
		
		_name = State(initialValue: recipe.name)
		_ingredients = State(initialValue: recipe.ingredients)
		_instructions = State(initialValue: recipe.instructions)
	}
	
    var body: some View {
        NavigationView {
			Form {
				Section(header: Text("Rezeptname")) {
					TextField("Name", text: $name)
				}
				Section(header: Text("Zutaten")) {
					TextEditor(text: $ingredients)
						.frame(height: 150)
					
				}
				Section(header: Text("Kochanleitung")) {
					TextEditor(text: $instructions)
						.frame(height: 150)
				}
			}
			.navigationBarTitle(Text("Rezept bearbeiten"), displayMode: .inline)
			.navigationBarItems(trailing:
				Button("Speichern") {
					recipe.name = name
					recipe.ingredients = ingredients
					recipe.instructions = instructions
					try? managedObjectContext.save()
					presentationMode.wrappedValue.dismiss()
				}
			)
		}
    }
}

struct RecipeEdit_Previews: PreviewProvider {
    static var previews: some View {
        RecipeEdit(recipe: previewRecipe)
    }
}
