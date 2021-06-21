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
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            
            do{
                historys = try context.fetch(History.fetchRequest())
                testingCollection.reloadData()
            }
            catch{
                
            }
        }
        
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = historyFullScreen.bounds
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        historyFullScreen.layer.insertSublayer(avPlayerLayer, at: 0)
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view Will appear")
        testingCollection.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view did appeaar")
        testingCollection.reloadData()
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
        cell.imageViewThumbnail.layer.cornerRadius = 10
        
        
        let fileURL = URL(fileURLWithPath: thisHistory.videoLink!)
        getThumbnailImageFromVideoUrl(url: fileURL) { (result) in
            cell.imageViewThumbnail.image = result
        }
        
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
//
//self.getThumbnailImageFromVideoUrl(url: URL) { (thumbImage) in
//    self.thumbnail.image = thumbImage}

