//
//  LiteralCellView.swift
//  Ontologist
//
//  Created by Don Willems on 30/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa
import SwiftRDFOSX

class LiteralCellView: NSView {
    
    var backgroundStyle: NSBackgroundStyle = .Light {
        didSet {
            if backgroundStyle == .Light {
            } else if backgroundStyle == .Dark {
            }
            self.needsDisplay = true
        }
    }

    
    var literal : Literal? {
        didSet {
            self.setNeedsDisplayInRect(self.frame)
        }
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        if literal != nil {
            var rightOffset : CGFloat = 0
            if literal!.language != nil {
                let languagestr = literal!.language!
                let nstrlang = (languagestr as NSString)
                var attrs = [String : AnyObject]()
                attrs[NSFontAttributeName] = NSFont.boldSystemFontOfSize(9)
                attrs[NSForegroundColorAttributeName] = NSColor.lightGrayColor()
                let strlangsize = nstrlang.sizeWithAttributes(attrs)
                let strrect = NSMakeRect(self.frame.width-13.5-strlangsize.width/2, (self.frame.height-strlangsize.height)/2+1, strlangsize.width, strlangsize.height)
                let cartrect = NSMakeRect(self.frame.width-27.5, (self.frame.height-strlangsize.height)/2-1.5, 26, strlangsize.height+2)
                NSColor.lightGrayColor().set()
                let cartouche = NSBezierPath(roundedRect: cartrect, xRadius: 4, yRadius: 4)
                cartouche.stroke()
                nstrlang.drawInRect(strrect, withAttributes: attrs)
                rightOffset = cartrect.width
            } else if literal!.dataType != nil {
                var datatypeStr = "<\(literal!.dataType?.stringValue)>"
                if literal!.dataType?.namespace == XSD.namespace() {
                    datatypeStr = "xsd:\(literal!.dataType!.localName)"
                }
                let nstrdt = (datatypeStr as NSString)
                var attrs = [String : AnyObject]()
                attrs[NSFontAttributeName] = NSFont.boldSystemFontOfSize(9)
                attrs[NSForegroundColorAttributeName] = NSColor.whiteColor()
                let dtstrsize = nstrdt.sizeWithAttributes(attrs)
                let strrect = NSMakeRect(self.frame.width-dtstrsize.width-4, (self.frame.height-dtstrsize.height)/2+1, dtstrsize.width, dtstrsize.height)
                let cartrect = NSMakeRect(self.frame.width-dtstrsize.width-7.5, (self.frame.height-dtstrsize.height)/2-1.5, dtstrsize.width+6, dtstrsize.height+2)
                NSColor.lightGrayColor().set()
                let cartouche = NSBezierPath(roundedRect: cartrect, xRadius: 4, yRadius: 4)
                cartouche.fill()
                nstrdt.drawInRect(strrect, withAttributes: attrs)
                rightOffset = cartrect.width
            }
            let strval = literal?.stringValue
            if strval != nil {
                let nstrval = (strval! as NSString)
                var attrs = [String : AnyObject]()
                attrs[NSFontAttributeName] = NSFont.systemFontOfSize(11)
                let strsize = nstrval.sizeWithAttributes(attrs)
                let strrect = NSMakeRect(4, (self.frame.height-strsize.height)/2, self.frame.width-4-rightOffset, strsize.height)
                nstrval.drawInRect(strrect, withAttributes: attrs)
            }
        }
    }
    
}
