//
//  HomePageViewController.swift
//  CWKSemua
//
//  Created by Pieter Yonathan on 07/06/21.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var frontcourttrainingbutton: UIButton!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        }
        
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
      }
        

    
}

func deleteDataPlan(){
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let managedContext = appDelegate?.persistentContainer.viewContext
    var delete: [History] = []
    do {
        delete = try managedContext?.fetch(History.fetchRequest()) as! [History]
    } catch  {

    }

    for del in delete {
        managedContext?.delete(del)
    }
    do {
        try managedContext?.save()
    } catch  {

    }

    }

extension UINavigationController{
    open override var shouldAutorotate: Bool {
        return false
      }
}

extension UITabBarController{
    open override var shouldAutorotate: Bool {
        return false
      }
}


