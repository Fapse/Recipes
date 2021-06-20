//
//  Settings.swift
//  Recipes
//
//  Created by Fabian Braig on 17.06.21.
//

import SwiftUI

struct Settings: View {
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
		writeToFile()
	}
    
    func deleteRecipeDatabase(){
    
	}



    func saveFile() {
		let str = "My string"
		let filename = getDocumentsDirectory()?.appendingPathComponent("output.txt")
		do {
			try str.write(to: filename!, atomically: true, encoding: String.Encoding.utf8)
		} catch {
			print("Problem saving file")
		// failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
		}
	}
	
	func writeToFile() {
		let todos = "Eat;Sleep;Repeat;TV"
		let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0].appendingPathComponent("recipes.txt")
		do {
			print(path.absoluteString)
			print("... attempting to write")
			try todos.write(to: path, atomically: true, encoding: .utf8)
			print("... file writtem")
		} catch {
			print(error.localizedDescription)
		}
	}
    
    func getDocumentsDirectory() -> URL? {
		let paths = FileManager.default.urls(for: .allLibrariesDirectory, in: .userDomainMask)
		print(paths.count)
		var url: URL?
		if (paths.count > 0) {
			for path in paths {
				print (path)
			}
			url = paths[0]
		}
		//print(paths[0])
		return url
	}
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
