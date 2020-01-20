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


// Creates a session which will start capturing  audio and video data
let captureSession = AVCaptureSession()
var backFacingCamera: AVCaptureDevice?
var currentDevice: AVCaptureDevice?

let values = UILabel()


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
    
    

func valueDisplayer(_ color : UIColor) {
// Start of the RGB ShowCaser
   let r = Int(color.cgColor.components![0] * 255)
   let g = Int(color.cgColor.components![1] * 255)
   let b = Int(color.cgColor.components![2] * 255)
   print("Red : \(r)Green : \(g)Blue : \(b)")
   values.backgroundColor = .init(white: 1, alpha: 0.10)
values.frame = CGRect(x: self.view.bounds.width - 80, y: self.view.bounds.height / 20, width: 100, height: 60)
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


    DispatchQueue.main.async {
        self.previewLayer.contents = cgImage
        let color = self.previewLayer.pickColor(at: self.center)
        self.view.backgroundColor = color
    valueDisplayer(color ?? UIColor.black)
     
        self.lineShape.strokeColor = color?.cgColor
    }
    
}

let previewLayer = CALayer()
let lineShape = CAShapeLayer()

func setupUI() {
    previewLayer.bounds = CGRect(x: 0, y: 0, width: WIDTH-30, height: WIDTH-30)
    previewLayer.position = view.center
previewLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
    previewLayer.masksToBounds = true
    previewLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)))
    view.layer.insertSublayer(previewLayer, at: 0)
    
    //圆环
    let linePath = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    lineShape.frame = CGRect.init(x: WIDTH/2-20, y:HEIGHT/2-20, width: 40, height: 40)
    lineShape.lineWidth = 5
    lineShape.strokeColor = UIColor.red.cgColor
    lineShape.path = linePath.cgPath
    lineShape.fillColor = UIColor.clear.cgColor
    self.view.layer.insertSublayer(lineShape, at: 1)
    
    //圆点
    let linePath1 = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 8, height: 8))
    let lineShape1 = CAShapeLayer()
    lineShape1.frame = CGRect.init(x: WIDTH/2-4, y:HEIGHT/2-4, width: 8, height: 8)
    lineShape1.path = linePath1.cgPath
    lineShape1.fillColor = UIColor.init(white: 0.7, alpha: 0.5).cgColor
    self.view.layer.insertSublayer(lineShape1, at: 1)
}

    override func viewDidLoad() {
        super.viewDidLoad()
                setupUI()
               //获取设备，创建UI
               self.CreateUI()
        // Do any additional setup after loading the view.
    }

let queue = DispatchQueue(label: "com.camera.video.queue")

// 取色位置
    var center: CGPoint = CGPoint(x: WIDTH/2-15, y: WIDTH/2-15)
    //MARK: - 获取设备,创建自定义视图
    func CreateUI(){
        // 将音视频采集会话的预设设置为高分辨率照片--选择照片分辨率
        self.captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
        // 获取设备
      //  let devisf AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)

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
