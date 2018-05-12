//
//  CloPickerViewController.swift
//  CLOCollageView
//
//  Created by Sang Nam on 5/5/18.
//  Copyright © 2018 Sang Nam. All rights reserved.
//

import UIKit
import Photos

class CLOCellItem : NSObject {
    
    var indexPath : IndexPath!
    var image : UIImage!
    var timeQueued = Date()
    
    override var hash: Int {
        return self.indexPath.hashValue
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        let rhs = object as! CLOCellItem
        let result = (self.indexPath.compare(rhs.indexPath) == .orderedSame)
        return result
    }
}

class CloPickerViewController: UIViewController {
    
    @IBOutlet weak var headerTitleLbl: UILabel!
    @IBOutlet weak var menu01: UIView!
    @IBOutlet weak var menu02: UIView!
    @IBOutlet weak var menu03: UIView!
    @IBOutlet weak var menu04: UIView!
    
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        guard selectedItemSet.count > 0 else { return }
        self.selectedItemSet.removeAll()
        self.selectedItemArray.removeAll()
        self.selectedImageArray.removeAll()
        self.swipeView.reloadData()
        self.collectionView.reloadData()
    }
    
    
    let cachingImageManager = PHCachingImageManager()
    
    fileprivate var collageItems : [CLOCollageViewType] = [.t301,.t401,.t402,.t301,.t401,.t402,.t301,.t401,.t402]
    fileprivate var assets = [PHAsset]()
    fileprivate var selectedItemSet = Set<CLOCellItem>()
    fileprivate var selectedItemArray = [CLOCellItem]()
    fileprivate var selectedImageArray = [UIImage]()
    fileprivate var collageTransition = CLOCollageTransition()
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var swipeView: SwipeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fetchAsset()
        collectionView.dataSource = self
        collectionView.delegate = self
        swipeView.delegate = self
        swipeView.dataSource = self
        swipeView.isPagingEnabled = false
        swipeView.decelerationRate = 0.9
        
        self.collageItems = self.collageItems.sorted(by: { (a, b) -> Bool in
            return (arc4random_uniform(UInt32.max) % 2 == 0)
        })
        self.updateTitle()
        
        
        menu01.layer.borderColor = UIColor.darkGray.cgColor
        menu01.backgroundColor = .clear
        menu01.layer.borderWidth = 1.0
        
        menu02.layer.borderColor = UIColor.darkGray.cgColor
        menu02.backgroundColor = .clear
        menu02.layer.borderWidth = 1.0
        
        menu03.layer.borderColor = UIColor.darkGray.cgColor
        menu03.backgroundColor = .clear
        menu03.layer.borderWidth = 1.0
        
        menu04.layer.borderColor = UIColor.darkGray.cgColor
        menu04.backgroundColor = .clear
        menu04.layer.borderWidth = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func fetchAsset() {
        
        
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "favorite == YES")
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        let results = PHAsset.fetchAssets(with: .image, options: nil)
        results.enumerateObjects { (asset, _, _) in
            self.assets.append(asset)
        }
        
        
//        cachingImageManager.startCachingImages(for: assets,
//                                                        targetSize: PHImageManagerMaximumSize,
//                                                        contentMode: .aspectFit,
//                                                        options: nil
//        )
    }

    func updateTitle() {
        
        let count = self.selectedItemSet.count
        self.headerTitleLbl.text = String(format:"%d Items Selected",count)
    }
    
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
}

extension CloPickerViewController : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // default 100.0
        let w = self.collectionView.bounds.size.width
        let numCell = Int(w / 100.0) + 1
        let gap : CGFloat = 3.0
        let len = (w - (CGFloat(numCell - 1) * gap)) / CGFloat(numCell)
        let size = CGSize(width: len, height: len)
        return size
    }
}
extension CloPickerViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PickerViewCell else { return }
        let select = !cell.isCellSelected
        cell.isCellSelected = select
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = false
        let asset = self.assets[indexPath.item]
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                let img = UIImage(data: data)
                let item = CLOCellItem()
                item.indexPath = indexPath
                item.image = img
                item.timeQueued = Date()
                
                if select {
                    self.selectedItemSet.insert(item)
                   
                } else {
                    let t = self.selectedItemSet.remove(item)
                    if t == nil {
                        print("not found: \(indexPath)")
                    }
                }
                
                self.selectedImageArray.removeAll()
                self.selectedItemArray = Array(self.selectedItemSet).sorted { (a, b) -> Bool in
                    return a.timeQueued < b.timeQueued
                }
                for sitem in self.selectedItemArray {
                    self.selectedImageArray.append(sitem.image)
                }
                self.updateTitle()
                self.swipeView.reloadData()
                self.collectionView.reloadData()
            }
        }
    }
    
}

