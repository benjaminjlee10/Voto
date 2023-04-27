//
//  DetailView.swift
//  ListOfStudents
//
//  Created by Benjamin Lee on 3/27/23.
//

import SwiftUI
import PhotosUI

struct DetailView: View {
    @EnvironmentObject var pictureVM: PictureViewModel
    @State var pictureName: Picture
    @State private var selectedImage: Image = Image(systemName: "photo")
    @State private var selectedPhoto: PhotosPickerItem?
    @Environment(\.dismiss) private var dismiss
    @State private var imageURL: URL? // will hold URL of FirebaseStorage image
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Location:")
                .bold()
            TextField("location", text: $pictureName.location)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom)
            
            Text("Description:")
                .bold()
            TextField("description", text: $pictureName.description)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom)
            
            HStack {
                Text("Upload Image:")
                    .bold()
                
                Spacer()
                
                PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                    Label("", systemImage: "square.and.arrow.up.circle")
                }
                .onChange(of: selectedPhoto) { newValue in
                    Task {
                        do {
                            if let data = try await newValue?.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: data) {
                                    selectedImage = Image(uiImage: uiImage)
                                    imageURL = nil
                                }
                            }
                        } catch {
                            print("😡 ERROR: loading failed \(error.localizedDescription)")
                        }
                    }
                }
            }
            
            if imageURL != nil {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Image(systemName: "rectangle.dashed")
                        .resizable()
                        .scaledToFit()
                }
                .frame(maxWidth: .infinity)
            }
            else {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
            
            Spacer()
        }
        .task {
            if let id = pictureName.id { // add to VStack - acts like .onAppear
                if let url = await pictureVM.getImageURL(id: id) { // if this isn't a new place id
                    imageURL = url
                }
            }
        }
        .font(.title2)
        .padding()
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    Task {
                        let id = await pictureVM.savePicture(picture: pictureName)
                        if id != nil { // save works
                            pictureName.id = id
                            await pictureVM.saveImage(id: pictureName.id ?? "", image: ImageRenderer(content: selectedImage).uiImage ?? UIImage())
                            dismiss()
                        }
                        else { // did not save
                            print("😡 ERROR saving")
                        }
                    }
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailView(pictureName: Picture(location: "test location", description: "just a test description"))
                .environmentObject(PictureViewModel())
        }
    }
}
