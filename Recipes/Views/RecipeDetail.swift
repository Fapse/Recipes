//
//  RecipeDetail.swift
//  CoreDataDemo
//
//  Created by Fabian Braig on 20.05.21.
//

import SwiftUI

struct RecipeDetail: View {
	@State private var showingEdit: Bool = false
	@ObservedObject var recipe: Recipe
    var body: some View {
		VStack(alignment: .leading, spacing: 5.0) {
			Text(recipe.name)
				.font(.title)
				.fontWeight(.bold)
		}
		.padding()
		.navigationBarTitle(Text("Detail"), displayMode: .inline)
		.toolbar {
			Button("Edit") {
				showingEdit = true
			}
		}
		.sheet(isPresented: $showingEdit) {
			RecipeEdit(recipe: recipe)
		}
	}
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetail(recipe: previewRecipe)
    }
}
