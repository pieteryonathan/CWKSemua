//
//  PageViewController.swift
//  CWKSemua
//
//  Created by Pieter Yonathan on 08/06/21.
//

import UIKit

class PageViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var pageControl1: UIPageControl!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    var halamanterakhir = false
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        let imageArray = ["Page1","Page2","Page3"]
        scrollView.contentSize.width = CGFloat(imageArray.count)*scrollView.frame.width
        scrollView.isPagingEnabled = true
        
        for i in 0...imageArray.count-1 {
           
            var imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: imageArray[i])
            
            var imageWidth = scrollView.frame.width
            var imageHeight = scrollView.frame.height
            
            
            imageView.frame = CGRect(x: CGFloat(i)*imageWidth, y: 0, width: imageWidth, height: imageHeight)
            scrollView.addSubview(imageView)

            
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped(gestureRecognizer:)))
        scrollView.addGestureRecognizer(tap)

    }

@objc func scrollViewTapped(gestureRecognizer: UIGestureRecognizer) {
    if halamanterakhir == true {
        performSegue(withIdentifier: "moveToCamera", sender: self)
    }
}
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    let page = scrollView.contentOffset.x/CGFloat(245)
        
        if page < 4 {
            halamanterakhir = true
        }else{
            halamanterakhir = false
        }
        pageControl.currentPage = Int(page)
        pageControl1.currentPage = Int(page)
}

}

