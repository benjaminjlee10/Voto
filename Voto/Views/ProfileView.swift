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
    @FirestoreQuery(collectionPath: "uploads") var uploads: [Upload]
    @Environment(\.dismiss) private var dismiss
    
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
                            .font(.title2)
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                            .font(.title2)
                    }
                    .padding()
                }
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.yellow)
                    .padding()
                
                TextField("Name", text: $user.name)
                    .font(.title2)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .submitLabel(.done)
                    .padding()
                
                ZStack {
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 365, height: 40)
                        .cornerRadius(20)
                    
                    HStack {
                        Text("Email:")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        Text(Auth.auth().currentUser?.email ?? "")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal, 35)
                
                HStack {
                    NavigationLink {
                        ProfilePostsView(uploads: getUserUploads())
                    } label: {
                        HStack {
                            Text("My Uploads")
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .font(.title3)
                        .bold()
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.yellow)
                        .clipShape(Rectangle())
                        .cornerRadius(40)
                    }
                    .shadow(color: .gray, radius: 2)
                    
                    Spacer()
                }
                .padding()
                
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
                        .foregroundColor(.black)
                        .background(Color.yellow)
                        .cornerRadius(40)
                }
                .padding()
            }
            .onAppear {
                userVM.loadUser()
                user = userVM.user
            }
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.yellow.opacity(0.2), Color.yellow.opacity(0.1)]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
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

