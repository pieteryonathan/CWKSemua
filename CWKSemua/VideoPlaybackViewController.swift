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
import CoreData


class VideoPlaybackViewController: UIViewController, UIImagePickerControllerDelegate {
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    
    var videoURL: URL!
    var historys = [History]()
    let videoFileName = "/video.mp4"
    
    
    //connect this to your uiview in storyboard
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var fullScreen: UIView!
    override func viewDidLoad() {

            super.viewDidLoad()

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
        
        //MARK: Core data save
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "History", in: context)
        let newHistory = History(entity: entity!, insertInto: context)
        
        newHistory.videoId = historys.count as NSNumber
        newHistory.videoLink = videoURL.absoluteString
        newHistory.videoDate = Date()
        
        do {
            historys.append(newHistory)
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print("error")
        }
        return
        
    }
    
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Sorry"
        let message = (error == nil) ? "Video was saved!" : "Video failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
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
    
  
}





