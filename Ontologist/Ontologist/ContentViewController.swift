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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showProgressNotification:", name: "ContentPaneShouldShowProgress", object: representedObject)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showErrorNotification:", name: "ContentPaneShouldShowError", object: representedObject)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showEditorNotification:", name: "ContentPaneShouldShowEditor", object: representedObject)
    }
    
    override var representedObject: AnyObject? {
        didSet {
            for itemView in self.childViewControllers {
                itemView.representedObject = representedObject
            }
        }
    }
    
    
    @objc func showProgressNotification(notification: NSNotification){
        self.showProgressView()
    }
    
    @objc func showErrorNotification(notification: NSNotification){
        self.showErrorView()
    }
    
    @objc func showEditorNotification(notification: NSNotification){
        self.showEditor()
    }
    
    func showProgressView() {
        performSegueWithIdentifier("progress", sender: self)
    }
    
    func showErrorView() {
        // TODO: Error view
    }

    func showEditor() {
        performSegueWithIdentifier("editor", sender: self)
    }
}
