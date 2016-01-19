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
        // Update the view, if already loaded.
            print("represented object: \(representedObject)")
            if (representedObject as? RDFDocument) != nil {
                let viewControllers = self.childViewControllers
                for viewController in viewControllers {
                    if (viewController as? RDFGraphNavigationController) != nil {
                        (viewController as! RDFGraphNavigationController).representedObject = (representedObject as! RDFDocument).graph
                    }
                }
            }
        }
    }


}

