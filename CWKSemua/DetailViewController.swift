//
//  DetailViewController.swift
//  CWKSemua
//
//  Created by Leo nardo on 08/06/21.
//

import UIKit

class DetailViewController: UIViewController, DismissToMainDelegate {
  
    

    @IBOutlet weak var descDetailLabel: UITextView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var beginButton: UIButton!
    
    
    @IBAction func buttonPressed(){
        
        performSegue(withIdentifier: "toShowCamera", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        beginButton.setTwoGradient(width: beginButton.frame.size.width, height: beginButton.frame.size.height)
        // Do any additional setup after loading the view.
        
        
       
    }
    
    func dismiss() {
        print("kena di DetailViewController")
        navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
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
    
    

}
