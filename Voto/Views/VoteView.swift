//
//  VoteView.swift
//  Voto
//
//  Created by Benjamin Lee on 4/26/23.
//

import SwiftUI

struct VoteView: View {
    @State var upload: Upload
    @State var vote: Vote
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            VStack (alignment: .center) {
                Text(upload.location)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                
                Text(upload.description)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            Text("Click to Vote:")
                .font(.title2)
                .bold()
            HStack {
                UpvoteView(upvote: $vote.vote)
            }
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button ("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

struct VoteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VoteView(upload: Upload(location: "BC TEST", description: "this is a test"), vote: Vote())
        }
    }
}
