//
//  HistoryViewController.swift
//  CWKSemua
//
//  Created by jona on 14/06/21.
//

import UIKit
import CoreData
import AVFoundation
import AVKit

var historys = [History]()

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyCollection: UICollectionView!
    
    @IBOutlet weak var historyFull: UIView!
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    
    var videoURL: URL!
    
    var firstLoad = true
    
    let videoFileName = "/video.mp4"
    
        override func viewDidLoad() {
        super.viewDidLoad()

            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")

            avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.frame = historyFull.bounds
            avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            historyFull.layer.insertSublayer(avPlayerLayer, at: 0)
            
            if (firstLoad){
                firstLoad = false
            
            
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
 
        do{
            historys = try context.fetch(History.fetchRequest())
        }
        catch{
            
        }
    }
        
        historyCollection?.delegate = self
        historyCollection?.dataSource = self
        historyCollection?.collectionViewLayout = UICollectionViewLayout()
    }
    


//    @IBAction func historyPlayButton(_ sender: UIButton) {
//
//        let player = AVPlayer(url: videoURL as URL)
//        let videoplayer = AVPlayerViewController()
//        videoplayer.player = player
//        self.present(videoplayer, animated: true) {
//            videoplayer.player!.play()
//        }
//    }
    
}

extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        historys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyDetailCell", for: indexPath) as! HistoryCollectionViewCell
        let thisHistory: History!
        thisHistory = historys[indexPath.row]
      
//        let fileURL = URL(fileURLWithPath: videoURL.path)
//        cell.videoURL = thisHistory.videoLink
        
        return cell
    }
    
    
}

extension HistoryViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 171, height: 193)
    }
}
