//
//  StatementTableViewController.swift
//  Ontologist
//
//  Created by Don Willems on 20/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa

class StatementTableViewController: NSViewController {
    
    @IBOutlet weak var statementsTable: NSTableView?
    
    var navigation = RDFNavigation()

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = NSNib(nibNamed: "ResourceCellView", bundle: NSBundle.mainBundle())
        statementsTable!.registerNib(nib!, forIdentifier: "ResourceCellView")
        let nib2 = NSNib(nibNamed: "LiteralCellView", bundle: NSBundle.mainBundle())
        statementsTable!.registerNib(nib2!, forIdentifier: "LiteralCellView")
        // Do view setup here.
    }
    
    
    override var representedObject: AnyObject? {
        didSet {
            if representedObject != nil && (representedObject as? RDFNavigation) != nil {
                navigation = (representedObject as! RDFNavigation)
                navigation.statementsTableController = self
                statementsTable?.setDelegate(navigation)
                statementsTable?.setDataSource(navigation)
                statementsTable?.reloadData()
            }
        }
    }
    
    
}
