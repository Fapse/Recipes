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
				Text("Anzahl der Rezepte: \(recipes.count)")
				Button("Load Recipes From File", action: loadRecipesFromFile)
				Button("Export Recipes To File", action: exportRecipesToFile)
					.disabled(recipes.count == 0)
				Button("Delete Recipe Database") {
					showingAlert = true
				}
				.alert(isPresented: $showingAlert) {
					Alert(title: Text("Achtung"), message: Text("Alles Rezepte löschen?"), primaryButton: .default(Text("Abbrechen")), secondaryButton: .destructive(Text("Löschen"), action: deleteRecipeDatabase))
				}
				.disabled(recipes.count == 0)
			}
			.padding()
		}
		Spacer()
    }
    
    func loadRecipesFromFile(){
		let data = readFromFile()
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
								//if (inputImage != nil) {
								//	recipe_temp.image = inputImage?.jpegData(compressionQuality: 1)
								//}
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
				json.append("\"name\":\"\(recipes[i].name)\",")
				json.append("\"ingredients\":\"\(recipes[i].ingredients)\",")
				json.append("\"instructions\":\"\(recipes[i].instructions)\"")
				json.append("}")
				if !(i == recipes.count - 1) {
					json.append(",")
				}
			}
			json.append("]")
			writeToFile(json)
		}
	}
    
    func deleteRecipeDatabase(){
		guard recipes.count > 0 else {
			return
		}
		do {
			for recipe in recipes {
				managedObjectContext.delete(recipe)
			}
			try managedObjectContext.save()
		} catch let error {
			print(error.localizedDescription)
		}
	}
	
	func writeToFile(_ fileContent: String) {
		let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0].appendingPathComponent("recipes.json")
		do {
			try fileContent.write(to: path, atomically: true, encoding: .utf8)
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func readFromFile() -> Data? {
		let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0].appendingPathComponent("recipes.json")
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
