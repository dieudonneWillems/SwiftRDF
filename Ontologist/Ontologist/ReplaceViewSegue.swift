//
//  ReplaceViewSegue.swift
//  Ontologist
//
//  Created by Don Willems on 24/02/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa

class ReplaceViewSegue: NSStoryboardSegue {
    
    override func perform() {
        let animator = ReplacementAnimator()
        let originalViewController  = self.sourceController as! NSViewController
        let replacementViewController = self.destinationController as! NSViewController
        replacementViewController.view.frame = originalViewController.view.frame
        print("Original view controller view: \(originalViewController.view)")
        print("Original view controller subviews: \(originalViewController.view.subviews)")
        originalViewController.presentViewController(replacementViewController, animator: animator)
        replacementViewController.view.translatesAutoresizingMaskIntoConstraints = false
        replacementViewController.view.leadingAnchor.constraintEqualToAnchor(originalViewController.view.leadingAnchor).active = true
        replacementViewController.view.topAnchor.constraintEqualToAnchor(originalViewController.view.topAnchor).active = true
        replacementViewController.view.widthAnchor.constraintEqualToAnchor(originalViewController.view.widthAnchor).active = true
        replacementViewController.view.heightAnchor.constraintEqualToAnchor(originalViewController.view.heightAnchor).active = true
    }
    
}

class ReplacementAnimator: NSObject, NSViewControllerPresentationAnimator {
    
    @objc func  animatePresentationOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        let bottomVC = fromViewController
        let topVC = viewController
        topVC.view.wantsLayer = true
        topVC.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        topVC.view.alphaValue = 0
        bottomVC.view.addSubview(topVC.view)
        let frame : CGRect = NSRectToCGRect(bottomVC.view.frame)
        topVC.view.frame = NSRectFromCGRect(frame)
        let color: CGColorRef = NSColor.grayColor().CGColor
        topVC.view.layer?.backgroundColor = color
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.2
            topVC.view.animator().alphaValue = 1
            
            }, completionHandler: nil)
        
    }
    
    
    @objc func  animateDismissalOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        //let bottomVC = fromViewController
        let topVC = viewController
        topVC.view.wantsLayer = true
        topVC.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        topVC.view.removeFromSuperview()
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.2
            topVC.view.animator().alphaValue = 0
            }, completionHandler: {
                topVC.view.removeFromSuperview()
        })
    }
    
}