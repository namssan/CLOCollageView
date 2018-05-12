//
//  CLOCollageCell.swift
//  CLOCollageView
//
//  Created by Sang Nam on 6/5/18.
//  Copyright © 2018 Sang Nam. All rights reserved.
//

import UIKit

protocol CLOCollageCellDelegate : class {
    func didSelectCell(cellId : Int)
}

class CLOCollageCell: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var id : Int = 0
    weak var delegate : CLOCollageCellDelegate?
    var isSelected : Bool = false {
        
        didSet {
            for lh in self.lineHandles {
                lh.isHidden = !self.isSelected
            }
            self.borderLayer.isHidden = !self.isSelected
        }
    }
    
    var lineHandles : [CLOLineHandleView] = []
    
    private lazy var tapGesture : UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(detectTap(_:)))
        return tapGesture
    } ()
    
    
    private lazy var borderLayer : UIView = {
        let view = UIView(frame: self.bounds)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear//UIColor.init(hex: 0x65dcff)
        view.isHidden = true
        self.addSubview(view)
        
        let xConst = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let yConst = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let wConst = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let hConst = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        view.layer.borderColor = UIColor(hex: 0x65dcff).cgColor
        view.layer.borderWidth = 3.0
        NSLayoutConstraint.activate([xConst,yConst,wConst,hConst])
        
        return view
    } ()
    
    lazy var photoView : CLOPhotoScrollView = {
        
        let view = CLOPhotoScrollView(frame: self.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        let xConst = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let yConst = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let wConst = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let hConst = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([xConst,yConst,wConst,hConst])
        
        return view
    } ()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(id : Int) {
        self.init(frame: .zero)
        self.id = id
        _ = self.photoView
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(hex: 0xE5E5E5) //UIColor.generateRandomColor()
        self.addGestureRecognizer(self.tapGesture)
    }
    
    
    func setHandles(handles : [CLOLineHandleView]) {
        self.lineHandles.removeAll()
        self.lineHandles += handles
    }
    
    @objc func detectTap(_ gesture : UITapGestureRecognizer) {
//        print("tap detected at cell id: \(id)")
//        guard self.isSelected else { return }
        self.isSelected = true
        self.delegate?.didSelectCell(cellId: id)
    }
}
