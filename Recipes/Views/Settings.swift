//
//  Settings.swift
//  Recipes
//
//  Created by Fabian Braig on 17.06.21.
//

import SwiftUI

struct Settings: View {

	@Environment(\.managedObjectContext) var managedObjectContext
	
	@FetchRequest(
		entity: Recipe.entity(),
		sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.name, ascending: true)]
	) var recipes: FetchedResults<Recipe>


    var body: some View {
		VStack {
		Group {
			Button("Load Recipes From File", action: loadRecipesFromFile)
			Button("Load Default Recipes", action: loadDefaultRecipes)
			Button("Export Recipes To File", action: exportRecipesToFile)
			Button("Delete Recipe Database", action: deleteRecipeDatabase)
			}
			.padding()
		}
		Spacer()
    }
    
    func loadRecipesFromFile(){
		print("Testi")
	}
	
    func loadDefaultRecipes(){
    
	}

	func exportRecipesToFile() {

		if recipes.count > 0 {
			var json = "{\n"
			for i in 0...recipes.count - 1 {
				json.append("\t[\n")
				json.append("\t\t\"name\": \"\(recipes[i].name)\",\n")
				json.append("\t\t\"ingredients\": \"\(recipes[i].ingredients)\",\n")
				json.append("\t\t\"instructions\": \"\(recipes[i].instructions)\"\n")
				json.append("\t]")
				if !(i == recipes.count - 1) {
					json.append(",\n")
				}
			}
			json.append("\n}")
			print(json)
			writeToFile(json)
		}
	}
    
    func deleteRecipeDatabase(){
    
	}
	
	func writeToFile(_ fileContent: String) {
		let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0].appendingPathComponent("recipes.txt")
		do {
			print(path.absoluteString)
			print("... attempting to write")
			try fileContent.write(to: path, atomically: true, encoding: .utf8)
			print("... file writtem")
		} catch {
			print(error.localizedDescription)
		}
	}
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
