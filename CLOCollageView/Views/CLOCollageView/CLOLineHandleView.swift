//
//  CLOLineHandleView.swift
//  CLOCollageView
//
//  Created by Sang Nam on 6/5/18.
//  Copyright © 2018 Sang Nam. All rights reserved.
//

import UIKit

protocol CLOLineHandleViewDataSource : class {
    func sizeView() -> CGSize
    func canMove(to : CGPoint, minLen : CGFloat, baseLine : CLOBaseLineView) -> Bool
}

class CLOLineHandleView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var attachedTo : CLOCollageViewDirection = .left
    var baseLineView : CLOBaseLineView?
    weak var datasource : CLOLineHandleViewDataSource?
    
    fileprivate let minLen : CGFloat = 80.0
    fileprivate var prevLoc : CGPoint = .zero

    private lazy var panGesture : UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(detectPan(_:)))
        panGesture.delegate = self
        return panGesture
    } ()
    
    func initialize(attach : CLOCollageViewDirection, blview : CLOBaseLineView, cell : CLOCollageCell) {
    
        self.attachedTo = attach
        self.baseLineView = blview
        self.isHidden = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        var xConst, yConst, wConst, hConst : NSLayoutConstraint!
        let thick : CGFloat = 40.0
        let adjust : CGFloat = (thick / 2.0) - (3.0 / 2.0)
        
        if attach == .left || attach == .right {
            
            if attach == .left {
                xConst = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: cell, attribute: .left, multiplier: 1, constant: -adjust)
            } else {
                xConst = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: cell, attribute: .right, multiplier: 1, constant: adjust)
            }
            yConst = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: cell, attribute: .centerY, multiplier: 1, constant: 0)
            wConst = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: thick)
            hConst = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: cell, attribute: .height, multiplier: 1.0, constant: 0)
            
            
        } else {
            
            if attach == .top {
                yConst = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1, constant: -adjust)
            } else {
                yConst = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: cell, attribute: .bottom, multiplier: 1, constant: adjust)
            }
            xConst = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: cell, attribute: .centerX, multiplier: 1, constant: 0)
            wConst = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: cell, attribute: .width, multiplier: 1.0, constant: 0)
            hConst = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: thick)
        }
        NSLayoutConstraint.activate([xConst,yConst,wConst,hConst])
        
        
        
        let notch = UIView()
        notch.backgroundColor = UIColor.init(hex: 0x65dcff)
        notch.layer.cornerRadius = 4.0
        notch.clipsToBounds = true
        notch.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(notch)
        
        xConst = NSLayoutConstraint(item: notch, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        yConst = NSLayoutConstraint(item: notch, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        if attach == .top || attach == .bottom {
            wConst = NSLayoutConstraint(item: notch, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0)
            hConst = NSLayoutConstraint(item: notch, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 8.0)
            
        } else {
            wConst = NSLayoutConstraint(item: notch, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 8.0)
            hConst = NSLayoutConstraint(item: notch, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0)
        }
        NSLayoutConstraint.activate([xConst,yConst,wConst,hConst])
        
        
        self.addGestureRecognizer(self.panGesture)
    }

    
    @objc func detectPan(_ gesture : UIPanGestureRecognizer) {
        
        let loc1 = gesture.location(in: self)
        var loc = self.convert(loc1, to: self.superview)

        guard let ds = self.datasource else { return }
        let maxSize = ds.sizeView()
        
        if loc.x < minLen { loc.x = minLen }
        if loc.y < minLen { loc.y = minLen }
        if loc.x > (maxSize.width - minLen) { loc.x = (maxSize.width - minLen) }
        if loc.y > (maxSize.height - minLen) { loc.y = (maxSize.height - minLen) }
        
        if (gesture.state == .began) {
        
        } else if (gesture.state == .cancelled || gesture.state == .ended || gesture.state == .failed) {

        } else {
            if let bline = self.baseLineView {
                if let bcst = bline.baseLC {
        
//                    if !ds.canMove(to: loc, minLen: minLen, baseLine: bline) {
//                        loc = prevLoc
//                    }
                    
//                    if !ds.canMove(to: fDir, minLen: minLen, baseLine: bline) {
//                        blockDirections.append(fDir)
//                    } else {
////                        blockDirections.removeAll()
//                    }
//                    for dir in blockDirections {
//                        if dir.rawValue == fDir.rawValue { return }
//                    }

                    // IMPORTANT
                    // new_width = multiplier * width + (constant)
                    let multiplier = bcst.multiplier
                    var newLC : CGFloat = 0.0
                    if bline.moveType == .leftRight {
                        newLC = loc.x - (multiplier * maxSize.width)
                    } else {
                        newLC = loc.y - (multiplier * maxSize.height)
                    }
                    bcst.constant = newLC
                    self.layoutIfNeeded()
                    prevLoc = loc
                }
            }
        }
    }
    
}

extension CLOLineHandleView : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            let gest = gestureRecognizer as! UIPanGestureRecognizer
            let velocity = gest.velocity(in: self)
            let isVertical = fabs(velocity.y) > fabs(velocity.x)
//            print("THIS IS VERTICAL GESTURE? \(isVertical)")
            
            guard let bline = self.baseLineView else { return false }
            if bline.moveType == .leftRight {
                return !isVertical
            }
            return isVertical
        }
        return true
    }
    
}
