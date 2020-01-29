//
//  ViewController.swift
//  colorizer
//
//  Created by Nandan on 20/01/20.
//  Copyright © 2020 Nandan. All rights reserved.
//
var discoveredColor : UIColor?
var truth = true
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
@IBOutlet weak var importerButton: UIButton!
@IBOutlet weak var cameraUseButton: UIButton!
@IBOutlet weak var Switcheroo: UISwitch!
@IBOutlet weak var Lab: UILabel!



@IBAction func unwindToHalfAlive(segue: UIStoryboardSegue) {
    //nothing goes here
}

class cv {
     var ranOnce = false
     var zoomer : CGFloat = 1.0
  }
  let uni = cv()



  let values = UILabel() // Displays the values of the RGB components
  let crossHair =  UIImageView() // crosshair that is draggable
    let extractorButton = UIButton() // pressing the button will open a view which allows user to explore the color
   let extractorButtonShell = CAShapeLayer() // Circular shape which is the "shell " for the buffer button
   let nameOfColor = UILabel() // Displays the Cataloged name of the color

func addCircularButton()
{
// circular shaped button which will give user op
      extractorButton.frame = CGRect(x: self.view.bounds.maxX / 2 -  35 , y: (self.view.bounds.maxY * 0.85) - 35, width: 70, height: 70)
      extractorButton.backgroundColor = .clear
      extractorButton.layer.masksToBounds = true
      extractorButton.layer.cornerRadius = 40
      self.view.addSubview(extractorButton)
      extractorButton.addTarget(self, action: #selector(ViewController.goToResultBuffer(_:)), for: .touchUpInside)

      

      //circular part of the extractor button
      let linePath = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 70, height: 70))
      extractorButtonShell.frame = CGRect(x: self.view.bounds.maxX / 2  - 35 , y: (self.view.bounds.maxY * 0.85) - 35, width: 50, height: 50)
      extractorButtonShell.lineWidth = 3
      extractorButtonShell.strokeColor = UIColor.init(white: 2, alpha: 0.9).cgColor
      extractorButtonShell.path = linePath.cgPath
       self.view.layer.insertSublayer(extractorButtonShell, at: 1)
}
 
func setupUI(){
Scroll.delegate = self
       Scroll.minimumZoomScale = 1.0
       Scroll.maximumZoomScale = 100.0
     addCrosshair()
     
     importerButton.layer.masksToBounds = true
     importerButton.layer.cornerRadius = 15
     
     cameraUseButton.layer.masksToBounds = true
     cameraUseButton.layer.cornerRadius = 15
 
   myImageView.image = #imageLiteral(resourceName: "color wheel-1")
   myImageView.backgroundColor = .clear
   myImageView.isOpaque = true

   crossHair.image = #imageLiteral(resourceName: "crosshair")

   
   // label for name of the colour that will be detected
nameOfColor.frame = CGRect(x:(self.view.bounds.maxX / 2 ) - 150  , y: self.view.bounds.maxY * 0.85 - 60 , width: 300 , height: 20)
   nameOfColor.textColor = .label
   nameOfColor.textAlignment = .center
   nameOfColor.font = .monospacedSystemFont(ofSize: 20, weight: .heavy)
   nameOfColor.text = discoveredColor?.name
   nameOfColor.backgroundColor = .clear
   self.view.addSubview(nameOfColor)
}


  
     override func viewDidLoad() {
        super.viewDidLoad()
         setupUI()
        addCircularButton()
    
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
if let sliderViewController = segue.destination as? sliderViewController
{
sliderViewController.tempColor = discoveredColor
}
else
{
if let dataBufferPage = segue.destination as? dataBufferPage
{
dataBufferPage.tempColor = discoveredColor
}
else
{
return
}
}
}


/// Click on this to go to the Buffer view which will show you colors and save them later
/// - Parameter sender: Circular button declared earlier
@objc func goToResultBuffer(_ sender:UIButton)
{
performSegue(withIdentifier: "halfAliveToBuffer", sender: nil)
}



/// Adds a draggable label which cointains the marker . We use the cross emojticon here for  marking
//UPDATE : made the CrossHair PNG based so we could get cooler ones
func addCrosshair()
{  crossHair.frame =   CGRect(x: self.view.bounds.width/2-20, y:self.view.bounds.height/2-20, width: 100, height: 100)
  if uni.ranOnce == false {
     uni.ranOnce = true
  crossHair.backgroundColor = .clear
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

@IBAction func truthChanger(_ sender: Any) {
truth = Switcheroo.isOn
}

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
        myImageView.image = image
     uni.zoomer = 1
    }
    else{}
    self.dismiss(animated: true, completion: nil)
}

