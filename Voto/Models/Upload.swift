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
    var location = ""
    var description = ""
    
    var dictionary: [String: Any] {
        return ["location": location, "description": description]
    }
}
