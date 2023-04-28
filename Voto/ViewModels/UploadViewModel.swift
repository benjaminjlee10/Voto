//
//  PictureViewModel.swift
//  Voto
//
//  Created by Benjamin Lee on 4/26/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

class UploadViewModel: ObservableObject {
    @Published var upload = Upload()
    
    func saveUpload(upload: Upload) async -> String? {
        let db = Firestore.firestore()
        if let id = upload.id { // upload must already exist, so save
            do {
                try await db.collection("uploads").document(id).setData(upload.dictionary)
                print("😎 Data updated successfully!")
                return upload.id
            } catch {
                print("😡 ERROR: Could not update data in 'uploads' \(error.localizedDescription)")
                return nil
            }
        } else { // no id? Then this must be a new upload to add
            do {
                let docRef = try await db.collection("uploads").addDocument(data: upload.dictionary)
                print("🐣 Data added successfully!")
                return docRef.documentID
            } catch {
                print("😡 ERROR: Could not create a new upload in 'uploads' \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    func deleteData(picture: Upload) async {
        let db = Firestore.firestore()

        guard let id = picture.id else {
            print("😡 ERROR: id was nil. This should not have happened")
            return
        }

        do {
            try await db.collection("pictures").document(id).delete()
            print("🗑️Document successfully removed")
        } catch {
            print("😡 ERROR:removing document \(error.localizedDescription)")
            return
        }
    }
    
    func saveImage(id: String, image: UIImage) async {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(id)/image.jpg")
        
        let resizedImage = image.jpegData(compressionQuality: 0.2)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let resizedImage = resizedImage {
            do {
                let metadata = try await storageRef.putDataAsync(resizedImage)
                print("Metadata: ", metadata)
                print("📸 Image Saved!")
            } catch {
                print("😡 ERROR: uploading image to FirebaseStorage \(error.localizedDescription)")
            }
        }
    }
    
    func getImageURL(id: String) async -> URL? {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(id)/image.jpg")
        
        do {
            let url = try await storageRef.downloadURL()
            return url
        } catch {
            return nil
        }
    }
    
    func updateUpload(upload: Upload) {
        let db = Firestore.firestore()
        
        do {
            try db.collection("uploads").document(upload.id!).setData(from: upload)
            print("Upload has been updated!")
        } catch {
            print(error.localizedDescription)
        }
    }
}