/// returns the View once the user has piched or dragged on the VIew
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
       let crosshairGesture = gesture.view!
       
     
            if uni.zoomer == 0 { uni.zoomer = 1}
     crosshairGesture.center = CGPoint(x: crosshairGesture.center.x + ( translation.x *  uni.zoomer), y: crosshairGesture.center.y + ( translation.y *  uni.zoomer ))
     gesture.setTranslation(CGPoint.zero, in: self.myImageView)
     
     
 
  
     if crosshairGesture.center.x >= myImageView.bounds.maxX || crosshairGesture.center.x <= ( myImageView.bounds.minX + 25 ) || crosshairGesture.center.y >=
     
     myImageView.bounds.maxY  || crosshairGesture.center.y <= myImageView.bounds.minY || extractorButton.frame.contains(crosshairGesture.center) || values.frame.contains(crosshairGesture.center) {
           crosshairGesture.center = orignalCenter
       }
    

     let zh =  (Scroll.contentSize.width / Scroll.frame.width) //
     let zw =  (Scroll.contentSize.width / Scroll.frame.width)// tells zoom scale of height and width respectively
     var oh = (Scroll.contentOffset.y +  crosshairGesture.center.y  - 25 ) / zh //
     var ow = (Scroll.contentOffset.x +  crosshairGesture.center.x - 25 ) / zw // what are the coordinates of the point when zoomed in
     if zh == 0 || zw == 0 {
        oh = Scroll.contentOffset.y +  crosshairGesture.center.y - 25
        ow = Scroll.contentOffset.x +  crosshairGesture.center.x - 25
     }
   
   ///  Sets the values of a label to its specific RGB values
   /// - Parameter color: The color extracted in the image function is sent here so that the user can acess its data on top right corner
   func valueDisplayer(_ color : UIColor) {
   // Start of the RGB ShowCaser
      
       values.backgroundColor = .init(white: 1, alpha: 0.3)
    values.frame = CGRect(x: myImageView.bounds.width - 90, y: myImageView.bounds.height / 20, width: 100, height: 60)
      values.layer.cornerRadius = 10
      values.layer.masksToBounds = true
   values.numberOfLines = 3
   values.lineBreakMode = .byWordWrapping
   values.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
   values.textAlignment = .left


   
   if Switcheroo.isOn {
   // if the switch is taken for rgb values
   let r = Int(color.cgColor.components![0] * 255)
   let g = Int(color.cgColor.components![1] * 255)
   let b = Int(color.cgColor.components![2] * 255)
   let stringValue = "Red   : \(r) \rGreen : \(g)\rBlue  : \(b)"
   let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
   attributedString.setColor(color: UIColor.red, forText: "Red   : \(r) \r")
   attributedString.setColor(color: UIColor.green, forText:  "Green : \(g)\r")
   attributedString.setColor(color: UIColor.systemBlue, forText: "Blue  : \(b)")
      
   values.attributedText = attributedString }
   
   else
   { // if the switch is taken for HSB values
   let hs = discoveredColor?.hsba
   let h = Double((hs?.hue)!)
   let b = Double((hs?.brightness)!)
   let s = Double((hs?.saturation)!)
   let stringValue = "Hue   : \((360 * h).rounded()) \rSat : \((1000 * s).rounded()/10)\rBrt  : \((1000 * b).rounded()/10)"
   let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
   attributedString.setColor(color: UIColor.systemTeal, forText: "Hue   : \((360 * h).rounded()) \r")
   attributedString.setColor(color: UIColor.systemYellow, forText:  "Sat : \((1000 * s).rounded()/10)\r")
   attributedString.setColor(color: UIColor.white, forText: "Brt  : \((1000 * b).rounded()/10)")
       values.attributedText = attributedString
   }
   
   
   self.view.addSubview(values)
   //end of RGB Showcaser
   }
    
   ///Sets the image point for the  pixel function and displays the color accordingly
         func img(){
            let image = myImageView.image
             let finalPoint =  CGPoint(x: ow  , y: oh  )
           discoveredColor = image?.pixel(point: finalPoint, sourceView: myImageView)
         valueDisplayer(discoveredColor ?? UIColor.black)
          extractorButtonShell.fillColor =  discoveredColor?.withAlphaComponent(0.75).cgColor
         nameOfColor.text = discoveredColor?.name
         Lab.text = discoveredColor?.hexString

           }
          img()
       }



}

