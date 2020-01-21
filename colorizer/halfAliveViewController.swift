//
//  ViewController.swift
//  colorizer
//
//  Created by Nandan on 20/01/20.
//  Copyright © 2020 Nandan. All rights reserved.
//
var discoveredColor : UIColor?
import UIKit
extension NSMutableAttributedString {

    func setColor(color: UIColor, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
     self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}

extension UIImage {

/// Gives color of the pixel in context by taking the bitmap information of the image
/// - Parameter point: Coordinates of the point wrt to the source view
/// - Parameter sourceView: view in which the image is displayed
   func pixel(point: CGPoint, sourceView: UIView ) -> UIColor {
    let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

    context!.translateBy(x: -point.x, y: -point.y)

    sourceView.layer.render(in: context!)
    let color: UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                 green: CGFloat(pixel[1])/255.0,
                                 blue: CGFloat(pixel[2])/255.0,
                                 alpha: CGFloat(pixel[3])/255.0)
    pixel.deallocate()
    return color
}}

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UIScrollViewDelegate {
@IBOutlet weak var Scroll: UIScrollView!
@IBOutlet weak var myImageView: UIImageView!
@IBOutlet weak var color: UILabel!
@IBOutlet weak var importerButton: UIButton!
@IBOutlet weak var cameraUseButton: UIButton!

@IBAction func unwindToViewControllerNameHere(segue: UIStoryboardSegue) {
    //nothing goes here
}

class cv {
     var ranOnce = false
     var zoomer : CGFloat = 1.0
  }
  let uni = cv()
    let lineShape = CAShapeLayer()
  let values = UILabel()
  let crossHair = UILabel()
  let extractorButton = UIButton()



 
    override func viewDidLoad() {
        super.viewDidLoad()
        Scroll.delegate = self
        Scroll.minimumZoomScale = 1.0
        Scroll.maximumZoomScale = 100.0
      addCrosshair()
      
      importerButton.layer.masksToBounds = true
      importerButton.layer.cornerRadius = 15
      
      cameraUseButton.layer.masksToBounds = true
      cameraUseButton.layer.cornerRadius = 15
    
    color.layer.masksToBounds = true
    color.layer.cornerRadius = 15
    color.text = "SAVE"
    
    myImageView.image = #imageLiteral(resourceName: "color wheel-1")
    extractorButton.frame = CGRect(x: myImageView.bounds.maxX / 2 , y: myImageView.bounds.maxY * 0.85 , width: 50, height: 50)
    extractorButton.backgroundColor = .clear
    self.view.addSubview(extractorButton)
    
    //circular part of the extractor button
    let linePath = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 70, height: 70))
    lineShape.frame = CGRect(x: myImageView.bounds.maxX / 2  - 20 , y: myImageView.bounds.maxY * 0.85 , width: 50, height: 50)
    lineShape.lineWidth = 3
    lineShape.strokeColor = UIColor.init(white: 2, alpha: 0.9).cgColor
    lineShape.path = linePath.cgPath
     self.view.layer.insertSublayer(lineShape, at: 1)
}
/// Adds a draggable label which cointains the marker . We use the cross emojticon here for  marking
func addCrosshair()
{  crossHair.frame =   CGRect(x: self.view.bounds.width/2-20, y:self.view.bounds.height/2-20, width: 40, height: 40)
  if uni.ranOnce == false {
     uni.ranOnce = true
        crossHair.backgroundColor = UIColor.clear
        crossHair.text = "╳"
        crossHair.font = crossHair.font.withSize(35)
     crossHair.textAlignment = NSTextAlignment.center
        self.view.addSubview(crossHair)
        crossHair.isUserInteractionEnabled = true
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.colorFinderFunction(_:)))
        crossHair.addGestureRecognizer(gesture)

    }
 
}

@IBAction func galleryImporter(_ sender: Any) {
let image = UIImagePickerController()
  image.delegate = self
  image.sourceType = UIImagePickerController.SourceType.photoLibrary
  image.allowsEditing = true
  self.present(image , animated: true)
  addCrosshair()
Scroll.zoomScale = 1
myImageView.contentMode = .scaleAspectFit
if uni.ranOnce {
crossHair.frame = CGRect(x: self.view.bounds.width/2-20, y:self.view.bounds.height/2-20, width: 40, height: 40)
 }

}

