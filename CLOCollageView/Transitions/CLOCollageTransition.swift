//
//  BubbleTransition.swift
//  CloDiary
//
//  Created by Sang Nam on 20/2/18.
//  Copyright © 2018 Sang Nam. All rights reserved.
//

import UIKit

protocol CloTransitionDelegate : class {
    func didFinishPresent()
    func didFinishDismiss()
}


open class CLOCollageTransition: NSObject {
    
    /**
     The point that originates the bubble. The bubble starts from this point
     and shrinks to it on dismiss
     */
    weak var delegate : CloTransitionDelegate?
    open var startRect : CGRect = .zero {
        didSet {
            snapView.frame = startRect
        }
    }

    open var duration = 1.2
    open var transitionMode: BubbleTransitionMode = .present
    open var snapImage: UIImage?
    open var originalCollageView : UIView?
    
    open fileprivate(set) var snapView = UIImageView(frame: .zero)
    @objc public enum BubbleTransitionMode: Int {
        case present, dismiss, pop
    }
}

extension CLOCollageTransition: UIViewControllerAnimatedTransitioning {
    
    // MARK: - UIViewControllerAnimatedTransitioning
    /**
     Required by UIViewControllerAnimatedTransitioning
     */
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    /**
     Required by UIViewControllerAnimatedTransitioning
     */
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let W = UIScreen.main.bounds.size.width
        
        if transitionMode == .present {
            
            let fromViewController = transitionContext.viewController(forKey: .from) as? CloPickerViewController
            let toViewController = transitionContext.viewController(forKey: .to) as? CollageViewController
            
            fromViewController?.beginAppearanceTransition(false, animated: true)
            toViewController?.beginAppearanceTransition(true, animated: true)
            
            let toView = transitionContext.view(forKey: .to)!
//            let originalCenter = presentedControllerView.center
//            let originalSize = presentedControllerView.frame.size
//            let targetCenter = toViewController!.collageView.center
            
            var targetRect : CGRect = .zero
            
            if toViewController != nil {
                targetRect = toViewController!.collageView.frame
                targetRect.origin.y += 10.0
            }
            
            
            toView.transform = CGAffineTransform(translationX: W, y: 0.0)
            containerView.addSubview(toView)
            
            snapView.image = snapImage
            snapView.frame = startRect
            containerView.addSubview(snapView)
            originalCollageView?.isHidden = true
            print("targetRect: \(targetRect) -- snap start: \(snapView.frame)")
            
            UIView.animate(withDuration: 0.3, animations: {
                fromViewController?.view.transform = CGAffineTransform(translationX: -W, y: 0.0)
                toView.transform = .identity

            }) { (completed) in
                
            }
            
            UIView.animate(withDuration: duration, delay: 0.1, usingSpringWithDamping: 0.75, initialSpringVelocity: 1.0, options: [.beginFromCurrentState], animations: {
                self.snapView.frame = targetRect
            }) { (completed) in
                
                self.snapView.isHidden = true
                transitionContext.completeTransition(true)
                fromViewController?.view.transform = .identity
                fromViewController?.endAppearanceTransition()
                toViewController?.endAppearanceTransition()
                toViewController?.collageView.isHidden = false
                self.delegate?.didFinishPresent()
            }
            
        } else {
            let fromViewController = transitionContext.viewController(forKey: .from) as? CollageViewController
            let toViewController = transitionContext.viewController(forKey: .to) as? CloPickerViewController
            fromViewController?.beginAppearanceTransition(false, animated: true)
            toViewController?.beginAppearanceTransition(true, animated: true)
            
            let returningControllerView = transitionContext.view(forKey: .from)!
   
            
            var targetRect : CGRect = .zero
            if fromViewController != nil {
                targetRect = fromViewController!.collageView.frame
                targetRect.origin.y += 10.0
            }
            
            snapView.isHidden = false
            snapView.image = snapImage
            snapView.frame = targetRect

            fromViewController!.collageView.isHidden = true
            print("targetRect: \(targetRect) -- snap start: \(snapView.frame)")
            
            toViewController?.view.transform = CGAffineTransform(translationX: -W, y: 0.0)
            UIView.animate(withDuration: 0.5, animations: {
                fromViewController?.view.transform = CGAffineTransform(translationX: W, y: 0.0)
                toViewController?.view.transform = .identity
                
            }) { (completed) in
                
            }
            
            UIView.animate(withDuration: duration, delay: 0.1, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: [.beginFromCurrentState], animations: {
                self.snapView.frame = self.startRect
            }) { (completed) in
//                returningControllerView.center = originalCenter
                self.snapView.removeFromSuperview()
                self.originalCollageView?.isHidden = false
                returningControllerView.removeFromSuperview()
                transitionContext.completeTransition(true)
                fromViewController?.endAppearanceTransition()
                toViewController?.endAppearanceTransition()
                self.delegate?.didFinishDismiss()
            }
        }
    }
}

private extension CLOCollageTransition {
    func frameForBubble(_ originalCenter: CGPoint, size originalSize: CGSize, start: CGPoint) -> CGRect {
        let lengthX = fmax(start.x, originalSize.width - start.x)
        let lengthY = fmax(start.y, originalSize.height - start.y)
        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2
        let size = CGSize(width: offset, height: offset)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
}
