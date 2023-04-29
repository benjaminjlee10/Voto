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
                ForEach(uploads) { upload in
                    NavigationLink {
                        VoteView(upload: upload, vote: Vote())
                    } label: {
                        HStack {
                            Text(upload.name)
                            
                            Spacer()
                            
                            Text("Theme: \(upload.adjective)")
                        }
                    }
                }
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    dismiss()
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
