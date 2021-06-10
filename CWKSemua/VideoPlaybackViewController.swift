//
//  VideoPlaybackViewController.swift
//  CWKSemua
//
//  Created by Leo nardo on 08/06/21.
//

import UIKit
import AVFoundation
import AVKit

class VideoPlaybackViewController: UIViewController {


    let avPlayer = AVPlayer()
        var avPlayerLayer: AVPlayerLayer!

        var videoURL: URL!
    
 
    
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
            view.layoutIfNeeded()
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
