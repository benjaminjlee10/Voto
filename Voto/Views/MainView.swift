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
    @EnvironmentObject var uploadVM: UploadViewModel
    @FirestoreQuery(collectionPath: "uploads") var uploads: [Upload]
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    @State private var currentTime = Date()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(currentTime.hourAndMinute)")
                
                List {
                    ForEach(uploads) { upload in
                        NavigationLink {
                            VoteView(upload: upload, vote: Vote())
                        } label: {
                            Text(upload.name)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Posts of the Day")
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

private extension Date {
    var hourAndMinute: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
