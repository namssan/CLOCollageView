//
//  CLOCollageViewT401.swift
//  CLOCollageView
//
//  Created by Sang Nam on 7/5/18.
//  Copyright © 2018 Sang Nam. All rights reserved.
//
import UIKit
class CLOCollageViewT402: CLOCollageView {
    override func initBaseLines() {
        
        let W = self.frame.size.width
        let H = self.frame.size.height
        
        // initialize baseline
        let baseLine01 = CLOBaseLineView()
        baseLine01.id = 1
        baseLine01.moveType = .upDown
        baseLine01.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(baseLine01)
        
        let lc01 = NSLayoutConstraint(item: baseLine01, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let lc02 = NSLayoutConstraint(item: baseLine01, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let lc03 = NSLayoutConstraint(item: baseLine01, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let lc04 = NSLayoutConstraint(item: baseLine01, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: (3.0/4.0), constant: 0)
        NSLayoutConstraint.activate([ lc01, lc02, lc03, lc04])
        baseLine01.baseLC = lc04
        
        
        let baseLine02 = CLOBaseLineView()
        baseLine02.id = 2
        baseLine02.moveType = .leftRight
        baseLine02.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(baseLine02)
        
        let lc05 = NSLayoutConstraint(item: baseLine02, attribute: .top, relatedBy: .equal, toItem: baseLine01, attribute: .bottom, multiplier: 1, constant: 0)
        let lc06 = NSLayoutConstraint(item: baseLine02, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let lc07 = NSLayoutConstraint(item: baseLine02, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: (1.0/3.0), constant: 0)
        let lc08 = NSLayoutConstraint(item: baseLine02, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([ lc05, lc06, lc07, lc08])
        baseLine02.baseLC = lc07
        
        
        let baseLine03 = CLOBaseLineView()
        baseLine03.id = 3
        baseLine03.moveType = .leftRight
        baseLine03.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(baseLine03)
        
        let lc09 = NSLayoutConstraint(item: baseLine03, attribute: .top, relatedBy: .equal, toItem: baseLine01, attribute: .bottom, multiplier: 1, constant: 0)
        let lc10 = NSLayoutConstraint(item: baseLine03, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let lc11 = NSLayoutConstraint(item: baseLine03, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: (2.0/3.0), constant: 0)
        let lc12 = NSLayoutConstraint(item: baseLine03, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([ lc09, lc10, lc11, lc12])
        baseLine03.baseLC = lc11
        
        self.baseLineViews += [baseLine01,baseLine02,baseLine03]
        
        self.initCells()
        
    }
    
    private func initCells() {
        
        let cell01 = CLOCollageCell(id: 1)
        cell01.delegate = self
        self.addSubview(cell01)
        let lc01 = NSLayoutConstraint(item: cell01, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let lc02 = NSLayoutConstraint(item: cell01, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let lc03 = NSLayoutConstraint(item: cell01, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant:0)
        let lc04 = NSLayoutConstraint(item: cell01, attribute: .bottom, relatedBy: .equal, toItem: self.baseLineViews[0], attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([ lc01, lc02, lc03, lc04])
        
        
        let cell02 = CLOCollageCell(id: 2)
        cell02.delegate = self
        self.addSubview(cell02)
        let lc05 = NSLayoutConstraint(item: cell02, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let lc06 = NSLayoutConstraint(item: cell02, attribute: .top, relatedBy: .equal, toItem: self.baseLineViews[0], attribute: .bottom, multiplier: 1, constant: 0)
        let lc07 = NSLayoutConstraint(item: cell02, attribute: .right, relatedBy: .equal, toItem: self.baseLineViews[1], attribute: .right, multiplier: 1, constant: 0)
        let lc08 = NSLayoutConstraint(item: cell02, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant:0)
        NSLayoutConstraint.activate([ lc05, lc06, lc07, lc08])
        
        
        let cell03 = CLOCollageCell(id: 3)
        cell03.delegate = self
        self.addSubview(cell03)
        let lc09 = NSLayoutConstraint(item: cell03, attribute: .left, relatedBy: .equal, toItem: self.baseLineViews[1], attribute: .right, multiplier: 1, constant: 0)
        let lc10 = NSLayoutConstraint(item: cell03, attribute: .top, relatedBy: .equal, toItem: self.baseLineViews[0], attribute: .bottom, multiplier: 1, constant: 0.0)
        let lc11 = NSLayoutConstraint(item: cell03, attribute: .right, relatedBy: .equal, toItem: self.baseLineViews[2], attribute: .right, multiplier: 1, constant: 0)
        let lc12 = NSLayoutConstraint(item: cell03, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant:0)
        NSLayoutConstraint.activate([ lc09, lc10, lc11, lc12])
        
        let cell04 = CLOCollageCell(id: 4)
        cell04.delegate = self
        self.addSubview(cell04)
        let lc13 = NSLayoutConstraint(item: cell04, attribute: .left, relatedBy: .equal, toItem: self.baseLineViews[2], attribute: .right, multiplier: 1, constant: 0)
        let lc14 = NSLayoutConstraint(item: cell04, attribute: .top, relatedBy: .equal, toItem: self.baseLineViews[0], attribute: .bottom, multiplier: 1, constant: 0)
        let lc15 = NSLayoutConstraint(item: cell04, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let lc16 = NSLayoutConstraint(item: cell04, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant:0)
        NSLayoutConstraint.activate([ lc13, lc14, lc15, lc16])
        
        self.marginLeftTopContraints += [lc01,lc02,lc05]
        self.marginRightBottomContraints += [lc03,lc08,lc12,lc15,lc16]
        self.paddingLeftTopContraints += [lc06,lc09,lc10,lc13,lc14]
        self.paddingRightBottomContraints += [lc04,lc07,lc11]
        self.collageCells += [cell01,cell02,cell03,cell04]
        
        self.initHandles()
    }
    
    
    private func initHandles() {
        
        let cell01 = self.collageCells[0]
        var handle01, handle02, handle03 : CLOLineHandleView!
        
        handle01 = CLOLineHandleView()
        self.addSubview(handle01)
        handle01.initialize(attach: .bottom, blview: self.baseLineViews[0], cell: cell01)
        handle01.datasource = self
        cell01.setHandles(handles: [handle01])
        
        let cell02 = self.collageCells[1]
        handle01 = CLOLineHandleView()
        self.addSubview(handle01)
        handle01.initialize(attach: .top, blview: self.baseLineViews[0], cell: cell02)
        handle01.datasource = self
        handle02 = CLOLineHandleView()
        self.addSubview(handle02)
        handle02.initialize(attach: .right, blview: self.baseLineViews[1], cell: cell02)
        handle02.datasource = self
        cell02.setHandles(handles: [handle01,handle02])
        
        let cell03 = self.collageCells[2]
        handle01 = CLOLineHandleView()
        self.addSubview(handle01)
        handle01.initialize(attach: .top, blview: self.baseLineViews[0], cell: cell03)
        handle01.datasource = self
        handle02 = CLOLineHandleView()
        self.addSubview(handle02)
        handle02.initialize(attach: .left, blview: self.baseLineViews[1], cell: cell03)
        handle02.datasource = self
        handle03 = CLOLineHandleView()
        self.addSubview(handle03)
        handle03.initialize(attach: .right, blview: self.baseLineViews[2], cell: cell03)
        handle03.datasource = self
        cell03.setHandles(handles: [handle01,handle02,handle03])
        
        
        let cell04 = self.collageCells[3]
        handle01 = CLOLineHandleView()
        self.addSubview(handle01)
        handle01.initialize(attach: .top, blview: self.baseLineViews[0], cell: cell04)
        handle01.datasource = self
        handle02 = CLOLineHandleView()
        self.addSubview(handle02)
        handle02.initialize(attach: .left, blview: self.baseLineViews[2], cell: cell04)
        handle02.datasource = self
        cell04.setHandles(handles: [handle01,handle02])
        
    }
}
