//
//  RecipeNew.swift
//  Recipes
//
//  Created by Fabian Braig on 02.06.21.
//

import SwiftUI

struct RecipeNew: View {
	@Environment(\.managedObjectContext) var managedObjectContext
	@Environment(\.presentationMode) var presentationMode
	
	@State private var showingImagePicker = false
	@State private var inputImage: UIImage?

	@State private var image: Image?
	@State private var name: String = ""
	@State private var ingredients: String = ""
	@State private var instructions: String = ""

    var body: some View {
        ScrollView {
			VStack {
				ZStack{
					Rectangle()
						.fill(Color.secondary)
						.frame(minHeight: 100)
						if image != nil {
							image?
								.resizable()
								.scaledToFit()
						} else {
							Text("Tap to select a picture")
								.foregroundColor(.white)
								.font(.headline)
						}
				}
				.onTapGesture {
					self.showingImagePicker = true
				}
				Text("Rezeptname")
					.bold()
				TextField("Name", text: $name)
					.background(Color.white)
				Text("Zutaten")
					.bold()
				TextEditor(text: $ingredients)
					.frame(height: 120)
				Text("Kochanleitung")
					.bold()
				TextEditor(text: $instructions)
					.frame(height: 120)
			}
		}
		.padding()
		.background(Color.gray.opacity(0.2))
		.navigationBarTitle(Text("Rezept anlegen"), displayMode: .inline)
		.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
			ImagePicker(image: self.$inputImage)
		}
		.onDisappear() {
			if !name.isEmpty {
				let recipe = Recipe(context: managedObjectContext)
				recipe.name = name
				recipe.ingredients = ingredients
				recipe.instructions = instructions
				recipe.image = inputImage?.pngData()
				recipe.uuid = UUID()
				recipe.created = Date()
				try? managedObjectContext.save()
			}
			presentationMode.wrappedValue.dismiss()
		}
    }
    
    func loadImage() {
		guard let inputImage = inputImage else {return}
		image = Image(uiImage: inputImage)
	}
}

struct RecipeNew_Previews: PreviewProvider {
    static var previews: some View {
        RecipeNew()
    }
}
