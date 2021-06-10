//
//  PageViewController.swift
//  CWKSemua
//
//  Created by Pieter Yonathan on 08/06/21.
//

import UIKit
import AVFoundation

class PageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl1: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var camPreview1: UIView!
    
    let captureSession = AVCaptureSession()

    let movieOutput = AVCaptureMovieFileOutput()

    var previewLayer: AVCaptureVideoPreviewLayer!

    var activeInput: AVCaptureDeviceInput!

//    var outputURL: URL!
    
    var halamanterakhir = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        if setupSession() {
            setupPreview()
            startSession()
        }
        
        scrollView.delegate = self
        let imageArray = ["Page1.1","Page2.1"]
        scrollView.contentSize.width = CGFloat(imageArray.count)*scrollView.frame.width
        scrollView.isPagingEnabled = true
        
        for i in 0...imageArray.count-1 {
           
            var imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: imageArray[i])
            
            var imageWidth = scrollView.frame.width
            var imageHeight = scrollView.frame.height
            
            
            imageView.frame = CGRect(x: CGFloat(i)*imageWidth, y: 0, width: imageWidth, height: imageHeight)
            scrollView.addSubview(imageView)

            
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped(gestureRecognizer:)))
        scrollView.addGestureRecognizer(tap)

    }

@objc func scrollViewTapped(gestureRecognizer: UIGestureRecognizer) {
    if halamanterakhir == true {
        performSegue(withIdentifier: "moveToCamera", sender: self)
    }
}
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    let page = scrollView.contentOffset.x/CGFloat(245)
        
        if page > 0 {
            halamanterakhir = true
        }else{
            halamanterakhir = false
        }
        pageControl1.currentPage = Int(page)
}

    func setupPreview() {
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = camPreview1.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = currentVideoOrientation()
        camPreview1.layer.addSublayer(previewLayer)
    }
    
    
    //MARK:- Setup Camera

    func setupSession() -> Bool {
    
        captureSession.sessionPreset = AVCaptureSession.Preset.high
    
        // Setup Camera
        let camera = AVCaptureDevice.default(for: AVMediaType.video)!
    
        do {
        
            let input = try AVCaptureDeviceInput(device: camera)
        
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            }
        } catch {
            print("Error setting device video input: \(error)")
            return false
        }
    
        // Setup Microphone
        let microphone = AVCaptureDevice.default(for: AVMediaType.audio)!
    
        do {
            let micInput = try AVCaptureDeviceInput(device: microphone)
            if captureSession.canAddInput(micInput) {
                captureSession.addInput(micInput)
            }
        } catch {
            print("Error setting device audio input: \(error)")
            return false
        }
    
    
        // Movie output
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
    
        return true
    }

    func setupCaptureMode(_ mode: Int) {
        // Video Mode
    
    }

    //MARK:- Camera Session
    func startSession() {
    
        if !captureSession.isRunning {
            videoQueue().async {
                self.captureSession.startRunning()
            }
        }
    }

    func stopSession() {
        if captureSession.isRunning {
            videoQueue().async {
                self.captureSession.stopRunning()
            }
        }
    }

    func videoQueue() -> DispatchQueue {
        return DispatchQueue.main
    }

    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
    
        switch UIDevice.current.orientation {
            case .portrait:
                orientation = AVCaptureVideoOrientation.portrait
            case .landscapeRight:
                orientation = AVCaptureVideoOrientation.landscapeLeft
            case .portraitUpsideDown:
                orientation = AVCaptureVideoOrientation.portraitUpsideDown
            default:
                 orientation = AVCaptureVideoOrientation.landscapeRight
         }
    
         return orientation
     }

//    @objc func startCapture() {
//
//        startRecording()
//
//    }

    //EDIT 1: I FORGOT THIS AT FIRST

//    func tempURL() -> URL? {
//        let directory = NSTemporaryDirectory() as NSString
//
//        if directory != "" {
//            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
//            return URL(fileURLWithPath: path)
//        }
//
//        return nil
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let vc = segue.destination as! VideoPlaybackViewController
//
//        vc.videoURL = sender as? URL
//
//    }

//    func startRecording() {
//
//        if movieOutput.isRecording == false {
//
//            let connection = movieOutput.connection(with: AVMediaType.video)
//
//            if (connection?.isVideoOrientationSupported)! {
//                connection?.videoOrientation = currentVideoOrientation()
//            }
//
//            if (connection?.isVideoStabilizationSupported)! {
//                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
//            }
//
//            let device = activeInput.device
//
//            if (device.isSmoothAutoFocusSupported) {
//
//                do {
//                    try device.lockForConfiguration()
//                    device.isSmoothAutoFocusEnabled = false
//                    device.unlockForConfiguration()
//                } catch {
//                   print("Error setting configuration: \(error)")
//                }
//
//            }
//
//            //EDIT2: And I forgot this
//            outputURL = tempURL()
//            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
//
//            }
//            else {
//                stopRecording()
//            }
//
//       }
//
//   func stopRecording() {
//
//       if movieOutput.isRecording == true {
//           movieOutput.stopRecording()
//        }
//   }
//
//    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
//
//    }
//
//    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//
//        if (error != nil) {
//
//            print("Error recording movie: \(error!.localizedDescription)")
//
//        } else {
//
//            let videoRecorded = outputURL! as URL
//
//            performSegue(withIdentifier: "showVideo", sender: videoRecorded)
//
//        }
//
//    }
//
//
}

