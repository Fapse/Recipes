//
//  RecipeRow.swift
//  CoreDataDemo
//
//  Created by Fabian Braig on 20.05.21.
//

import SwiftUI

struct RecipeRow: View {
	@ObservedObject var recipe: Recipe
    var body: some View {
        HStack {
			HStack {
				if (recipe.image != nil) {
					Image(uiImage: UIImage(data: recipe.image!)!)
						.resizable()
						.aspectRatio(contentMode: .fit)
					}
				}
				.frame(height: 50)
				.frame(width: 50)
				.padding(.trailing, 5)
			Text(recipe.name)
			Spacer()
		}
    }
}

struct RecipeRow_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRow(recipe: previewRecipe)
    }
}
