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


class HistoryViewController: UIViewController {

    @IBOutlet weak var historyCollection: UICollectionView!
    
    @IBOutlet weak var historyFull: UIView!
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var historys = [History]()
    
//    var videoURL: URL!
    
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
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM y, HH:mm"
        return dateFormatter.string(from: date)
    }
    


//    @IBAction func historyPlayButton(_ sender: UIButton) {
//
//        let url = URL(fileURLWithPath: historys[])
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
        
        cell.dateLabel.text = dateToString(date: thisHistory.videoDate!)
        
      
        
        
        return cell
    }
    
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = URL(fileURLWithPath: historys[indexPath.row].videoLink!)
        let player = AVPlayer(url: url)
        let videoplayer = AVPlayerViewController()
        videoplayer.player = player
        self.present(videoplayer, animated: true) {
            videoplayer.player!.play()
        }
    }
    
}
    
    


extension HistoryViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 171, height: 193)
    }
}
