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
					Alert(title: Text("Achtung"),
						message: Text("Alle Rezepte löschen?"), primaryButton: .default(Text("Abbrechen")),
						secondaryButton: .destructive(Text("Löschen"), action: deleteRecipeDatabase))
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
								if let temp_created = recipe["created"] {
									if let temp_date = Double(temp_created) {
										recipe_temp.created = Date(timeIntervalSince1970: temp_date)
									}
								}
								if let temp_recipeImageName = recipe["imageFileName"] {
									let data = readFromFile2(temp_recipeImageName)
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
					writeToFile2(recipes[i].image!, fileName)
					json.append("\"imageFileName\":\"\(fileName)\",")
				}
				json.append("\"created\":\"\(recipes[i].created.timeIntervalSince1970)\"")
				json.append("}")
				if !(i == recipes.count - 1) {
					json.append(",")
				}
			}
			json.append("]")
			writeToFile(json)
		}
	}
	
	func reescapeLineBreaks(_ text: String) -> String {
		// Fix for possible bug with line breaks
		return text.replacingOccurrences(of: "\n", with: "\\n")
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
	
	func writeToFile2(_ fileContent: Data, _ fileName: String) {
		let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0].appendingPathComponent(fileName)
		do {
			try fileContent.write(to: path)
		} catch {
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

	func readFromFile2(_ fileName: String) -> Data? {
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
