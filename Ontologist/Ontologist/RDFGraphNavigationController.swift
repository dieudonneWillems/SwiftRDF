//
//  RDFGraphNavigationController.swift
//  Ontologist
//
//  Created by Don Willems on 19/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa

class RDFGraphNavigationController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
            print("set represented graph: \(representedObject)")
        }
    }
    
}
