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
		ScrollView {
			Group {
				if (recipe.image != nil) {
					Image(uiImage: UIImage(data: recipe.image!)!)
						.resizable()
						.scaledToFill()
				}
				Text(recipe.name)
					.font(.title)
					.fontWeight(.bold)
					.frame(maxWidth: .infinity, alignment: .center)
				Group {
					if !recipe.ingredients.isEmpty {
						Text("Zutaten")
							.font(.subheadline)
							.fontWeight(.bold)
						Text(recipe.ingredients)
							.font(.system(size: 16))
					}
					if !recipe.instructions.isEmpty {
						Text("Zubereitung")
							.font(.subheadline)
							.fontWeight(.bold)
						Text(recipe.instructions)
							.font(.system(size: 16))
					}
				}
				.frame(maxWidth: .infinity, alignment: .leading)
			}
		}
		.padding()
		.navigationBarTitle(Text("Detail"), displayMode: .inline)
		.toolbar {
			NavigationLink(destination: RecipeEdit(recipe: recipe), isActive: $showingEdit) {
				Button(action: {
					showingEdit = true
				}) {
					Image(systemName: "pencil")
				}
			}
		}
	}
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetail(recipe: previewRecipe)
    }
}
