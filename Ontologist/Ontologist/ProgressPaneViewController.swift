//
//  ProgressPaneViewController.swift
//  Ontologist
//
//  Created by Don Willems on 26/02/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa

class ProgressPaneViewController: NSViewController {
    
    @IBOutlet weak var titleLabel: NSTextField?
    @IBOutlet weak var subtitleLabel: NSTextField?
    @IBOutlet weak var progressIndicatior: NSProgressIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "progressUpdated:", name: "RDFDocumentProgressChanged", object: nil)
    }
    
    override var representedObject: AnyObject? {
        didSet {
            for itemView in self.childViewControllers {
                itemView.representedObject = representedObject
            }
        }
    }
    
    @objc func progressUpdated(notification: NSNotification){
        print("Progress Notification recieved: \(notification)")
        let userobject = notification.userInfo
        var target : Double? = nil
        var progress : Double? = nil
        var title : String? = nil
        var subtitle : String? = nil
        if userobject != nil {
            if (userobject!["target"] as? Double) != nil {
                let uo = userobject!["target"] as! Double
                if uo >= 0 {
                    target = uo
                }
            }
            if (userobject!["progress"] as? Double) != nil {
                let uo = userobject!["progress"] as! Double
                progress = uo
            }
            if (userobject!["title"] as? String) != nil {
                let uo = userobject!["title"] as! String
                title = uo
            }
            if (userobject!["subtitle"] as? String) != nil {
                let uo = userobject!["subtitle"] as! String
                subtitle = uo
            }
        }
        if title != nil {
            titleLabel?.stringValue = title!
        }
        if subtitle != nil {
            subtitleLabel?.stringValue = subtitle!
        }
        if target == nil {
            progressIndicatior?.indeterminate = true
            progressIndicatior?.startAnimation(self)
        }else if progress != nil {
            progressIndicatior?.indeterminate = false
            progressIndicatior?.maxValue = target!
            progressIndicatior?.minValue = 0.0
            progressIndicatior?.doubleValue = progress!
        }
    }
    
    
}