//
//  ProfileView.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/3/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePictureIV.clipsToBounds = true
        profilePictureIV.layer.cornerRadius = 13
        addProfilePictureButton.clipsToBounds = true
        addProfilePictureButton.layer.cornerRadius = 13
    }
    
    public lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        return scroll
    }()
    public lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    public lazy var profilePictureIV: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person")
        return imageView
    }()
    public lazy var addProfilePictureButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9599753022, green: 0.2773778737, blue: 0.742610991, alpha: 1)
        button.tintColor = .white
        return button
    }()
    public lazy var labelNumbersStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [numberOfPosts, numberOfFollowers, numberFollowing])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    public lazy var numberOfPosts: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "# of posts"
        label.font = UIFont(name: "Euphemia UCAS", size: 17)
        return label
    }()
    public lazy var numberOfFollowers: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "# of followers"
        label.font = UIFont(name: "Euphemia UCAS", size: 17)
        return label
    }()
    public lazy var numberFollowing: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "# following"
        label.font = UIFont(name: "Euphemia UCAS", size: 17)
        return label
    }()
    public lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(name: "Euphemia UCAS", size: 17)
        label.textAlignment = .left
        return label
    }()
    public lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Euphemia UCAS", size: 17)
        label.textAlignment = .left
        return label
    }()
    public lazy var segmentedControll: UISegmentedControl = {
        let items = [UIImage(systemName: "rectangle.split.3x3"), UIImage(systemName: "app")]
        let segment = UISegmentedControl(items: items as [Any])
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = .white
        segment.tintColor = .systemGray
        segment.selectedSegmentTintColor = #colorLiteral(red: 0.9599753022, green: 0.2773778737, blue: 0.742610991, alpha: 1)
        return segment
    }()
    public var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit() {
        scrollConstraints()
        contentViewConstraints()
    }
    
    private func scrollConstraints() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let width = self.bounds.width
        let height = self.bounds.height
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: width),
            scrollView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    private func contentViewConstraints() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    private func profilePictureConstraint() {
        addSubview(profilePictureIV)
        profilePictureIV.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profilePictureIV.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            profilePictureIV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
        
        ])
    }
//    private func addButtonConstraints() {
//        addSubview(addProfilePictureButton)
//        addProfilePictureButton.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            addProfilePictureButton.topAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutYAxisAnchor>#>)
//        ])
//    }
    
}
