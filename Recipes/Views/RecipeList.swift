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
	@State private var showingSettings = false
	@State private var searchText = ""
	@State private var isSearching = false
	@State private var listViewId = UUID()
	@State private var selectedItem: Recipe?

	@FetchRequest(
		entity: Recipe.entity(),
		sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.name, ascending: true)]
	) var recipes: FetchedResults<Recipe>
	  
    var body: some View {
		NavigationView {
		Group {
			SearchBar(searchText: $searchText, isSearching: $isSearching)
			if recipes.count == 0 {
				Text("No recipes available")
			}
			List {
				ForEach(recipes.filter{ recipe in containsText(serchText: searchText, recipe: recipe) }  , id: \.uuid) { recipe in
					NavigationLink(destination: RecipeDetail(recipe: recipe),
						tag: recipe,
						selection: $selectedItem,
						label: {Text(recipe.name)}
					)
				}
				.onDelete(perform: deleteRecipes)
			}
			.id(listViewId)
			.onAppear {
				// Workaround for bug(?), so selected recipe list entries will not show as selected, when returning from detail view
				// See here: https://developer.apple.com/forums/thread/660468?answerId=657882022#657882022
				if selectedItem != nil {
					selectedItem = nil
					listViewId = UUID()
				}
			}
			.listStyle(PlainListStyle())
			Spacer()
		}
		.navigationTitle(NSLocalizedString("Recipes", comment: "Recipes for cooking"))
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarItems(
			leading:
				HStack {
					NavigationLink(destination: Settings(), isActive: $showingSettings) {}
					Button(action: {
						showingSettings = true
					}) {
						Image(systemName: "gearshape")
					}
					.padding()
				},
			trailing:
				HStack {
					NavigationLink(destination: RecipeEdit(), isActive: $showingNew) {}
					Button(action: {
						showingNew = true
					}) {
						Image(systemName: "plus.circle.fill")
					}
					.padding()
				}
			)
		}
	}
	
	func containsText(serchText: String, recipe: Recipe) -> Bool {
		if searchText == "" {
			return true
		} else if recipe.name.lowercased().contains(searchText.lowercased()) {
			return true
		} else if recipe.ingredients.lowercased().contains(searchText.lowercased()) {
			return true
		} else if recipe.instructions.lowercased().contains(searchText.lowercased()) {
			return true
		} else {
			return false
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
        RecipeList()
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
			.colorScheme(.dark)
    }
}

struct SearchBar: View {

	@Binding var searchText: String
	@Binding var isSearching: Bool
	
	var body: some View {
		HStack {
			HStack {
				TextField("Search term", text: $searchText)
					.padding(.leading, 24)
			}
			.padding(.horizontal)
			.padding(.vertical, 6)
			.background(Color(.systemGray4))
			.cornerRadius(6)
			.padding()
			.onTapGesture(perform: {
				isSearching = true
			})
			.overlay(
				HStack {
					Image(systemName: "magnifyingglass")
					Spacer()
					if isSearching {
						Button(action: {searchText = ""}, label: {
							Image(systemName: "xmark.circle.fill")
								.padding(.vertical)
						})
					}
				}
				.padding(.horizontal, 32)
				.foregroundColor(.gray)
			)
			.transition(.move(edge: .trailing))
			.animation(.default)
			if isSearching {
				Button(action: {
					isSearching = false
					searchText = ""
					UIApplication.shared.sendAction(#selector(UIResponder
						.resignFirstResponder), to: nil, from: nil, for: nil)
				}, label: {
					Text("Cancel")
						.padding(.trailing)
						.padding(.leading, -5)
						.padding(.vertical, 6)
				})
				.transition(.move(edge: .trailing))
				.animation(.default)
			}
		}
	}
}
