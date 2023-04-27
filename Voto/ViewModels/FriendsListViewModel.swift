//
//  FriendsListViewModel.swift
//  Voto
//
//  Created by Benjamin Lee on 4/27/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FriendsListViewModel: ObservableObject {
    @Published var friends: [User] = []
    
    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser?.uid ?? ""
    
    public func getDatabase() -> Firestore {
        return db
    }
    
    func addNewFriend(friend: User) {
        do {
            let _ = try db.collection("users").document(friend.id ?? "").setData(from: friend)
        } catch {
            print("Error adding friend: \(error.localizedDescription)")
        }
    }
    
    func removeFriend(id: String) {
        db.collection("users").document(id).delete { error in
            if let error = error {
                print("Error removing friend: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFriends() {
        db.collection("users").addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching friends: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                self.friends = try snapshot.documents.compactMap { document in
                    try document.data(as: User.self)
                }
            } catch {
                print("Error decoding friends: \(error.localizedDescription)")
            }
        }
    }
}
