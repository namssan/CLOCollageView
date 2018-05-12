//
//  CLOCollageView.swift
//  CLOCollageView
//
//  Created by Sang Nam on 6/5/18.
//  Copyright © 2018 Sang Nam. All rights reserved.
//

import UIKit

enum CLOCollageViewDirection : Int {
    case none
    case left
    case right
    case top
    case bottom
    
    var string : String {
        switch self {
        case .left : return "left"
        case .right : return "right"
        case .top : return "top"
        case .bottom: return "bottom"
        default: return "none"
        }
    }
}


enum CLOCollageViewType : Int {
    case t301
    case t401
    case t402
    
    var getInstance : CLOCollageView {
        switch self {
        case .t301 : return CLOCollageViewT301()
        case .t401 : return CLOCollageViewT401()
        case .t402 : return CLOCollageViewT402()
        default: return CLOCollageViewT402()
        }
    }
}


class CLOCollageView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var baseLineViews : [CLOBaseLineView] = []
    var collageCells : [CLOCollageCell] = []
    var marginLeftTopContraints : [NSLayoutConstraint] = []
    var marginRightBottomContraints : [NSLayoutConstraint] = []
    var paddingLeftTopContraints : [NSLayoutConstraint] = []
    var paddingRightBottomContraints : [NSLayoutConstraint] = []
    private var setPhoto : Bool = false
    var margin : CGFloat = 0.0
    var padding : CGFloat = 0.0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initBaseLines()
        
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initBaseLines()
        
        self.backgroundColor = .white
    }
    
    
    open func initBaseLines() {}
    
    
    func updatePadding(val : CGFloat) {
        
        for lc in self.paddingLeftTopContraints {
            lc.constant = val
        }
        for lc in self.paddingRightBottomContraints {
            lc.constant = -val
        }
        self.padding = val
        self.layoutIfNeeded()
    }
    
    func updateMargin(val : CGFloat) {
        
        for lc in self.marginLeftTopContraints {
            lc.constant = val
        }
        for lc in self.marginRightBottomContraints {
            lc.constant = -val
        }
        self.margin = val
        self.layoutIfNeeded()
    }
    
    func setPhotos(photos : [UIImage]) {
        
        guard !setPhoto else { return }
        setPhoto = true
        
        for (i,photo) in photos.enumerated() {
            guard i < self.collageCells.count else { break }
            let cell = self.collageCells[i]
            cell.photoView.setPhoto(img: photo)
        }
    }

}


extension CLOCollageView : CLOCollageCellDelegate {
    
    func didSelectCell(cellId: Int) {
        
        for cell in self.collageCells {
            if cell.id != cellId {
                cell.isSelected = false
            }
        }
    }
}

extension CLOCollageView : CLOLineHandleViewDataSource {
    
    func sizeView() -> CGSize {
        let size = self.frame.size
        return size
    }
    
    func canMove(to: CGPoint, minLen: CGFloat, baseLine: CLOBaseLineView) -> Bool {
        
        var count = 0
        for cell in self.collageCells {
            for lh in cell.lineHandles {
                guard let hbl = lh.baseLineView else { continue }
                guard let preLayer = cell.layer.presentation() else { continue }
                
                if hbl.id == baseLine.id {
                    let w = preLayer.bounds.size.width
                    let h = preLayer.bounds.size.height
//                    if to == .right && lh.attachedTo == .left {
//                        count += 1
//                        if w <= minLen { return false }
//                    }
//                    if to == .left && lh.attachedTo == .right {
//                        count += 1
//                        if w <= minLen { return false }
//                    }
//                    if to == .top && lh.attachedTo == .bottom {
//                        count += 1
//                        if h <= minLen { return false }
//                    }
//                    if to == .bottom && lh.attachedTo == .top {
//                        count += 1
//                        if h <= minLen { return false }
//                    }
                }
            }
        }
        
//        print("found count: \(count)")
        return true
    }
}
