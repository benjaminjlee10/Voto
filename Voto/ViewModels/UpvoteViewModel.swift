//
//  VoteViewModel.swift
//  Voto
//
//  Created by Benjamin Lee on 4/26/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UpvoteViewModel: ObservableObject {
    @Published var upvotes: Int = 0
    var didUpvote = false
    let db = Firestore.firestore()
    
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
    
    func upvoteButtonAction(upload: Upload) {
        guard let id = upload.id else { return }
        let docRef = db.collection("uploads").document(id)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let document: DocumentSnapshot
            do {
                try document = transaction.getDocument(docRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let oldUpvotes = document.data()?["upvotes"] as? Int else {
                let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Unable to retrieve upvotes from snapshot \(document)"
                ])
                errorPointer?.pointee = error
                return nil
            }
            
            let newUpvotes = oldUpvotes + 1
            transaction.updateData(["upvotes": newUpvotes], forDocument: docRef)
            return newUpvotes
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error.localizedDescription)")
            } else {
                print("Transaction successfully committed!")
            }
        }
    }
}
