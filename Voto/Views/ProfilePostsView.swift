//
//  ProfilePostsView.swift
//  Voto
//
//  Created by Benjamin Lee on 4/28/23.
//

import SwiftUI

struct ProfilePostsView: View {
    @Environment(\.dismiss) private var dismiss
    var uploads: [Upload]
    
    var body: some View {
        VStack {
            List(uploads) { upload in
                NavigationLink {
                    VoteView(upload: upload, vote: Vote())
                } label: {
                    HStack {
                        Text(upload.name)
                        
                        Spacer()
                        
                        Text("(\(upload.adjective))")
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                }
            }
            .listStyle(.plain)
        }
        .font(.title2)
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors: [Color.yellow.opacity(0.2), Color.yellow.opacity(0.1)]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
        }
    }
}

struct ProfilePostsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePostsView(uploads: [Upload(name: "filler1", description: "filler2", adjective: "wonderful")])
    }
}
