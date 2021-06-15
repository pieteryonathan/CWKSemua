//
//  VideoPlaybackViewController.swift
//  CWKSemua
//
//  Created by Leo nardo on 08/06/21.
//

import UIKit
import AVFoundation
import MobileCoreServices
import AVKit


class VideoPlaybackViewController: UIViewController, UIImagePickerControllerDelegate {
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    
    var videoURL: URL!
    
    let videoFileName = "/video.mp4"
    
    
    //connect this to your uiview in storyboard
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var fullScreen: UIView!
    override func viewDidLoad() {

            super.viewDidLoad()

            self.getThumbnailImageFromVideoUrl(url: videoURL) { (thumbImage) in
            self.thumbnail.image = thumbImage
        }
        
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")

            avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.frame = fullScreen.bounds
            avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            fullScreen.layer.insertSublayer(avPlayerLayer, at: 0)
            videoView.layer.cornerRadius = 30
        videoView.setTwoGradient(width: videoView.frame.size.width, height: videoView.frame.size.height)
            view.layoutIfNeeded()
        }
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path  , self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Sorry"
        let message = (error == nil) ? "Video was saved!" : "Video failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { action in self.performSegue(withIdentifier: "home", sender: self) }))
        present(alert, animated: true, completion: nil)
    }
    
  

      
    @IBAction func playButton(_ sender: Any) {
        videoView.isHidden = false
        let playerItem = AVPlayerItem(url: videoURL as URL)
        let player = AVPlayer(url: videoURL as URL)
        let videoplayer = AVPlayerViewController()
        videoplayer.player = player
        self.present(videoplayer, animated: true) {
            videoplayer.player!.play()
        
//        avPlayer.replaceCurrentItem(with: playerItem)
//        avPlayer.play()
    }
}
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
}





