//
//  VoteView.swift
//  Voto
//
//  Created by Benjamin Lee on 4/26/23.
//

import SwiftUI

struct VoteView: View {
    @EnvironmentObject var uploadVM: UploadViewModel
    @State var upload: Upload
    @State var vote: Vote
    @Environment(\.dismiss) private var dismiss
    @State private var imageURL: URL? // will hold URL of FirebaseStorage image
    @State private var selectedImage: Image = Image(systemName: "rectangle.dashed")
    
    var body: some View {
        VStack {
            VStack (alignment: .center) {
                Text(upload.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                
                Text(upload.description)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
            
            if imageURL != nil {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Image(systemName: "rectangle.dashed")
                        .resizable()
                        .scaledToFit()
                }
                .frame(maxWidth: .infinity)
            }
            else {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
            
            Spacer()
            
            Text("Click to Vote:")
                .font(.title2)
                .bold()
            HStack {
                UpvoteView(upvote: $vote.vote)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden()
        .task {
            if let id = upload.id { // add to VStack - acts like .onAppear
                if let url = await uploadVM.getImageURL(id: id) { // if this isn't a new place id
                    imageURL = url
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button ("Back") {
                    dismiss()
                }
            }
        }
    }
}

struct VoteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VoteView(upload: Upload(name: "Sample Name", description: "sample description"), vote: Vote())
        }
    }
}
