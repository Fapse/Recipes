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
        VStack {
			Text(recipe.name)
				.font(.headline)
				.padding([.leading, .trailing], 5)
		}
		
    }
}

struct RecipeRow_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRow(recipe: previewRecipe)
    }
}
