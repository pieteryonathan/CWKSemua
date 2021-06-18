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
        
       //deleteDataPlan()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue((UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
    }

    override open var shouldAutorotate: Bool{
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
    func shouldAutorotate() -> Bool {
    if !viewControllers.isEmpty {

      // Check if this ViewController is the one you want to disable roration on
        if topViewController!.isKind(of: HomePageViewController.self){

        // If true return false to disable it
        return false
      }
    }

    // Else normal rotation enabled
    return false
    }
}


