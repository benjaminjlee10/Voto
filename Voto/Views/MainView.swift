//
//  MainView.swift
//  Voto
//
//  Created by Benjamin Lee on 4/26/23.
// 

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct MainView: View {
    @EnvironmentObject var pictureVM: PictureViewModel
    @FirestoreQuery(collectionPath: "pictures") var pictures: [Picture]
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(pictures) { picture in
                    NavigationLink {
                        Text("filler")
                    } label: {
                        Text(picture.description)
                        Text(picture.location)
                    }
                }
            }
            .listStyle(.plain)
            .font(.title2)
            .navigationTitle("Pictures Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("🪵➡️ Log out successful")
                            dismiss()
                        } catch {
                            print("😡 ERROR: Could not sign out")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            NavigationStack {
                DetailView(pictureName: Picture())
                    .environmentObject(PictureViewModel())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(PictureViewModel())
    }
}
