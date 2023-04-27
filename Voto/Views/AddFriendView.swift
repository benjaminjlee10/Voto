//
//  AddFriendView.swift
//  Voto
//
//  Created by Benjamin Lee on 4/27/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

struct AddFriendView: View {
    @State private var searchText = ""
    @State private var searchResults: [User] = []
    @Environment(\.presentationMode) var presentationMode
    let db = Firestore.firestore()
    let userId = Auth.auth().currentUser?.uid ?? ""
    var viewModel = FriendsListViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            .padding(.horizontal, 10)
            
            // Define the SearchBar view here
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search users", text: $searchText, onCommit: searchForUsers)
            }
            .padding(.horizontal, 10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding()
            
            List(searchResults) { user in
                HStack {
                    Text(user.name)
                    Spacer()
                    Button(action: {
                        viewModel.addNewFriend(friend: user)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Add Friend")
                    })
                }
            }
        }
    }
    
    func searchForUsers() {
        db.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: searchText)
            .whereField("username", isLessThanOrEqualTo: searchText + "\u{f8ff}")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error searching for users: \(error.localizedDescription)")
                    return
                }
                
                guard let querySnapshot = querySnapshot else { return }
                
                do {
                    let users = try querySnapshot.documents.compactMap { document -> User? in
                        let user = try document.data(as: User.self)
                        return user
                    }
                    self.searchResults = users
                } catch {
                    print("Error decoding users: \(error.localizedDescription)")
                }
            }
    }
}




struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendView(viewModel: FriendsListViewModel())
    }
}
