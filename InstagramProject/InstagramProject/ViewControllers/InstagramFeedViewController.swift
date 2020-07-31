//
//  InstagramFeedViewController.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/3/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import FirebaseFirestore

class InstagramFeedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var listener: ListenerRegistration?
    private var instagramPosts = [InstagramPost]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            if instagramPosts.isEmpty {
                collectionView.backgroundView = EmptyView(title: "No Posts!", message: "Add a new post or follow another user to see more posts!")
            } else {
                collectionView.backgroundView = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        listener = Firestore.firestore().collection(DatabaseService.instagramPostCollection).addSnapshotListener({ (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Fire Store Error", message: "\(error)")
                }
            } else if let snapshot = snapshot {
                let posts = snapshot.documents.map {InstagramPost ($0.data()) }
                self.instagramPosts = posts
            }
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listener?.remove()
    }
}
extension InstagramFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth: CGFloat = UIScreen.main.bounds.size.width
        let itemWidth: CGFloat = maxWidth
        return CGSize(width: itemWidth, height: itemWidth * 0.90)
    }

}
extension InstagramFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instagramPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "instagramFeedCell", for: indexPath) as? InstagramFeedCell else {
            fatalError("could not cast to instagram feed cell")
        }
        if instagramPosts.isEmpty {
            cell.backgroundView = EmptyView(title: "Empty", message: "add a post!")
        } else {
            let post = instagramPosts[indexPath.row]
           cell.configureCell(post: post)
        }
        
        return cell
    }
    
    
}
