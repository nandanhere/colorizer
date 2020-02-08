//
//  liveViewController.swift
//  colorizer
//
//  Created by Nandan on 20/01/20.
//  Copyright © 2020 Nandan. All rights reserved.
//

import UIKit
import AVFoundation

let WIDTH = UIScreen.main.bounds.width
let HEIGHT = UIScreen.main.bounds.height

class liveViewController: UIViewController , AVCaptureVideoDataOutputSampleBufferDelegate {

@IBOutlet weak var hexValue: UILabel!


// Creates a session which will start capturing  audio and video data
let captureSession = AVCaptureSession()
var backFacingCamera: AVCaptureDevice?
var currentDevice: AVCaptureDevice?

let values = UILabel()
let extractorButton = UIButton()
let nameOfColor = UILabel()
let extractorButtonShell = CAShapeLayer()

@IBAction func unwindToLive(segue: UIStoryboardSegue) {
    //nothing goes here
}


func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
        return
    }
    CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
    guard let baseAddr = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0) else {
        return
    }
    let width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0)
    let height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0)
    let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bimapInfo: CGBitmapInfo = [
        .byteOrder32Little,
        CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)]
    
    guard let content = CGContext(data: baseAddr, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bimapInfo.rawValue) else {
        return
    }
    
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
values.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
values.textAlignment = .left



if truth {
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
let stringValue = "Hue   : \((360 * h).rounded()) \rSat : \((1000 * s).rounded()/1000)\rBrt  : \((1000 * b).rounded()/1000)"
let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
attributedString.setColor(color: UIColor.red, forText: "Hue   : \((1000 * h).rounded()/1000) \r")
attributedString.setColor(color: UIColor.green, forText:  "Sat : \((1000 * b).rounded()/1000)\r")
attributedString.setColor(color: UIColor.systemBlue, forText: "Brt  : \((1000 * s).rounded()/1000)")
    values.attributedText = attributedString
}


self.view.addSubview(values)
//end of RGB Showcaser
}


    DispatchQueue.main.async {
        self.previewLayer.contents = cgImage
        let color = self.previewLayer.pickColor(at: self.center)
        self.view.backgroundColor = color
        discoveredColor = color
    self.extractorButtonShell.fillColor =  discoveredColor?.withAlphaComponent(0.75).cgColor

    valueDisplayer(color ?? UIColor.black)
     
        self.circularCrosshair.strokeColor = color?.cgColor
    }
    
}

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
extractorButtonShell.strokeColor = UIColor.init(white: 2, alpha: 0.9).cgColor
extractorButtonShell.path = linePathOfButton.cgPath
 self.view.layer.insertSublayer(extractorButtonShell, at: 1)
extractorButton.addTarget(self, action: #selector(liveViewController.goToResultBuffer(_:)), for: .touchUpInside)

// label for name of the colour that will be detected
 nameOfColor.frame = CGRect(x:(self.view.bounds.maxX / 2 ) - 150  , y: self.view.bounds.maxY * 0.85 - 60 , width: 300 , height: 20)
 nameOfColor.textColor = .label
 nameOfColor.textAlignment = .center
 nameOfColor.font = .monospacedSystemFont(ofSize: 20, weight: .heavy)
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
        // Do any additional setup after loading the view.
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
performSegue(withIdentifier: "liveToBuffer", sender: nil)
}





let queue = DispatchQueue(label: "com.camera.video.queue")

// 取色位置
    var center: CGPoint = CGPoint(x: WIDTH/2-15, y: WIDTH/2-15)
    //MARK: - 获取设备,创建自定义视图
    func CreateUI(){
        // 将音视频采集会话的预设设置为高分辨率照片--选择照片分辨率
        self.captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
        // 获取设备
        

        let devis = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        self.backFacingCamera = devis
        //设置当前设备为前置摄像头
        self.currentDevice = self.backFacingCamera
        do {
            // 当前设备输入端
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.videoSettings = ([kCVPixelBufferPixelFormatTypeKey as AnyHashable: NSNumber(value: kCMPixelFormat_32BGRA)] as! [String : Any])
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self, queue: queue)
            
            if self.captureSession.canAddOutput(videoOutput) {
                self.captureSession.addOutput(videoOutput)
            }
            self.captureSession.addInput(captureDeviceInput)
        } catch {
            print(error)
            return
        }
        
        // 启动音视频采集的会话
        self.captureSession.startRunning()
    }
}

public extension CALayer {
    
    /// 获取特定位置的颜色
    ///
    /// - parameter at: 位置
    ///
    /// - returns: 颜色
    func pickColor(at position: CGPoint) -> UIColor? {
        
        // 用来存放目标像素值
        var pixel = [UInt8](repeatElement(0, count: 4))
        // 颜色空间为 RGB，这决定了输出颜色的编码是 RGB 还是其他（比如 YUV）
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // 设置位图颜色分布为 RGBA
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        guard let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        // 设置 context 原点偏移为目标位置所有坐标
        context.translateBy(x: -position.x, y: -position.y)
        // 将图像渲染到 context 中
        render(in: context)
        
        return UIColor(red: CGFloat(pixel[0]) / 255.0,
                       green: CGFloat(pixel[1]) / 255.0,
                       blue: CGFloat(pixel[2]) / 255.0,
                       alpha: CGFloat(pixel[3]) / 255.0)
    }
 
    

     

}
