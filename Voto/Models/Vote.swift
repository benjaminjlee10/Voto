//
//  Vote.swift
//  Voto
//
//  Created by Benjamin Lee on 4/26/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Vote: Identifiable, Codable {
    @DocumentID var id: String?
    var vote = ""
    var comment = ""
    var commenter = ""
    var postedOn = Date()
    
    var dictionary: [String: Any] {
        return ["vote": vote, "comment": comment, "commenter": commenter, "postedOn": Timestamp(date: Date())]
    }
}
