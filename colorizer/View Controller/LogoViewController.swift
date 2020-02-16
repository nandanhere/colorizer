//
//  LogoViewController.swift
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
class LogoViewController: UIView {
let logoGifImageView: UIImageView = {
    guard let gifImage = try? UIImage(gifName: "Dropper.gif") else {
        return UIImageView()
    }
    return UIImageView(gifImage: gifImage, loopCount: 1)
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
    backgroundColor = UIColor(white: 246.0 / 255.0, alpha: 1)
    addSubview(logoGifImageView)
    logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
    logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    logoGifImageView.widthAnchor.constraint(equalToConstant: 280).isActive = true
    logoGifImageView.heightAnchor.constraint(equalToConstant: 108).isActive = true
}

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
