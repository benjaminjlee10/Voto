//
//  FriendsListView.swift
//  Voto
//
//  Created by Benjamin Lee on 4/27/23.
//

import SwiftUI

struct FriendsListView: View {
    @StateObject var viewModel = FriendsListViewModel()
    @State private var showingAddFriendSheet = false
    @State private var newFriendName = ""
    @State private var newFriendEmail = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.friends) { friend in
                    Text(friend.name)
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        viewModel.removeFriend(id: viewModel.friends[index].id ?? "")
                    }
                }
            }
            .navigationBarTitle("Friends")
            .navigationBarItems(trailing: Button(action: {
                showingAddFriendSheet = true
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $showingAddFriendSheet) {
                NavigationStack {
                    AddFriendView()
                }
            }
        }
        .onAppear {
            viewModel.fetchFriends()
        }
    }
}


struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView()
    }
}
