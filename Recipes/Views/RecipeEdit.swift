//
//  RecipeEdit.swift
//  CoreDataDemo
//
//  Created by Fabian Braig on 20.05.21.
//

import SwiftUI

struct RecipeEdit: View {
	@Environment(\.managedObjectContext) var managedObjectContext
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.colorScheme) var colorScheme

	@State private var showingImagePicker = false
	@State private var inputImage: UIImage?

	var recipe: Recipe?

	@State private var image: Image?
	@State private var name: String = ""
	@State private var ingredients: String = ""
	@State private var instructions: String = ""
	
	init() {
	
	}
	
	init(recipe: Recipe) {
		self.recipe = recipe
		
		if recipe.image != nil {
			_image = State(initialValue: Image(uiImage: UIImage(data: recipe.image!)!))
		}
		_name = State(initialValue: recipe.name)
		_ingredients = State(initialValue: recipe.ingredients)
		_instructions = State(initialValue: recipe.instructions)
	}
	
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
							.scaledToFill()
					}
					Text("Tap to select a picture")
						.foregroundColor(.white)
						.font(.headline)
				}
				.onTapGesture {
					self.showingImagePicker = true
				}
				Text("Rezeptname")
					.bold()
				TextEditor(text: $name)
					.lineLimit(1)
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
		.navigationBarTitle(Text("Rezept bearbeiten"), displayMode: .inline)
		.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
			ImagePicker(image: self.$inputImage)
		}
		.onDisappear() {
			if name != "" {
				if recipe == nil {
					let recipe_temp = Recipe(context: managedObjectContext)
					recipe_temp.name = name
					recipe_temp.ingredients = ingredients
					recipe_temp.instructions = instructions
					if (inputImage != nil) {
						recipe_temp.image = inputImage?.jpegData(compressionQuality: 1)
					}
					try? managedObjectContext.save()
				} else {
					recipe!.name = name
					recipe!.ingredients = ingredients
					recipe!.instructions = instructions
					if (inputImage != nil) {
						recipe!.image = inputImage?.jpegData(compressionQuality: 1)
					}
					try? managedObjectContext.save()
				}
			}
			presentationMode.wrappedValue.dismiss()
		}
    }
    
    func loadImage() {
		guard let inputImage = inputImage else {return}
		image = Image(uiImage: inputImage)
	}
}

struct RecipeEdit_Previews: PreviewProvider {
    static var previews: some View {
        RecipeEdit(recipe: previewRecipe)
    }
}
