//
//  RDFDocumentWindowController.swift
//  Ontologist
//
//  Created by Don Willems on 19/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa

class RDFDocumentWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    override var document: AnyObject? {
        didSet {
            // Update the view, if already loaded.
            print("set represented graph: \(document)")
            self.contentViewController?.representedObject = document
        }
    }
    
    func startProgress(document: RDFDocument) {
        print("started parsing")
        if (self.contentViewController as? MainSplitViewController) != nil {
            let msvc = (self.contentViewController as? MainSplitViewController)
            msvc?.startProgress()
        }
    }

    func documentHasBeenParsed(document: RDFDocument) {
        print("data has been parsed")
        if (self.contentViewController as? MainSplitViewController) != nil {
            let msvc = (self.contentViewController as? MainSplitViewController)
            msvc?.documentHasBeenParsed(document)
        }
    }
}
