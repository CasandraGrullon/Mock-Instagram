//
//  Gradient.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/3/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
  @IBInspectable var cornerRadius: CGFloat = 0
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.masksToBounds = true
    layer.cornerRadius = cornerRadius
    let gradientLayer = CAGradientLayer()
    let colors = [UIColor.systemBackground.cgColor, UIColor.systemOrange.cgColor]
    gradientLayer.frame = bounds
    gradientLayer.colors = colors
    layer.addSublayer(gradientLayer)
  }
}
