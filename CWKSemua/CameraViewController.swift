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
    
    @IBOutlet weak var camPreview: UIView!
    @IBOutlet weak var camButton: UIButton!
    @IBOutlet weak var buttonstoprecord: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    let recorder = RPScreenRecorder.shared()
    var recordEngga = false
    
    var outputURL: URL!
    
    var delegate: DismissToMainDelegate?
    
    var videoCapture: VideoCapture!
    var videoProcessingChain: VideoProcessingChain!
    var actionFrameCounts = [String: Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true

        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        buttonstoprecord.isHidden = true
        
        videoProcessingChain = VideoProcessingChain()
        videoProcessingChain.delegate = self

        videoCapture = VideoCapture()
        videoCapture.delegate = self

        updateUILabelsWithPrediction(.startingPrediction)
    
    }
    
    @IBAction func buttonOnClick(_ sender: UIButton) {
        
        if !recordEngga {
            buttonstoprecord.isHidden = false
            startRecordingReplayKit()
        }
        else{
            buttonstoprecord.isHidden = true
            stopRecordingReplayKit()
        }
        print("button pressed")
    }

    
    func videoQueue() -> DispatchQueue {
        return DispatchQueue.main
    }
    
    
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
        vc.delegate = delegate
        
        
        
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
    
    override var shouldAutorotate: Bool {
         return false
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

            let imageRectangle = CGRect(origin: .zero, size: frameSize)
            cgContext.draw(frame, in: imageRectangle)
            
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


        DispatchQueue.main.async { self.imageView.image = frameWithPosesRendering }

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
        DispatchQueue.global(qos: .userInteractive).async {
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
            self.recordEngga = false
           
            
        }
    }
    
}
