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
    @EnvironmentObject var pictureVM: UploadViewModel
    @FirestoreQuery(collectionPath: "pictures") var pictures: [Upload]
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(pictures) { picture in
                    NavigationLink {
                        VoteView(upload: picture, vote: Vote())
                    } label: {
                        HStack {
                            Text("test")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Pictures of the Day")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
                UploadView(upload: Upload())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(UploadViewModel())
    }
}
