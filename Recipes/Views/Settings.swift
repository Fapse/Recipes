//
//  Settings.swift
//  Recipes
//
//  Created by Fabian Braig on 17.06.21.
//

import SwiftUI
import UIKit

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
		print("Testi")
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
		let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0].appendingPathComponent("recipes.txt")
		do {
			print(path.absoluteString)
			print("... attempting to write")
			try fileContent.write(to: path, atomically: true, encoding: .utf8)
			print("... file written")
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
