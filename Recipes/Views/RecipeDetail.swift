//
//  RecipeDetail.swift
//  CoreDataDemo
//
//  Created by Fabian Braig on 20.05.21.
//

import SwiftUI

struct RecipeDetail: View {
	@State private var showingEdit: Bool = false
	@Environment(\.locale) var locale: Locale
	
	@ObservedObject var recipe: Recipe
    var body: some View {
		ScrollView {
			Group {
				if (recipe.image != nil) {
					Image(uiImage: UIImage(data: recipe.image!)!)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(maxHeight: 250)
				}
				Text(recipe.name)
					.font(.title)
					.fontWeight(.bold)
					.padding(.top)
					.frame(maxWidth: .infinity, alignment: .center)
				Group {
					if !recipe.ingredients.isEmpty {
						Text(NSLocalizedString("Ingredients", comment: "What you need to cook this meal"))
							.font(.subheadline)
							.fontWeight(.bold)
							.padding(.top)
						Text(recipe.ingredients)
							.font(.system(size: 16))
					}
					if !recipe.instructions.isEmpty {
						Text(NSLocalizedString("Preparation", comment: "How to cook this meal"))
							.font(.subheadline)
							.fontWeight(.bold)
							.padding(.top)
						Text(recipe.instructions)
							.font(.system(size: 16))
					}
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				if !recipe.name.isEmpty {
					// App would sometimes crash in this Text, when last recipe is deleted.
					// and recipe was just in detail view before.
					// This if-clause is just a bad way to get around this weird possible bug.
					Text(NSLocalizedString("Created: ", comment: "Time of recipe creation") + getDateString(date: recipe.created))
						.font(.footnote)
						.foregroundColor(.gray)
						.italic()
						.padding(.top)
						.frame(alignment: .center)
					if let edited = recipe.edited {
						Text(NSLocalizedString("Edited: ", comment: "Time of last recipe edit") + getDateString(date: edited))
							.font(.footnote)
							.foregroundColor(.gray)
							.italic()
							.frame(alignment: .center)
					}
				}
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
	
	func getDateString(date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		dateFormatter.locale = locale
		return dateFormatter.string(from: date)
	}
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetail(recipe: previewRecipe)
    }
}
