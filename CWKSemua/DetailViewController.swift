//
//  DetailViewController.swift
//  CWKSemua
//
//  Created by Leo nardo on 08/06/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var descDetailLabel: UITextView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var beginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        beginButton.setTwoGradient(width: beginButton.frame.size.width, height: beginButton.frame.size.height)
        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
