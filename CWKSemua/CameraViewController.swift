//
//  CameraViewController.swift
//  CWKSemua
//
//  Created by Leo nardo on 07/06/21.
//

import UIKit
import AVFoundation
import ReplayKit



class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    //    @IBOutlet weak var camPreview: UIView!
    @IBOutlet weak var camPreview: UIView!
    @IBOutlet weak var camButton: UIButton!
    
    @IBOutlet weak var image2View: UIImageView!
    //    let cameraButton = UIView()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    //    let cameraButton = UIView()
    
    let recorder = RPScreenRecorder.shared()
    var recordEngga = false
    
    let captureSession = AVCaptureSession()
    
    let movieOutput = AVCaptureMovieFileOutput()
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var activeInput: AVCaptureDeviceInput!
    
    var outputURL: URL!
    
    
    var videoCapture: VideoCapture!
    var videoProcessingChain: VideoProcessingChain!
    var actionFrameCounts = [String: Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        
        UIApplication.shared.isIdleTimerDisabled = true

//        UIDevice.current.setValue(value, forKey: "orientation")
        videoProcessingChain = VideoProcessingChain()
        videoProcessingChain.delegate = self

        // Begin receiving frames from the video capture.
        videoCapture = VideoCapture()
        videoCapture.delegate = self

        updateUILabelsWithPrediction(.startingPrediction)
//        if setupSession() {
//            setupPreview()
//            startSession()
//        }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Update the device's orientation.
        videoCapture.updateDeviceOrientation()
    }

    /// Notifies the video capture when the device rotates to a new orientation.
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        // Update the the camera's orientation to match the device's.
        videoCapture.updateDeviceOrientation()
    }
    
    @IBAction func buttonOnClick(_ sender: UIButton) {
    
        if !recordEngga {
            startRecordingReplayKit()
        }
        else{
            stopRecordingReplayKit()
        }
        print("button pressed")
    }
    
    
    func setupPreview() {
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer.frame = self.camPreview.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = currentVideoOrientation()
        camPreview.layer.addSublayer(previewLayer)
        camPreview.addSubview(imageView)
        camPreview.addSubview(actionLabel)
        camPreview.addSubview(confidenceLabel)
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
            
            print(videoRecorded)
            
            performSegue(withIdentifier: "showVideo", sender: videoRecorded)
            
        }
        
    }
    
    
    
}


extension CameraViewController {
    private func addFrameCount(_ frameCount: Int, to actionLabel: String) {
        let totalFrames = (actionFrameCounts[actionLabel] ?? 0) + frameCount

        actionFrameCounts[actionLabel] = totalFrames
    }
    
    private func updateUILabelsWithPrediction(_ prediction: ActionPrediction) {
        DispatchQueue.main.async { self.actionLabel.text = prediction.label }

        let confidenceString = prediction.confidenceString ?? "Observing..."
        DispatchQueue.main.async { self.confidenceLabel.text = confidenceString }
    }
    
    private func drawPoses(_ poses: [Pose]?, onto frame: CGImage) {
        let renderFormat = UIGraphicsImageRendererFormat()
        renderFormat.scale = 1.0

        let frameSize = CGSize(width: frame.width, height: frame.height)
        let poseRenderer = UIGraphicsImageRenderer(size: frameSize,
                                                   format: renderFormat)

        let frameWithPosesRendering = poseRenderer.image { rendererContext in
            let cgContext = rendererContext.cgContext
            let inverse = cgContext.ctm.inverted()

            cgContext.concatenate(inverse)

            //camera capture
            let imageRectangle = CGRect(origin: .zero, size: frameSize)
            cgContext.draw(frame, in: imageRectangle)
            
//            print("frame:",frame)\
            let pointTransform = CGAffineTransform(scaleX: frameSize.width,
                                                   y: frameSize.height)
            let pointTransform2 = CGAffineTransform(scaleX: frameSize.width+100,
                                                   y: frameSize.height)

            guard let poses = poses else { return }

            for pose in poses {
                pose.drawWireframeToContext(cgContext, applying: pointTransform)
                pose.drawWireframeToContext2(cgContext, applying: pointTransform2)
            }
        }
        
        let frameWithPosesRendering2 = poseRenderer.image { rendererContext in
            let cgContext = rendererContext.cgContext
            let inverse = cgContext.ctm.inverted()

            cgContext.concatenate(inverse)

//            let imageRectangle = CGRect(origin: .zero, size: frameSize)
//            cgContext.draw(frame, in: imageRectangle)
//            print("frame:",frame)\
            
            let pointTransform = CGAffineTransform(scaleX: frameSize.width+1080,
                                                   y: frameSize.height)

            guard let poses = poses else { return }
//            print("pointTransform: \(pointTransform)")

            for pose in poses {
                pose.drawWireframeToContext2(cgContext, applying: pointTransform)
            }
        }

        DispatchQueue.main.async { self.imageView.image = frameWithPosesRendering }
        DispatchQueue.main.async { self.image2View.image = frameWithPosesRendering2 }

    }
}

extension CameraViewController: VideoCaptureDelegate {
    func videoCapture(_ videoCapture: VideoCapture,
                      didCreate framePublisher: FramePublisher) {
        updateUILabelsWithPrediction(.startingPrediction)
        
        videoProcessingChain.upstreamFramePublisher = framePublisher
    }
}

extension CameraViewController: VideoProcessingChainDelegate {
    /// - Tag: detectedAction
    func videoProcessingChain(_ chain: VideoProcessingChain,
                              didPredict actionPrediction: ActionPrediction,
                              for frameCount: Int) {

        if actionPrediction.isModelLabel {
            addFrameCount(frameCount, to: actionPrediction.label)
        }

        updateUILabelsWithPrediction(actionPrediction)
    }

    func videoProcessingChain(_ chain: VideoProcessingChain,
                              didDetect poses: [Pose]?,
                              in frame: CGImage) {
        // Render the poses on a different queue than pose publisher.
        DispatchQueue.global(qos: .userInteractive).async {
            // Draw the poses onto the frame.
            self.drawPoses(poses, onto: frame)
        }
    }
}


extension CameraViewController: UIImagePickerControllerDelegate{
    
    
    func startRecordingReplayKit(){
        
        recorder.startRecording { (error) in
            guard error == nil else{
                print("failed to recording")
                return
            }
            self.recordEngga = true
        }
        
        
    }
    
    func stopRecordingReplayKit(){
        
        outputURL = tempURL()
        recorder.stopRecording(withOutput: outputURL) { (error) in
            guard error == nil else{
                print("Failed to save ")
                return
            }
            print(self.outputURL)
           
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showVideo", sender: self.outputURL)
            }
           
            
        }
    }
    
}
