//
//  InstagramFeedViewController.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/3/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class InstagramFeedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    
    

}
extension InstagramFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth: CGFloat = UIScreen.main.bounds.size.width
        let itemWidth: CGFloat = maxWidth * 0.80
        return CGSize(width: itemWidth, height: itemWidth)
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
