//
//  ProfileView.swift
//  Voto
//
//  Created by Benjamin Lee on 4/27/23.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State var user: User
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            
            TextField("Name", text: $userVM.user.name)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .padding()
            
            HStack {
                Text("Email:")
                Text(Auth.auth().currentUser?.email ?? "")
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding()
            
            Spacer()
            
            Button {
                Task {
                    user.name = userVM.user.name
                    let id = await userVM.saveUser(user: user)
                    if id != nil {
                        print("Updated current user's name to \(user)")
                    }
                    else {
                        print("ERROR saving user name")
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
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: User())
            .environmentObject(UserViewModel())
    }
}

