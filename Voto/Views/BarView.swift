//
//  BarView.swift
//  Voto
//
//  Created by Benjamin Lee on 4/27/23.
//

import SwiftUI

struct BarView: View {    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            FriendsListView()
                .tabItem {
                    Image(systemName: "person.2")
                    Text("Friends")
                }
            ProfileView(user: User())
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView()
    }
}
