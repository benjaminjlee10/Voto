//
//  UpvoteView.swift
//  Voto
//
//  Created by Benjamin Lee on 4/26/23.
//

import SwiftUI

struct UpvoteView: View {
    @StateObject var upvoteVM = UpvoteViewModel()
    
    var body: some View {
        VStack {
            Text("Upvotes: \(upvoteVM.upvotes)")
            Button(action: upvoteVM.didToggleUpvote) {
                Image(systemName: "hand.thumbsup")
            }
            .foregroundColor(upvoteVM.didUpvote ? .blue : .gray)
            .font(.largeTitle)
        }
        .padding(.bottom)
    }
}

struct UpvoteView_Previews: PreviewProvider {
    static var previews: some View {
        UpvoteView()
    }
}
