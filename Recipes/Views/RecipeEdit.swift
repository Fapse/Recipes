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
	
	init(recipe: Recipe) {
		self.recipe = recipe
		
		_name = State(initialValue: recipe.name)
	}

    var body: some View {
        NavigationView {
			Form {
				TextField("Name", text: $name)
			}
			.navigationBarTitle(Text("Rezept ändern"), displayMode: .inline)
			.navigationBarItems(trailing:
				Button("Save") {
					recipe.name = name
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
