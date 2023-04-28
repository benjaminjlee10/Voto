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
            MainView(user: User())
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
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
