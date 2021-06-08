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
        frontcourttrainingbutton.setTwoGradient(width: frontcourttrainingbutton.frame.size.width, height: frontcourttrainingbutton.frame.size.height)
    }

}
