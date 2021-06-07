//
//  HomePageViewController.swift
//  CWKSemua
//
//  Created by Pieter Yonathan on 07/06/21.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var backcourttrainingbutton: UIButton!
    @IBOutlet weak var frontcourttrainingbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frontcourttrainingbutton.settwogradient()
        backcourttrainingbutton.settwogradient()
    }

}
