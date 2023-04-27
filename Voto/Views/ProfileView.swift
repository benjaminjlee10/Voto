//
//  ProfileView.swift
//  Voto
//
//  Created by Benjamin Lee on 4/27/23.
//

import SwiftUI

struct ProfileView: View {
    let user: User
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            
            Text(user.name)
                .font(.title)
            
            Divider()
            
            HStack {
                Text("Email:")
                Spacer()
                Text(user.email)
            }
            .padding()
            
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: User(name: "test name", email: "testemail@bc.edu"))
    }
}

