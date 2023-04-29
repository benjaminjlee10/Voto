//
//  ProfileView.swift
//  Voto
//
//  Created by Benjamin Lee on 4/27/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ProfileView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State var user: User
    @Environment(\.dismiss) private var dismiss
    @FirestoreQuery(collectionPath: "uploads") var uploads: [Upload]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        do {
                            try Auth.auth().signOut()
                            print("🪵➡️ Log out successful")
                            dismiss()
                        } catch {
                            print("😡 ERROR: Could not sign out")
                        }
                    } label: {
                        Text("Sign Out")
                            .foregroundColor(.red)
                            .font(.title3)
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                            .font(.title3)
                    }
                    .padding()
                }
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding()
                
                TextField("Name", text: $user.name)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .submitLabel(.done)
                    .padding()
                
                HStack {
                    Text("Email:")
                        .bold()
                    Text(Auth.auth().currentUser?.email ?? "")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding()
                
                NavigationLink {
                    ProfilePostsView(uploads: getUserUploads())
                } label: {
                    Text("My Uploads")
                }
                .font(.title2)
                .bold()
                .foregroundColor(.orange)
                .cornerRadius(40)
                
                Spacer()
                
                Button {
                    Task {
                        let currentUser = Auth.auth().currentUser
                        if currentUser != nil {
                            userVM.user.name = user.name
                            
                            let id = await userVM.saveUser(user: userVM.user)
                            if id != nil {
                                print("Updated current user's name to \(user)")
                            }
                            else {
                                print("ERROR saving user name")
                            }
                        } else {
                            print("No user logged in")
                        }
                    }
                } label: {
                    Text("Save")
                        .fontWeight(.semibold)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(40)
                }
                .padding()
            }
            .onAppear {
                userVM.loadUser()
                user = userVM.user
        }
        }
    }
    
    func getUserUploads() -> [Upload] {
        guard let email = Auth.auth().currentUser?.email else {
            return []
        }
        return uploads.filter{ $0.poster == email }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: User())
            .environmentObject(UserViewModel())
    }
}