@IBAction func CameraUse(_ sender: Any) {

  let image = UIImagePickerController()
  image.delegate = self
  image.sourceType = UIImagePickerController.SourceType.camera
  image.allowsEditing = true
  self.present(image , animated: true)
  addCrosshair()
uni.zoomer = 1
if uni.ranOnce {
crossHair.frame = CGRect(x: self.view.bounds.width/2-20, y:self.view.bounds.height/2-20, width: 40, height: 40)
 }
}


func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
        myImageView.image = image
     uni.zoomer = 1
    }
    else{}
    self.dismiss(animated: true, completion: nil)
}

/// returns the View once the iser has piched or dragged on the VIew
/// - Parameter Scroll: Scroll is the view which allows the gesture implementation on UIVIew
 func viewForZooming(in Scroll : UIScrollView) -> UIView? {
  uni.zoomer = max(Scroll.contentSize.height / Scroll.frame.height, Scroll.contentSize.width / Scroll.frame.width)
  print(uni.zoomer)
  print("\(Scroll.contentOffset.x) and \(Scroll.contentOffset.y)")
// prints how off the content is in the scrollview (will delete note in final)
    return self.myImageView
}

/// This function will help find the color of the specified point which is marked using the given pointer
  /// - Parameter gesture: drag the pointer to a point inside the image and obtain the pixel color of the point.
   @objc func colorFinderFunction(_ gesture : UIPanGestureRecognizer) {
       let orignalCenter = CGPoint(x: self.myImageView.bounds.width/2, y: self.myImageView.bounds.height/2)
       let translation = gesture.translation(in: self.myImageView)
       let label = gesture.view!
       
     
            if uni.zoomer == 0 { uni.zoomer = 1}
     label.center = CGPoint(x: label.center.x + ( translation.x *  uni.zoomer), y: label.center.y + ( translation.y *  uni.zoomer ))
     gesture.setTranslation(CGPoint.zero, in: self.myImageView)
     
     
 
  
     if label.center.x >= myImageView.bounds.maxX || label.center.x <= myImageView.bounds.minX || label.center.y >= myImageView.bounds.maxY || label.center.y <= myImageView.bounds.minY {
           label.center = orignalCenter
       }

     let zh =  (Scroll.contentSize.width / Scroll.frame.width) //
     let zw =  (Scroll.contentSize.width / Scroll.frame.width)// tells zoom scale of height and width respectively
     var oh = (Scroll.contentOffset.y +  label.center.y - 20 ) / zh //
     var ow = (Scroll.contentOffset.x +  label.center.x ) / zw // what are the coordinates of the point when zoomed in
     if zh == 0 || zw == 0 {
        oh = Scroll.contentOffset.y +  label.center.y - 20
        ow = Scroll.contentOffset.x +  label.center.x
     }
   
   ///  Sets the values of a label to its specific RGB values
   /// - Parameter color: The color extracted in the image function is sent here so that the user can acess its data on top right corner
   func valueDisplayer(_ color : UIColor) {
   // Start of the RGB ShowCaser
      let r = Int(color.cgColor.components![0] * 255)
      let g = Int(color.cgColor.components![1] * 255)
      let b = Int(color.cgColor.components![2] * 255)
       values.backgroundColor = .init(white: 1, alpha: 0.10)
    values.frame = CGRect(x: myImageView.bounds.width - 90, y: myImageView.bounds.height / 20, width: 100, height: 60)
      values.layer.cornerRadius = 10
      values.layer.masksToBounds = true
   values.numberOfLines = 3
   let stringValue = "Red   : \(r) \rGreen : \(g)\rBlue  : \(b)"
   values.textAlignment = .left
   let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
   attributedString.setColor(color: UIColor.red, forText: "Red   : \(r) \r")
   attributedString.setColor(color: UIColor.green, forText:  "Green : \(g)\r")
   attributedString.setColor(color: UIColor.systemBlue, forText: "Blue  : \(b)")
      values.lineBreakMode = .byWordWrapping
      values.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
      values.attributedText = attributedString
   self.view.addSubview(values)
   //end of RGB Showcaser
   }
    ///Sets the image point for the  pixel function and displays the color accordingly
         func img(){
            let image = myImageView.image
             let cgp2 =  CGPoint(x: ow  , y: oh  )
   
          discoveredColor = image?.pixel(point: cgp2, sourceView: myImageView)
         valueDisplayer(discoveredColor ?? UIColor.black)
         color.backgroundColor = UIColor(cgColor: discoveredColor?.cgColor ?? CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1))
         lineShape.fillColor =  discoveredColor?.withAlphaComponent(0.75).cgColor

           }
          img()
       }



}

