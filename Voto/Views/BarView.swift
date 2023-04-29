//
//  BarView.swift
//  Voto
//
//  Created by Benjamin Lee on 4/27/23.
//

import SwiftUI

struct BarView: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $selectedIndex) {
                MainView(user: User())
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)
                
                ProfileView(user: User())
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
                    .tag(1)
            }
            .accentColor(.orange)
            
            Rectangle()
                .fill(Color.gray)
                .frame(height: 1)
                .padding(.bottom, 55)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView()
    }
}
