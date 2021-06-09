//
//  CameraViewController.swift
//  CWKSemua
//
//  Created by Leo nardo on 07/06/21.
//

import UIKit
import AVFoundation




class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {

//    @IBOutlet weak var camPreview: UIView!
    @IBOutlet weak var camPreview: UIView!
    @IBOutlet weak var camButton: UIButton!
    
//    let cameraButton = UIView()

    let captureSession = AVCaptureSession()

    let movieOutput = AVCaptureMovieFileOutput()

    var previewLayer: AVCaptureVideoPreviewLayer!

    var activeInput: AVCaptureDeviceInput!

    var outputURL: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
        
        if setupSession() {
            setupPreview()
            startSession()
        }
    
//        cameraButton.isUserInteractionEnabled = true
//
//        let cameraButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.startCapture))
//
//        cameraButton.addGestureRecognizer(cameraButtonRecognizer)
//
//        cameraButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//
//        cameraButton.backgroundColor = UIColor.red
    
//        camPreview.addSubview(cameraButton)
    
    }

    @IBAction func onClickCamButton(_ sender: Any) {
        startCapture()
    }
    
    func setupPreview() {
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = camPreview.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        camPreview.layer.addSublayer(previewLayer)
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

    @objc func startCapture() {
    
        startRecording()
    
    }

    //EDIT 1: I FORGOT THIS AT FIRST

    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
    
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
    
        return nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        let vc = segue.destination as! VideoPlaybackViewController
    
        vc.videoURL = sender as? URL
    
    }

    func startRecording() {
    
        if movieOutput.isRecording == false {
        
            let connection = movieOutput.connection(with: AVMediaType.video)
        
            if (connection?.isVideoOrientationSupported)! {
                connection?.videoOrientation = currentVideoOrientation()
            }
        
            if (connection?.isVideoStabilizationSupported)! {
                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
        
            let device = activeInput.device
        
            if (device.isSmoothAutoFocusSupported) {
            
                do {
                    try device.lockForConfiguration()
                    device.isSmoothAutoFocusEnabled = false
                    device.unlockForConfiguration()
                } catch {
                   print("Error setting configuration: \(error)")
                }
            
            }
        
            //EDIT2: And I forgot this
            outputURL = tempURL()
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
        
            }
            else {
                stopRecording()
            }
    
       }

   func stopRecording() {
    
       if movieOutput.isRecording == true {
           movieOutput.stopRecording()
        }
   }

    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
    
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
    
        if (error != nil) {
        
            print("Error recording movie: \(error!.localizedDescription)")
        
        } else {
        
            let videoRecorded = outputURL! as URL
        
            performSegue(withIdentifier: "showVideo", sender: videoRecorded)
        
        }
    
    }

}
//class CameraViewController: UIViewController{
//
//    let videoCapture = VideoCapture()
//    //    var previewLayer -
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        videoCapture.startCaptureSession()
////        videoCapture.captureOutput(<#T##output: AVCaptureOutput##AVCaptureOutput#>, didDrop: <#T##CMSampleBuffer#>, from: <#T##AVCaptureConnection#>)
//
//        let previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)
//
//        view.layer.addSublayer(previewLayer)
//        previewLayer.frame = view.frame
//    }
    
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
//}
