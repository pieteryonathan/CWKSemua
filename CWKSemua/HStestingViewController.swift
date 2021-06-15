//
//  HStestingViewController.swift
//  CWKSemua
//
//  Created by jona on 15/06/21.
//

import UIKit
import CoreData
import AVFoundation
import AVKit

class HStestingViewController: UIViewController {

    var historys = [History]()
    var firstLoad = true
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    
    
    @IBOutlet weak var historyFullScreen: UIView!
    @IBOutlet weak var testingCollection: UICollectionView!
    
    
    let HistoryTesting = [mainan(title: "bola basket"),
                          mainan(title: "bola sepak")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let xib = UINib(nibName: "\(HistoryCollectionViewCell.self)", bundle: nil)
        testingCollection.register(xib, forCellWithReuseIdentifier: "hstestingCell")
        
        if (firstLoad) {
            firstLoad = false
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        do{
            historys = try context.fetch(History.fetchRequest())
        }
        catch{
            
        }
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = historyFullScreen.bounds
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        historyFullScreen.layer.insertSublayer(avPlayerLayer, at: 0)
    
    }

}

extension HStestingViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        historys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hstestingCell", for: indexPath) as! HistoryCollectionViewCell
        
        let thisHistory: History!
        thisHistory = historys[indexPath.row]
        
        cell.testingLabel.text = dateToString(date: thisHistory.videoDate!)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = URL(fileURLWithPath: historys[indexPath.row].videoLink!)
        let player = AVPlayer(url: url)
        let videoplayer = AVPlayerViewController()
        videoplayer.player = player
        self.present(videoplayer, animated: true){
            videoplayer.player!.play()
        }
    }
    
}


func dateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM y, HH:mm"
    return dateFormatter.string(from: date)
}