extension CloPickerViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickerCell", for: indexPath) as! PickerViewCell
        cell.initialize()
        let item = (indexPath as NSIndexPath).item
        let asset = assets[item]
        
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.isSynchronous = false
        
        let cellitem = CLOCellItem()
        cellitem.indexPath = indexPath
        cell.numLbl.text = ""
        cell.isCellSelected = self.selectedItemSet.contains(cellitem)
        if let idx = self.selectedItemArray.index(of: cellitem) {
            cell.numLbl.text = String(idx + 1)
        }
        
        let imgSize = CGSize(width: 200.0, height: 200.0)
        PHImageManager.default().requestImage(for: asset, targetSize: imgSize, contentMode: .aspectFill, options: option) { (img, info) in
            cell.imgView.image = img
        }
        
        return cell
    }
}


extension CloPickerViewController : UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        collageTransition.transitionMode = .present
        collageTransition.duration = 0.8
//            collageTransition.delegate = self
        return collageTransition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        collageTransition.transitionMode = .dismiss
        collageTransition.duration = 0.8
//        collageTransition.delegate = self
        return collageTransition
    }
    
}


extension CloPickerViewController : SwipeViewDelegate {
    
    func swipeView(_ swipeView: SwipeView!, didSelectItemAt index: Int) {
        
        guard self.selectedItemSet.count > 0 else { return }
        
        if let cell = swipeView.itemView(at: index) {
            guard let collage = cell.viewWithTag(123) as? CLOCollageView else { return }
            guard self.selectedImageArray.count > 0 else { return }
            self.view.layoutIfNeeded()
           
            let collageItem = self.collageItems[index]
            let rect = CGRect(origin: .zero, size: CGSize(width: collage.bounds.size.width * 4.0, height: collage.bounds.size.height * 4.0))
            let snapView = collageItem.getInstance
            snapView.frame = rect
            snapView.setPhotos(photos: self.selectedImageArray)
            snapView.updateMargin(val: 3.0 * 2.0)
            snapView.updatePadding(val: 1.5 * 2.0)
            self.view.insertSubview(snapView, belowSubview: self.collectionView)

            let snap = snapView.asImage(scale: 1.0)
            let startRect = collage.superview!.convert(collage.frame, to: self.view)
            print("start Rect: \(startRect)")
            self.collageTransition = CLOCollageTransition()
            self.collageTransition.snapImage = snap
            self.collageTransition.startRect = startRect
            self.collageTransition.originalCollageView = collage
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "CollageVC") as! CollageViewController
            vc.photoImages = self.selectedImageArray
            vc.collageType = collageItem
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .custom
//            self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: {
                snapView.removeFromSuperview()
            })
        }
    }
    
}

extension CloPickerViewController : SwipeViewDataSource {
    
    func numberOfItems(in swipeView: SwipeView!) -> Int {
        
        return collageItems.count
    }
    
    func swipeViewItemSize(_ swipeView: SwipeView!) -> CGSize {
        
        let h = swipeView.frame.size.height
        return CGSize(width: h * 0.8, height: h)
    }
    
    func swipeView(_ swipeView: SwipeView!, viewForItemAt index: Int, reusing view: UIView!) -> UIView! {
        
        let h = swipeView.frame.size.height
        let rect = CGRect(origin: .zero, size: CGSize(width: h * 0.8, height: h))
        let view = UIView(frame: rect)
        view.backgroundColor = .clear//UIColor.generateRandomColor()
        
        let collage = collageItems[index].getInstance
        collage.tag = 123
        collage.translatesAutoresizingMaskIntoConstraints = false
        collage.backgroundColor = .white
        view.addSubview(collage)
        
        let xConst = NSLayoutConstraint(item: collage, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConst = NSLayoutConstraint(item: collage, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        let wConst = NSLayoutConstraint(item: collage, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.9, constant: 0)
        let hConst = NSLayoutConstraint(item: collage, attribute: .height, relatedBy: .equal, toItem: collage, attribute: .width, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([xConst,yConst,wConst,hConst])
        
        collage.setPhotos(photos: self.selectedImageArray)
        collage.isUserInteractionEnabled = false
        collage.updateMargin(val: 3.0)
        collage.updatePadding(val: 1.5)
        
        return view
    }
}



extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage(scale : CGFloat) -> UIImage {
        let size = CGSize(width: bounds.size.width * scale, height: bounds.size.height * scale)
        let rect = CGRect(origin: .zero, size: size)
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { rendererContext in
//            layer.render(in: rendererContext.cgContext)
            self.drawHierarchy(in: rect, afterScreenUpdates: true)
        }
    }
}

