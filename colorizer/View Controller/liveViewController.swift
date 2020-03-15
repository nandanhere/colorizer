//
//  liveViewController.swift
//  colorizer
//
//  Updated by Nandan on 20/01/20.
//  Copyright © 2020 Nandan. All rights reserved.
//  Created by Zhe Qin on 2018/5/7.
//
/// Live Viewcontroller - Here the user can get the color information of the pixel at The center of the screen , instantaneously.This was forked from Zhe Qin's CameraColorPicker , which was a proof of concept. Here we update it for ios 13 and also make it compatible with our application so that the user can have an extra choice at getting the color they want.

import UIKit
import AudioToolbox
import AVFoundation //AV foundation has all the necessary Audio video info needed

let WIDTH = UIScreen.main.bounds.width
let HEIGHT = UIScreen.main.bounds.height

// AVCaptureVideoDataOutputSampleBufferDelegate class is necessary to continously help us take video
class liveViewController: UIViewController , AVCaptureVideoDataOutputSampleBufferDelegate {


@IBOutlet weak var hexValue: UILabel!
@IBAction func unwindToLive(segue: UIStoryboardSegue) {}


// Creates a session which will start capturing  audio and video data
let captureSession = AVCaptureSession()
// Taking into account what camera we are trying to use here
var backFacingCamera: AVCaptureDevice?
var currentDevice: AVCaptureDevice?

let values = UILabel() //Display the values
let extractorButton = UIButton() //To extract the color
let nameOfColor = UILabel()
let extractorButtonShell = CAShapeLayer() // UI portion of button


//The sample buffer mentioned below can be of any media type
func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//Declaring the sample buffer as a constant that is now an image buffer
guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
return
}
//Locking the buffer view to access the pixel data and generally the lock flags are set to 0
CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
//Finds the base address of the plane where our buffer is at
guard let baseAddr = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0) else {
return
}
//The constants below have their usual meanings with respect to the buffer
let width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0)
let height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0)
let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0)
//Changing the space into a rgb dependent space
let colorSpace = CGColorSpaceCreateDeviceRGB()
//Takes bitmap and talks about values of alpha
let bimapInfo: CGBitmapInfo = [
.byteOrder32Little,
CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)]
//Using all the above descibred constant and implementing it into a 2d surface
guard let content = CGContext(data: baseAddr, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bimapInfo.rawValue) else {
return
}
//provides the image using pixel data and CGimage i.e. image based on pixel data
guard let cgImage = content.makeImage() else {
return
}


///  Sets the values of a label to its specific RGB values
/// - Parameter color: The color extracted in the image function is sent here so that the user can acess its data on top right corner
func valueDisplayer(_ color : UIColor) {
// Start of the RGB ShowCaser

values.backgroundColor = .init(white: 1, alpha: 0.3)
values.frame = CGRect(x: self.view.bounds.width - 80, y: self.view.bounds.height / 20, width: 100, height: 60)
values.layer.cornerRadius = 10
values.layer.masksToBounds = true
values.numberOfLines = 3
values.lineBreakMode = .byWordWrapping
values.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
values.textAlignment = .left



if truth {
// if the switch is taken for rgb values
let r = Int(color.cgColor.components![0] * 255)
let g = Int(color.cgColor.components![1] * 255)
let b = Int(color.cgColor.components![2] * 255)
let stringValue = " Red   : \(r) \r Green : \(g)\r Blue  : \(b)"
let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
attributedString.setColor(color: UIColor.red, forText: " Red   : \(r) \r")
attributedString.setColor(color: UIColor.green, forText:  " Green : \(g)\r")
attributedString.setColor(color: UIColor.systemBlue, forText: " Blue  : \(b)")

values.attributedText = attributedString }

else
{ // if the switch is taken for HSB values
let hs = discoveredColor?.hsba
let h = Double((hs?.hue)!)
let b = Double((hs?.brightness)!)
let s = Double((hs?.saturation)!)
let stringValue = " Hue   : \((360 * h).rounded()) \r Sat : \((1000 * s).rounded()/1000)\r Brt  : \((1000 * b).rounded()/1000)"
let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
attributedString.setColor(color: UIColor.red, forText: " Hue   : \((1000 * h).rounded()/1000) \r")
attributedString.setColor(color: UIColor.green, forText:  " Sat : \((1000 * b).rounded()/1000)\r")
attributedString.setColor(color: UIColor.systemBlue, forText: " Brt  : \((1000 * s).rounded()/1000)")
values.attributedText = attributedString
}


self.view.addSubview(values)
//end of RGB Showcaser
}

//Since we need the live view to continuously run, this function does that
DispatchQueue.main.async {
self.previewLayer.contents = cgImage
let color = self.previewLayer.pickColor(at: self.center)
self.view.backgroundColor = color
discoveredColor = color
dataBaseColor = discoveredColor ?? UIColor.black
self.extractorButtonShell.fillColor =  discoveredColor?.withAlphaComponent(0.75).cgColor

valueDisplayer(color ?? UIColor.black)
self.hexValue.text = discoveredColor?.hexString
self.nameOfColor.text = discoveredColor?.name

self.circularCrosshair.strokeColor = color?.cgColor
}

}

//CALAyer is like something that allows you to edit or help in animation and also helps in managing image content
let previewLayer = CALayer()
let circularCrosshair = CAShapeLayer()

