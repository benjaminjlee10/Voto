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
    private let db = Firestore.firestore()
    private var userId: String?
    
    func loadUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("Error getting user document: \(error)")
            } else {
                if let document = document, document.exists {
                    let data = document.data()!
                    self.user = User(name: data["name"] as! String, email: data["email"] as! String)
                }
            }
        }
    }
    
    func saveUser(user: User) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).setData([
            "name": user.name,
            "email": user.email
        ], merge: true) { error in
            if let error = error {
                print("Error saving user document: \(error)")
            }
        }
    }
}
