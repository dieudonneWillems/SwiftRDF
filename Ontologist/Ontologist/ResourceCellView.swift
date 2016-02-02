//
//  ResourceCellView.swift
//  Ontologist
//
//  Created by Don Willems on 30/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa

class ResourceCellView: NSView {
    
    var backgroundStyle: NSBackgroundStyle = .Light {
        didSet {
            if backgroundStyle == .Light {
                if textField != nil {
                    textField?.textColor = NSColor.blackColor()
                }
            } else if backgroundStyle == .Dark {
                if textField != nil {
                    textField?.textColor = NSColor.whiteColor()
                }
            }
        }
    }

    
    @IBOutlet weak var textField: NSTextField?
    
}
