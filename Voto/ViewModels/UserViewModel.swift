//
//  UserViewModel.swift
//  Voto
//
//  Created by Benjamin Lee on 4/27/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class UserViewModel: ObservableObject {
    @Published var user = User()
    private var userId: String?
    
    func loadUser() {
        let db = Firestore.firestore()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("Error getting user document: \(error)")
            } else {
                if let document = document, document.exists {
                    let data = document.data()!
                    let name = data["name"] as! String
                    self.user = User(name: name)
                }
            }
        }
    }
    
    func saveUser(user: User) async -> String? {
        let db = Firestore.firestore()
        let userID = user.id ?? Auth.auth().currentUser?.uid ?? ""
        do {
            var userData = user.dictionary
            userData["name"] = user.name
            let _ = try await db.collection("users").document(userID).setData(user.dictionary)
            print("😎 Data added successfully!")
            return userID
        } catch {
            print("😡 ERROR: could not save new user in 'users' \(error.localizedDescription)")
            return nil
        }
    }
}
