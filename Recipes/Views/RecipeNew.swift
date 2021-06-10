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
        NavigationView {
			VStack {
				ZStack{
					Rectangle()
						.fill(Color.secondary)
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
