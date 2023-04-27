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
    @State private var name = ""
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
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
                userVM.user.name = name
                userVM.saveUser(user: userVM.user)
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
            name = userVM.user.name
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserViewModel())
    }
}

