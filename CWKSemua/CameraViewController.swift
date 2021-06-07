//
//  CameraViewController.swift
//  CWKSemua
//
//  Created by Leo nardo on 07/06/21.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController{
    
    let videoCapture = VideoCapture()
    //    var previewLayer -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoCapture.startCaptureSession()
//        videoCapture.captureOutput(<#T##output: AVCaptureOutput##AVCaptureOutput#>, didDrop: <#T##CMSampleBuffer#>, from: <#T##AVCaptureConnection#>)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
    }
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        let captureSession = AVCaptureSession()
    //        captureSession.sessionPreset = .photo
    //        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
    //        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
    //        captureSession.addInput(input)
    //
    //        captureSession.startRunning()
    //
    //        view.layer.addSublayer(previewLayer)
    //        previewLayer.frame = view.frame
    //    }
}
