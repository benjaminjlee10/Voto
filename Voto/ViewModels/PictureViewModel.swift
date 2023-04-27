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

class PictureViewModel: ObservableObject {
    @Published var picture = Picture()
    
    func savePicture(picture: Picture) async -> String? {
        let db = Firestore.firestore()
        if let id = picture.id { // picture must already exist, so save
            do {
                try await db.collection("pictures").document(id).setData(picture.dictionary)
                print("😎 Data updated successfully!")
                return picture.id
            } catch {
                print("😡 ERROR: Could not update data in 'pictures' \(error.localizedDescription)")
                return nil
            }
        } else { // no id? Then this must be a new student to add
            do {
                let docRef = try await db.collection("pictures").addDocument(data: picture.dictionary)
                print("🐣 Data added successfully!")
                return docRef.documentID
            } catch {
                print("😡 ERROR: Could not create a new picture in 'pictures' \(error.localizedDescription)")
                return nil
            }
        }
    }
    
//    func deleteData(picture: Picture) async {
//        let db = Firestore.firestore()
//
//        guard let id = picture.id else {
//            print("😡 ERROR: id was nil. This should not have happened")
//            return
//        }
//
//        do {
//            try await db.collection("pictures").document(id).delete()
//            print("🗑️Document successfully removed")
//        } catch {
//            print("😡 ERROR:removing document \(error.localizedDescription)")
//            return
//        }
//    }
    
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
}
