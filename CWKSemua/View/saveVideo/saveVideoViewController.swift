//
//  saveVideoViewController.swift
//  CWKSemua
//
//  Created by Azka Kusuma on 09/06/21.
//

import UIKit
import MobileCoreServices
import AVKit

class saveVideoViewController: UIViewController, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var saveVideoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func playVideoTest(_ sender: Any) {
        
       
    }
    
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        dismiss(animated: true, completion: nil)
        
        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            // 1
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
            // 2
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
        else { return }
        
        // 3
        UISaveVideoAtPathToSavedPhotosAlbum(
            url.path,
            self,
            #selector(video(_:didFinishSavingWithError:contextInfo:)),
            nil)
    }
    
    @objc func video(
        _ videoPath: String,
        didFinishSavingWithError error: Error?,
        contextInfo info: AnyObject
    ) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
                            title: "OK",
                            style: UIAlertAction.Style.cancel,
                            handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
}

