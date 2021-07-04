//
//  Settings.swift
//  Recipes
//
//  Created by Fabian Braig on 17.06.21.
//

import SwiftUI
import Foundation

struct Settings: View {

	@Environment(\.managedObjectContext) var managedObjectContext
	
	@FetchRequest(
		entity: Recipe.entity(),
		sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.name, ascending: true)]
	) var recipes: FetchedResults<Recipe>
	
	@State private var showingAlert = false
	
    var body: some View {
		VStack {
			Group {
				Text(NSLocalizedString("Number of recipes: ", comment: "Import recipes from json file") + "\(recipes.count)")
				Button(NSLocalizedString("Import Recipes From File", comment: "Import recipes from json file"), action: loadRecipesFromFile)
				Button(NSLocalizedString("Export Recipes To File", comment: "Export recipes from json file"), action: exportRecipesToFile)
					.disabled(recipes.count == 0)
				Button(NSLocalizedString("Delete All Recipes", comment: "Delete all recipes from database")) {
					showingAlert = true
				}
				.alert(isPresented: $showingAlert) {
					Alert(title: Text("Attention"),
						message: Text("Delete all recipes?"), primaryButton: .default(Text("Cancel")),
						secondaryButton: .destructive(Text("Delete"), action: deleteRecipeDatabase))
				}
				.disabled(recipes.count == 0)
			}
			.padding()
		}
		Spacer()
    }
    
    func loadRecipesFromFile(){
		let data = readFromFile("recipes.json")
		guard data != nil else {
			return
		}
		do {
			let json = try JSONSerialization.jsonObject(with: data!, options: [])
			if let root = json as? [[String: String]] {
				for recipe in root {
					if let recipe_name = recipe["name"] {
						if recipe_name != "" {
							if !recipeNameExists(recipe_name) {
								let recipe_temp = Recipe(context: managedObjectContext)
								recipe_temp.name = recipe_name
								recipe_temp.ingredients = recipe["ingredients"] ?? ""
								recipe_temp.instructions = recipe["instructions"] ?? ""
								if let temp_created = recipe["created"] {
									if let temp_date = Double(temp_created) {
										recipe_temp.created = Date(timeIntervalSince1970: temp_date)
									}
								}
								if let temp_edited = recipe["edited"] {
									if let temp_date = Double(temp_edited) {
										recipe_temp.edited = Date(timeIntervalSince1970: temp_date)
									}
								}
								if let temp_recipeImageName = recipe["imageFileName"] {
									let data = readFromFile(temp_recipeImageName)
									if let imageData = data {
										let uiImage = UIImage(data: imageData)
										if uiImage == nil {
											print("No image created")
										}
										if let temp_uiImage = uiImage {
											recipe_temp.image = temp_uiImage.jpegData(compressionQuality: 1)
										}
									}
								}
								try? managedObjectContext.save()
							}
						}
					}
				}
			}
		} catch {
			print("Error in loadRecipesFromFile")
			print(error)
		}
	}
	
	func recipeNameExists(_ newRecipeName: String) -> Bool {
		for recipe in recipes {
			if (recipe.name == newRecipeName) {
				return true
			}
		}
		return false
	}
	
	func exportRecipesToFile() {
		if recipes.count > 0 {
			var json = "["
			for i in 0...recipes.count - 1 {
				json.append("{")
				json.append("\"name\":\"\(reescapeLineBreaks(recipes[i].name))\",")
				json.append("\"ingredients\":\"\(reescapeLineBreaks(recipes[i].ingredients))\",")
				json.append("\"instructions\":\"\(reescapeLineBreaks(recipes[i].instructions))\",")
				if recipes[i].image != nil {
					let fileName = recipes[i].uuid.description + ".jpeg"
					print(fileName)
					writeToFile(recipes[i].image!, fileName)
					json.append("\"imageFileName\":\"\(fileName)\",")
				}
				if let edited = recipes[i].edited {
					json.append("\"edited\":\"\(edited.timeIntervalSince1970)\",")
				}
				json.append("\"created\":\"\(recipes[i].created.timeIntervalSince1970)\"")
				json.append("}")
				if !(i == recipes.count - 1) {
					json.append(",")
				}
			}
			json.append("]")
			writeToFile(Data(json.utf8), "recipes.json")
		}
	}
	
	func reescapeLineBreaks(_ text: String) -> String {
		// Fix for possible bug with line breaks
		return text.replacingOccurrences(of: "\n", with: "\\n")
	}
    
    func deleteRecipeDatabase(){
		do {
			for recipe in recipes {
				managedObjectContext.delete(recipe)
			}
			try managedObjectContext.save()
		} catch let error {
			print(error.localizedDescription)
		}
	}

	func writeToFile(_ fileContent: Data, _ fileName: String) {
		let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0].appendingPathComponent(fileName)
		do {
			try fileContent.write(to: path)
		} catch {
			print(error.localizedDescription)
		}
	}

	func readFromFile(_ fileName: String) -> Data? {
		let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0].appendingPathComponent(fileName)
		var data: Data?
		do {
			data = try Data(contentsOf: path)
		} catch {
			print("Error reading from file")
			print(error.localizedDescription)
		}
		return data
	}
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
