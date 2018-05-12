//
//  CLOPhotoScrollView.swift
//  CLOCollageView
//
//  Created by Sang Nam on 7/5/18.
//  Copyright © 2018 Sang Nam. All rights reserved.
//

import UIKit

class CLOPhotoScrollView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var photoImage : UIImageView!
    lazy var scrollView : UIScrollView = {
        
        let view = UIScrollView(frame: self.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.minimumZoomScale = 0.1
        view.maximumZoomScale = 3.0
        self.addSubview(view)
        
        var xConst = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        var yConst = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        var wConst = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        var hConst = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([xConst,yConst,wConst,hConst])
        
        self.photoImage = UIImageView(frame: view.bounds)
        self.photoImage.contentMode = .scaleAspectFill
        self.photoImage.translatesAutoresizingMaskIntoConstraints = false
//        self.photoImage.layer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        view.addSubview(self.photoImage)
        xConst = NSLayoutConstraint(item: self.photoImage, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        yConst = NSLayoutConstraint(item: self.photoImage, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        wConst = NSLayoutConstraint(item: self.photoImage, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        hConst = NSLayoutConstraint(item: self.photoImage, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([xConst,yConst,wConst,hConst])
        
        
        return view
    } ()
    
    
    private var imgSize : CGSize = .zero
    private var prevSize : CGSize = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    
    override func layoutSubviews() {
         super.layoutSubviews()
//        print("layout subview called")
        self.calculateZoomScale()
    }
    
    
    private func calculateZoomScale() {
        
        guard imgSize != .zero else { return }
        let size = self.bounds.size
//        print("re-calculate zoom scale: \(size)")
        let W = size.width
        let H = size.height
        let w = imgSize.width
        let h = imgSize.height
        
        let ratio = max(W/w, H/h)
        let isInMininum = (self.scrollView.minimumZoomScale == self.scrollView.zoomScale)
        
        self.scrollView.minimumZoomScale = ratio
        if (self.scrollView.zoomScale < ratio) || (isInMininum) {
            self.scrollView.zoomScale = ratio
        }
    }
    
    private func initialize() {
        
        _ = self.scrollView
    }
    
    func setPhoto(img : UIImage) {

        self.photoImage.image = img
        self.imgSize = img.size
        self.calculateZoomScale()
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale
    }
}

extension CLOPhotoScrollView : UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImage
    }
}
