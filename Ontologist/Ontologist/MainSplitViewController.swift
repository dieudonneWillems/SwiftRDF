//
//  ViewController.swift
//  Ontologist
//
//  Created by Don Willems on 18/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
            for itemView in self.childViewControllers {
                itemView.representedObject = self.representedObject
            }
        }
    }

}

