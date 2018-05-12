//
//  CollageViewController.swift
//  CLOCollageView
//
//  Created by Sang Nam on 6/5/18.
//  Copyright © 2018 Sang Nam. All rights reserved.
//

import UIKit

class CollageViewController: UIViewController {

    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var containerView: UIView!
//    @IBOutlet weak var collageView: CLOCollageView!
    
    var collageRatio : CGFloat = 1.0
    var collageType : CLOCollageViewType = .t301
    var photoImages : [UIImage]?
    
    lazy var collageView : CLOCollageView = { 
        
        let view = self.collageType.getInstance
        let len = self.containerView.frame.size.width * 0.9
        let size = CGSize(width: len, height: len * self.collageRatio)
        
        view.frame = CGRect(x: (self.containerView.frame.size.width - size.width) / 2.0, y: (self.containerView.frame.size.height - size.height) / 2.0, width: size.width, height: size.height)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        
        let lc01 = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self.containerView, attribute: .centerX, multiplier: 1, constant: 0)
        let lc02 = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self.containerView, attribute: .centerY, multiplier: 1, constant: 0)
        let lc03 = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: self.containerView, attribute: .width, multiplier: 0.9, constant: 0)
        let lc04 = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: self.collageRatio, constant: 0)
        NSLayoutConstraint.activate([ lc01, lc02, lc03, lc04])
        
//        let shadowView = ShadowView(frame: CGRect(origin: .zero, size: size))
//        shadowView.translatesAutoresizingMaskIntoConstraints = false
//        shadowView.backgroundColor = .clear
//        view.addSubview(shadowView)
//
//        var lConst = NSLayoutConstraint(item: shadowView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
//        var rConst = NSLayoutConstraint(item: shadowView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
//        var tConst = NSLayoutConstraint(item: shadowView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
//        var bConst = NSLayoutConstraint(item: shadowView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
//        NSLayoutConstraint.activate([ lConst, rConst, tConst, bConst])
        
        return view
    } ()
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    
    @IBAction func progressChanged(_ sender: Any) {
        
        let progress = CGFloat(Int(progressBar.value * 30.0))
//        print("progress change: \(progress)")
        self.collageView.updatePadding(val: progress)
//        self.collageView.updateMargin(val: progress)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    
//    override var prefersStatusBarHidden: Bool {
//        get {
//            return true
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        _ = self.collageView
        collageView.updateMargin(val: 3.0)
        collageView.updatePadding(val: 1.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("vc view did layout subviews")
        if let imgs = self.photoImages {
            self.collageView.setPhotos(photos: imgs)
            
            print("final Rect: \(self.collageView.frame)")
        }
     
//        if let img = UIImage(named: "img01") {
//            self.collageView.setPhotos(photos: [img,img,img,img])
//        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class ShadowView : UIView {
    
    lazy var shadowLayer : CALayer = {
        
        // constants
        let radius: CGFloat = 24.0, offset = 0.0
        // shadow layer
        let slayer = CALayer()
        slayer.shadowColor = UIColor.gray.cgColor
        slayer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        slayer.shadowOffset = CGSize(width: offset, height: offset)
        slayer.shadowOpacity = 0.4
        slayer.shadowRadius = 8.0
        self.layer.addSublayer(slayer)
        
        return slayer
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowLayer.frame = self.bounds
    }
}
