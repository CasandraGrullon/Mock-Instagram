//
//  StorageService.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/5/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService {
    private let storageRef = Storage.storage().reference()
    
    public func uploadPhoto(userId: String? = nil, postId: String? = nil, image: UIImage, completion: @escaping (Result<URL, Error>) -> () ){
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        var photoReference: StorageReference!
        
        if let userId = userId {
            photoReference = storageRef.child("UserProfilePhotos/\(userId).jpg")
        } else if let postId = postId {
            photoReference = storageRef.child("InstagramPosts/\(postId).jpg")
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let _ = photoReference.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                photoReference.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
            
        }
        
    }
}