func setupUI() {


// circular shaped button which will give user op
extractorButton.frame = CGRect(x: self.view.bounds.maxX / 2 - 35 , y: (self.view.bounds.maxY * 0.85) - 35 , width: 70, height: 70)
extractorButton.backgroundColor = .clear
extractorButton.layer.masksToBounds = true
extractorButton.layer.cornerRadius = 40
self.view.addSubview(extractorButton)

//circular part of the extractor button
let linePathOfButton = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 70, height: 70))
extractorButtonShell.frame = CGRect(x:( self.view.bounds.maxX / 2 ) - 35 , y: (self.view.bounds.maxY * 0.85) - 35, width: 50, height: 50)
extractorButtonShell.lineWidth = 3
extractorButtonShell.strokeColor = UIColor.label.cgColor
extractorButtonShell.path = linePathOfButton.cgPath
self.view.layer.insertSublayer(extractorButtonShell, at: 1)
extractorButton.addTarget(self, action: #selector(liveViewController.goToResultBuffer(_:)), for: .touchUpInside)
extractorButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(ViewController.goToTable(_:))))
// label for name of the colour that will be detected
nameOfColor.frame = CGRect(x:(self.view.bounds.maxX / 2 ) - 150  , y: self.view.bounds.maxY * 0.85 - 60 , width: 300 , height: 20)
nameOfColor.textColor = .label
nameOfColor.textAlignment = .center
nameOfColor.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
nameOfColor.text = discoveredColor?.name
nameOfColor.backgroundColor = .clear
self.view.addSubview(nameOfColor)

previewLayer.bounds = CGRect(x: 0, y: 0, width: WIDTH-30, height: WIDTH-30)
previewLayer.position = view.center
previewLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
previewLayer.masksToBounds = true
previewLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)))
view.layer.insertSublayer(previewLayer, at: 0)

//Sets the Values for the Circular crosshair
let linePathOfCC = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 40, height: 40))
circularCrosshair.frame = CGRect.init(x: WIDTH/2-20, y:HEIGHT/2-20, width: 40, height: 40)
circularCrosshair.lineWidth = 5
circularCrosshair.strokeColor = UIColor.red.cgColor
circularCrosshair.path = linePathOfCC.cgPath
circularCrosshair.fillColor = UIColor.clear.cgColor
self.view.layer.insertSublayer(circularCrosshair, at: 1)

//Inner circle inside the Circular crosshair
let linePathInsideCC = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 8, height: 8))
let lineShapeInsideCC = CAShapeLayer()
lineShapeInsideCC.frame = CGRect.init(x: WIDTH/2-4, y:HEIGHT/2-4, width: 8, height: 8)
lineShapeInsideCC.path = linePathInsideCC.cgPath
lineShapeInsideCC.fillColor = UIColor.init(white: 0.7, alpha: 0.5).cgColor
self.view.layer.insertSublayer(lineShapeInsideCC, at: 1)

// label to show Hex value
hexValue.frame = CGRect(x: Int(self.view.frame.maxX /  2 ) - 75, y: 21, width: 135, height: 21)


}

override func viewDidLoad() {
super.viewDidLoad()
setupUI()
self.CreateUI()
 }

// An unwind segue that comes back to this viewcontroller
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
performSegue(withIdentifier: "liveToBuffer", sender: nil)
}
@objc func goToTable(_ sender:UILongPressGestureRecognizer){
performSegue(withIdentifier: "FromLive", sender: nil)
AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
}


@IBAction func goToSliderFunction(_ sender: Any) {
cameFromHalfAlive = false
}

//Starts an instance that starts recording video
let queue = DispatchQueue(label: "com.camera.video.queue")

// position of the point where color is extracted
var center: CGPoint = CGPoint(x: WIDTH/2-15, y: WIDTH/2-15)
//MARK: - Gets the device properties and creates a custom view
func CreateUI(){
// We make the resolution of the capture as high res.
self.captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
//The default beginner camera is the back camera and is for video mode


let devis = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
self.backFacingCamera = devis
//Use a do-try-catch for error handling
self.currentDevice = self.backFacingCamera
do {
// current device input
let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
let videoOutput = AVCaptureVideoDataOutput()
videoOutput.videoSettings = ([kCVPixelBufferPixelFormatTypeKey as AnyHashable: NSNumber(value: kCMPixelFormat_32BGRA)] as! [String : Any])
videoOutput.alwaysDiscardsLateVideoFrames = true
//Runs the Dispatch queue
videoOutput.setSampleBufferDelegate(self, queue: queue)

if self.captureSession.canAddOutput(videoOutput) {
self.captureSession.addOutput(videoOutput)
}
self.captureSession.addInput(captureDeviceInput)
} catch {
print(error)
return
}

// Start a session of audio and video acquisition
self.captureSession.startRunning()
}
}


public extension CALayer {

/// get the color of a specific position    ///
///-parameter at: position    ///
///-returns: color
func pickColor(at position: CGPoint) -> UIColor? {

// used to store the target pixel value
var pixel = [UInt8](repeatElement(0, count: 4))
// The color space is RGB, which determines whether the encoding of the output color is RGB or other (such as YUV)
let colorSpace = CGColorSpaceCreateDeviceRGB()
// Set the bitmap color distribution to RGBA
let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
guard let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo) else {
return nil
}
// Set the context origin offset to all coordinates of the target position
context.translateBy(x: -position.x, y: -position.y)
// render the image into the context
render(in: context)

return UIColor(red: CGFloat(pixel[0]) / 255.0,
               green: CGFloat(pixel[1]) / 255.0,
               blue: CGFloat(pixel[2]) / 255.0,
               alpha: CGFloat(pixel[3]) / 255.0)
}
 
}
