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

	@State private var showingImagePicker = false
	@State private var inputImage: UIImage?

	var recipe: Recipe

	@State private var image: Image?
	@State private var name: String = ""
	@State private var ingredients: String = ""
	@State private var instructions: String = ""
	
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
        NavigationView {
			VStack {
				ZStack{
					Rectangle()
						.fill(Color.secondary)
					if image != nil {
						image?
							.resizable()
							.scaledToFill()
						Text("Tap to choose other picture")
							.foregroundColor(.white)
							.font(.headline)
					} else {
						Text("Tap to select a picture")
							.foregroundColor(.white)
							.font(.headline)
					}
				}
				.onTapGesture {
					self.showingImagePicker = true
				}
					
				Form {
					Section(header: Text("Rezeptname")) {
						TextField("Name", text: $name)
					}
					Section(header: Text("Zutaten")) {
						TextEditor(text: $ingredients)
							.frame(height: 150)
					}
					Section(header: Text("Kochanleitung")) {
						TextEditor(text: $instructions)
							.frame(height: 150)
					}
				}
				.navigationBarTitle(Text("Rezept bearbeiten"), displayMode: .inline)
				.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
					ImagePicker(image: self.$inputImage)
				}
				.onDisappear() {
					if !recipe.name.isEmpty {
						recipe.name = name
						recipe.ingredients = ingredients
						recipe.instructions = instructions
						if (inputImage != nil) {
							recipe.image = inputImage?.pngData()
						}
						try? managedObjectContext.save()
					}
					presentationMode.wrappedValue.dismiss()
				}
			}
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
