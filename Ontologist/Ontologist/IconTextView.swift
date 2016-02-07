//
//  IconTextView.swift
//  Ontologist
//
//  Created by Don Willems on 23/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa

class IconTextView: NSView {
    
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
    @IBOutlet weak var icon: NSImageView?
    
}
