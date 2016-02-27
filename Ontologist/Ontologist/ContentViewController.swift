//
//  ContentViewController.swift
//  Ontologist
//
//  Created by Don Willems on 24/02/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa

class ContentViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func showProgressView() {
        performSegueWithIdentifier("progress", sender: self)
    }

    func showEditor() {
        performSegueWithIdentifier("editor", sender: self)
    }
}
