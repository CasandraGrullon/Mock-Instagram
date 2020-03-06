//
//  DatabaseService.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/6/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

private let db = Firestore.firestore()

class DatabaseService {
    static let instagramPostCollection = "posts"
    static let instagramUserCollection = "users"
    
    public func createUser(username: String, userBio: String, userId: String, userFullName: String, userEmail: String, completion: @escaping (Result<String, Error>) -> ()){
        
        guard let user = Auth.auth().currentUser, let displayName = user.displayName, let email = user.email else { return }
        let documentRef = db.collection(DatabaseService.instagramUserCollection).document()
        db.collection(DatabaseService.instagramUserCollection).document(documentRef.documentID).setData(["username": displayName, "userBio": userBio, "userId": user.uid, "userFullName": userFullName, "userEmail": email]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(documentRef.documentID))
            }
        }
        
    }
    
    public func createPost(username: String, userId: String, caption: String, photoURL: String, completion: @escaping (Result<String, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser, let displayName = user.displayName else { return }
        let documentRef = db.collection(DatabaseService.instagramPostCollection).document()
        db.collection(DatabaseService.instagramPostCollection).document(documentRef.documentID).setData(["username" : displayName, "userId": user.uid, "caption": caption, "photoURL": photoURL]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(documentRef.documentID))
            }
        }
        
    }
}
