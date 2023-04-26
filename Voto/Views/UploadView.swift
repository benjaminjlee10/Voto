//
//  UploadView.swift
//  Voto
//
//  Created by Benjamin Lee on 4/26/23.
//

import SwiftUI
import PhotosUI

struct UploadView: View {
    @EnvironmentObject var pictureVM: PictureViewModel
    @State var upload: Picture
    @State private var selectedImage: Image = Image(systemName: "rectangle.dashed")
    @State private var selectedPhoto: PhotosPickerItem?
    @Environment(\.dismiss) private var dismiss
    @State private var imageURL: URL? // will hold URL of FirebaseStorage image
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Location:")
                .bold()
            TextField("location", text: $upload.location)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom)
            
            Text("Description:")
                .bold()
            TextField("description", text: $upload.description)
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
            if let id = upload.id { // add to VStack - acts like .onAppear
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
                Button("Upload") {
                    Task {
                        let id = await pictureVM.savePicture(picture: upload)
                        if id != nil { // save works
                            upload.id = id
                            await pictureVM.saveImage(id: upload.id ?? "", image: ImageRenderer(content: selectedImage).uiImage ?? UIImage())
                            dismiss()
                        }
                        else { // did not save
                            print("😡 ERROR uploading")
                        }
                    }
                }
            }
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UploadView(upload: Picture(location: "BC", description: "test description here"))
                .environmentObject(PictureViewModel())
        }
    }
}
