//
//  VoteViewModel.swift
//  Voto
//
//  Created by Benjamin Lee on 4/26/23.
//

import Foundation

class UpvoteViewModel: ObservableObject {
    @Published var upvotes: Int = 0
    var didUpvote = false
    
    func didToggleUpvote() {
        if didUpvote {
            upvotes -= 1
            didUpvote = false
        }
        else {
            upvotes += 1
            didUpvote = true
        }
    }
}
