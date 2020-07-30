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
    
    public func createDatabaseUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool, Error>)-> ()) {
        guard let email = authDataResult.user.email else {
            return
        }
        db.collection(DatabaseService.instagramUserCollection).document(authDataResult.user.uid).setData(["userEmail": email, "userId": authDataResult.user.uid]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    public func fetchCurrentUser(completion: @escaping (Result<InstagramUser, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseService.instagramUserCollection).document(user.uid).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let users = snapshot.data().map { InstagramUser ($0) }
                completion(.success(users ?? InstagramUser(username: "", userBio: "", userId: "", userFullName: "", userEmail: "")))
            }
        }
    }
    public func updateUserInfo(userId: String, username: String, userBio: String, fullname: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseService.instagramUserCollection).document(user.uid).updateData(["username": username, "userBio": userBio, "userFullName": fullname], completion: { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        })
    }
    //MARK:- Posts
    public func createPost(username: String, userId: String, caption: String, completion: @escaping (Result<String, Error>) -> ()) {
        guard let user = Auth.auth().currentUser, let displayName = user.displayName else { return }
        let documentRef = db.collection(DatabaseService.instagramPostCollection).document()
        db.collection(DatabaseService.instagramPostCollection).document(documentRef.documentID).setData(["username" : displayName, "userId": user.uid, "caption": caption]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(documentRef.documentID))
            }
        }
    }
}
