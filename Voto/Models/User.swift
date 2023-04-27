//
//  User.swift
//  Voto
//
//  Created by Benjamin Lee on 4/27/23.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var name = ""
    var email = ""
}
