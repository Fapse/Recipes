//
//  RecipeNew.swift
//  Recipes
//
//  Created by Fabian Braig on 02.06.21.
//

import SwiftUI

struct RecipeNew: View {
	@Environment(\.managedObjectContext) var managedObjectContext
	@Environment(\.presentationMode) var presentationMode

	@State private var name: String = ""
	@State private var ingredients: String = ""
	@State private var instructions: String = ""

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
			.navigationBarTitle(Text("Rezept anlegen"), displayMode: .inline)
			.onDisappear() {
				if !name.isEmpty {
					let recipe = Recipe(context: managedObjectContext)
					recipe.name = name
					recipe.ingredients = ingredients
					recipe.instructions = instructions
					recipe.uuid = UUID()
					recipe.created = Date()
					try? managedObjectContext.save()
				}
				presentationMode.wrappedValue.dismiss()
			}
		}
    }
}

struct RecipeNew_Previews: PreviewProvider {
    static var previews: some View {
        RecipeNew()
    }
}
