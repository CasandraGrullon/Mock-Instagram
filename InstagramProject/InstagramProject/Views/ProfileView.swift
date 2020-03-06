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
        addProfilePictureButton.layer.cornerRadius = 14
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
        imageView.backgroundColor = .systemGray
        imageView.image = UIImage(systemName: "person")
        return imageView
    }()
    public lazy var addProfilePictureButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9599753022, green: 0.2773778737, blue: 0.742610991, alpha: 1)
        button.tintColor = .white
        return button
    }()
    public lazy var statsLabelsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [numberOfPosts, numberOfFollowers, numberFollowing])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.backgroundColor = .black
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    public lazy var numberOfPosts: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "# of \nposts"
        label.font = UIFont(name: "Euphemia UCAS", size: 17)
        return label
    }()
    public lazy var numberOfFollowers: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "# of \nfollowers"
        label.font = UIFont(name: "Euphemia UCAS", size: 17)
        return label
    }()
    public lazy var numberFollowing: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "# \nfollowing"
        label.font = UIFont(name: "Euphemia UCAS", size: 17)
        return label
    }()
    public lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(name: "Euphemia UCAS", size: 17)
        label.textAlignment = .left
        label.text = "full name"
        return label
    }()
    public lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Euphemia UCAS", size: 17)
        label.textAlignment = .left
        label.text = "bio"
        return label
    }()
    public lazy var segmentedControll: UISegmentedControl = {
        let items = [UIImage(systemName: "rectangle.split.3x3"), UIImage(systemName: "app")]
        let segment = UISegmentedControl(items: items as [Any])
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = .white
        segment.tintColor = .white
        segment.selectedSegmentTintColor = #colorLiteral(red: 0.9599753022, green: 0.2773778737, blue: 0.742610991, alpha: 1)
        segment.alpha = 0.5
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
        profilePictureConstraint()
        addButtonConstraints()
        statsStackConstraints()
        nameLabelConstraints()
        bioConstraints()
        segmentConstraints()
        collectionConstraints()
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
            profilePictureIV.widthAnchor.constraint(equalToConstant: 100),
            profilePictureIV.heightAnchor.constraint(equalTo: profilePictureIV.widthAnchor)
        ])
    }
    private func addButtonConstraints() {
        addSubview(addProfilePictureButton)
        addProfilePictureButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            addProfilePictureButton.topAnchor.constraint(equalTo: profilePictureIV.bottomAnchor, constant: -20),
            addProfilePictureButton.leadingAnchor.constraint(equalTo: profilePictureIV.trailingAnchor, constant: -20),
            addProfilePictureButton.widthAnchor.constraint(equalTo: profilePictureIV.widthAnchor, multiplier: 0.3),
            addProfilePictureButton.heightAnchor.constraint(equalTo: addProfilePictureButton.widthAnchor)
        ])
    }
    private func statsStackConstraints() {
        addSubview(statsLabelsStack)
        statsLabelsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statsLabelsStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            statsLabelsStack.leadingAnchor.constraint(equalTo: profilePictureIV.trailingAnchor, constant: 20),
            statsLabelsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            statsLabelsStack.heightAnchor.constraint(equalTo: profilePictureIV.heightAnchor, multiplier: 0.5)
        ])
    }
    private func nameLabelConstraints() {
        addSubview(fullNameLabel)
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: profilePictureIV.bottomAnchor, constant: 20),
            fullNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            fullNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    private func bioConstraints() {
        addSubview(bioLabel)
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bioLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            bioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    private func segmentConstraints() {
        addSubview(segmentedControll)
        segmentedControll.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControll.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 20),
            segmentedControll.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControll.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControll.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func collectionConstraints() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: segmentedControll.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
