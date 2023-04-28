//
//  Upload.swift
//  Voto
//
//  Created by Benjamin Lee on 4/26/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Upload: Codable, Identifiable {
    @DocumentID var id: String?
    var name = ""
    var description = ""
    var poster = ""
    var upvotes = 0
    var imageID = ""
    
    var dictionary: [String: Any] {
        return ["name": name, "description": description, "poster": poster, "upvotes": upvotes, "imageID": imageID]
    }
}
