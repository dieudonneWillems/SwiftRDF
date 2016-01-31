//
//  RDFNavigationController.swift
//  Ontologist
//
//  Created by Don Willems on 20/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa

class RDFNavigationController: NSSplitViewController {
    
    var navigation = RDFNavigation()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    override var representedObject: AnyObject? {
        didSet {
            if representedObject != nil && (representedObject as? RDFNavigation) != nil {
                navigation = representedObject as! RDFNavigation
                for itemView in self.childViewControllers {
                    itemView.representedObject = navigation
                }
            }
        }
    }
    
}
