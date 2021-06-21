//
//  DetailViewController.swift
//  CWKSemua
//
//  Created by Leo nardo on 08/06/21.
//

import UIKit
import AVKit


class DetailViewController: UIViewController, DismissToMainDelegate {
  
    var playerLayer = AVPlayerLayer()

    @IBOutlet weak var descDetailLabel: UITextView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var beginButton: UIButton!
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descDetailLabel.isSelectable = false
        
        beginButton.setTwoGradient(width: beginButton.frame.size.width, height: beginButton.frame.size.height)
        // Do any additional setup after loading the view.
  
        playVideo(kotakview: previewView)
    }
    
    func dismiss() {
        print("kena di DetailViewController")
        navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    private func playVideo(kotakview: UIView) {
        guard let path = Bundle.main.path(forResource: "DescriptionVideo", ofType:"mov") else {
            debugPrint("video not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = kotakview.bounds
        playerLayer.videoGravity = .resizeAspectFill
        kotakview.layer.insertSublayer(playerLayer, at: 0)
        playerLayer.masksToBounds = true
        playerLayer.cornerRadius = 20
        kotakview.layer.cornerRadius = 20
     
        
        // Setup looping
                player.actionAtItemEnd = .none
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(playerItemDidReachEnd(notification:)),
                                                       name: .AVPlayerItemDidPlayToEndTime,
                                                       object: player.currentItem)
        
        player.play()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toShowCamera"{
            guard let destination = segue.destination as? PageViewController else{
                return
            }
            destination.delegate = self
        }
    }
    
    @IBAction func buttonPressed(){
        
        performSegue(withIdentifier: "toShowCamera", sender: self)
        
    }
    
    @objc
      func playerItemDidReachEnd(notification: Notification) {
          playerLayer.player?.seek(to: CMTime.zero)
      }

    
}
