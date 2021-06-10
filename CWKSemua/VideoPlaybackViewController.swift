//
//  VideoPlaybackViewController.swift
//  CWKSemua
//
//  Created by Leo nardo on 08/06/21.
//

import UIKit
import AVFoundation
import MobileCoreServices

class VideoPlaybackViewController: UIViewController, UIImagePickerControllerDelegate {
    
    
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var movieOutput = AVCaptureMovieFileOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    
    var videoURL: URL!
    
    let videoFileName = "/video.mp4"
    
    
    //connect this to your uiview in storyboard
    
    @IBOutlet weak var videoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = videoView.bounds
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoView.layer.insertSublayer(avPlayerLayer, at: 0)
        videoView.layer.cornerRadius = 30
        view.layoutIfNeeded()
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path  , self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
        print("save pendet")
    }
        
        
       @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
            let title = (error == nil) ? "Success" : "Error"
            let message = (error == nil) ? "Video was saved" : "Video failed to save"
            print(error)
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        
        @IBAction func playButton(_ sender: Any) {
            let decorlayer = CAGradientLayer()
            decorlayer.cornerRadius = 30
            let playerItem = AVPlayerItem(url: videoURL as URL)
            avPlayer.replaceCurrentItem(with: playerItem)
            avPlayerLayer.cornerRadius = 30
            avPlayerLayer.insertSublayer(decorlayer, at: 0)
            avPlayer.play()
        }
    }
    


    

