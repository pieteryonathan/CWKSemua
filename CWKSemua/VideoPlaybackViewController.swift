//
//  VideoPlaybackViewController.swift
//  CWKSemua
//
//  Created by Leo nardo on 08/06/21.
//

import UIKit
import AVFoundation

class VideoPlaybackViewController: UIViewController {

    let avPlayer = AVPlayer()
        var avPlayerLayer: AVPlayerLayer!

        var videoURL: URL!
    
 
    
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
