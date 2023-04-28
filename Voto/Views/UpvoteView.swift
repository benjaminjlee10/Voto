//
//  UpvoteView.swift
//  Voto
//
//  Created by Benjamin Lee on 4/26/23.
//

import SwiftUI

struct UpvoteView: View {
    @State var upload: Upload
    @StateObject var upvoteVM = UpvoteViewModel()
    
    var body: some View {
        VStack {
//            Text("Upvotes: \(upvoteVM.upvotes)")
            Button {
                upvoteVM.didToggleUpvote()
                upload.upvotes += 1
            } label: {
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
        UpvoteView(upload: Upload(name: "sample name", description: "sample description", poster: "sample poster"))
    }
}
