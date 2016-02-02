//
//  FileView.swift
//  Ontologist
//
//  Created by Don Willems on 21/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa

class FileView: NSView {
    
    var backgroundStyle: NSBackgroundStyle = .Light {
        didSet {
            if backgroundStyle == .Light {
                if fileName != nil {
                    fileName?.textColor = NSColor.blackColor()
                }
                if numberOfStatements != nil {
                    numberOfStatements?.textColor = NSColor.grayColor()
                }
            } else if backgroundStyle == .Dark {
                if fileName != nil {
                    fileName?.textColor = NSColor.whiteColor()
                }
                if numberOfStatements != nil {
                    numberOfStatements?.textColor = NSColor.whiteColor()
                }
            }
        }
    }
    
    @IBOutlet weak var fileName: NSTextField?
    @IBOutlet weak var numberOfStatements: NSTextField?
    @IBOutlet weak var fileIcon: NSImageView?
    
    override func awakeFromNib() {
    }
}
