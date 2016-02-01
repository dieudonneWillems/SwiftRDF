//
//  RDFFileNavigationController.swift
//  Ontologist
//
//  Created by Don Willems on 20/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa

class RDFFileNavigationController: NSViewController {
    
    var navigation = RDFNavigation()
    
    @IBOutlet weak var fileNavigationView: NSOutlineView?
    
    override func awakeFromNib() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = NSNib(nibNamed: "FileView", bundle: NSBundle.mainBundle())
        fileNavigationView!.registerNib(nib!, forIdentifier: "FileView")
        let nib2 = NSNib(nibNamed: "IconTextView", bundle: NSBundle.mainBundle())
        fileNavigationView!.registerNib(nib2!, forIdentifier: "IconTextView")
    }
    
    
    override var representedObject: AnyObject? {
        didSet {
            if representedObject != nil && (representedObject as? RDFNavigation) != nil {
                navigation = (representedObject as! RDFNavigation)
                navigation.fileNavigationViewController = self
                fileNavigationView?.setDelegate(navigation)
                fileNavigationView?.setDataSource(navigation)
                fileNavigationView?.reloadData()
            }
        }
    }
    
}
