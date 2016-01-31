//
//  ViewController.swift
//  Ontologist
//
//  Created by Don Willems on 18/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {
    
    var navigation = RDFNavigation()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
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

