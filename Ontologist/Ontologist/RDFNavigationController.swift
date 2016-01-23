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
            // Update the view, if already loaded.
            print("represented object: \(representedObject)")
            if representedObject != nil && (representedObject as? RDFDocument) != nil {
                var docs = [RDFDocument]()
                docs.append((representedObject as! RDFDocument))
                navigation.documents = docs
                for itemView in self.childViewControllers {
                    itemView.representedObject = navigation
                }
            }
        }
    }
    
}
