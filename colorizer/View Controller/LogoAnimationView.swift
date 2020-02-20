//
//  LogoAnimationView.swift
//  colorizer
//
//  Created by Sumant Sogikar on 16/02/20.
//  Copyright © 2020 Nandan. All rights reserved.
//
import UIKit
import SwiftyGif
extension UIView {

func pinEdgesToSuperView() {
    guard let superView = superview else { return }
    translatesAutoresizingMaskIntoConstraints = false
    topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
    leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
    bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
}
}
class LogoAnimationView: UIView {
    
    let logoGifImageView: UIImageView = {
        guard let gifImage = try? UIImage(gifName: "dropAnimation.gif") else {
            return UIImageView()
        }
        return UIImageView(gifImage: gifImage, loopCount: 3)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
         addSubview(logoGifImageView)
        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
        logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logoGifImageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        logoGifImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    
    
    }
}
