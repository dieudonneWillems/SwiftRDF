//
//  RDFGraphNavigationController.swift
//  Ontologist
//
//  Created by Don Willems on 19/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa
import SwiftRDFOSX

class RDFGraphNavigationController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    var graph : Graph?
    
    // MARK: Outline Datasource functions
    
    optional func outlineView(_ outlineView: NSOutlineView,
        child index: Int,
        ofItem item: AnyObject?) -> AnyObject {
        
    }
    
    optional func outlineView(_ outlineView: NSOutlineView,
        isItemExpandable item: AnyObject) -> Bool {
            
    }
    
    optional func outlineView(_ outlineView: NSOutlineView,
        objectValueForTableColumn tableColumn: NSTableColumn?,
        byItem item: AnyObject?) -> AnyObject? {
            
    }
}
