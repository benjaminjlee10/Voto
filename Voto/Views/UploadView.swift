//
//  UploadView.swift
//  ListOfStudents
//
//  Created by Benjamin Lee on 3/27/23.
//

import SwiftUI
import UIKit
import PhotosUI
import FirebaseAuth

struct UploadView: View {
    @EnvironmentObject var uploadVM: UploadViewModel
    @State var upload: Upload
    @State private var selectedImage: Image = Image(systemName: "rectangle.dashed")
    @State private var selectedPhoto: PhotosPickerItem?
    @Environment(\.dismiss) private var dismiss
    @State private var imageURL: URL? // will hold URL of FirebaseStorage image
    var previewRunning = false
    @State var dailyAdjective: String
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Today's Theme: \(dailyAdjective)")
                .font(.title)
                .foregroundColor(.orange)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.vertical)
            
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
                    Image(systemName: "rectangle-dashed")
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
            
            Text("Name:")
                .bold()
            TextField("name", text: $upload.name)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom)
            
            Text("Description:")
                .bold()
            TextField("description", text: $upload.description)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom)
            
            Spacer()
        }
        .task {
            if let id = upload.id { // add to VStack - acts like .onAppear
                if let url = await uploadVM.getImageURL(id: id) { // if this isn't a new place id
                    imageURL = url
                }
            }
        }
        .onAppear {
            
        }
        .font(.title2)
        .padding()
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Upload") {
                    upload.poster = (Auth.auth().currentUser?.email)!
                    upload.adjective = dailyAdjective
                    
                    Task {
                        let id = await uploadVM.saveUpload(upload: upload)
                        if id != nil { // save works
                            upload.id = id
                            await uploadVM.saveImage(id: upload.id ?? "", image: ImageRenderer(content: selectedImage).uiImage ?? UIImage())
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

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UploadView(upload: Upload(name: "test name", description: "just a test description"), dailyAdjective: "test daily adjective")
                .environmentObject(UploadViewModel())
        }
    }
}
