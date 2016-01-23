//
//  RDFNavigation.swift
//  Ontologist
//
//  Created by Don Willems on 21/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa
import SwiftRDFOSX

class RDFNavigation: NSObject, NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    var documents = [RDFDocument]()
    
    var fileNavigationView : NSOutlineView?
    
    
    // MARK: Outline Datasource functions
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if outlineView == fileNavigationView {
            if item == nil {
                return documents.count
            } else if (item as? RDFDocument) != nil {
                return ((item as! RDFDocument).graph?.namedGraphs.count)!
            }
        } else {
            
        }
        return 0
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if outlineView == fileNavigationView {
            if item == nil {
                return documents[index]
            } else if (item as? RDFDocument) != nil {
                return ((item as! RDFDocument).graph?.namedGraphs[index])!
            }
        } else {
            
        }
        return "NO ITEM"
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        if outlineView == fileNavigationView {
            if (item as? RDFDocument) != nil {
                return ((item as! RDFDocument).graph?.namedGraphs.count > 0)
            }
        } else {
            
        }
        return false
    }
    
    
    /// MARK: Delegate methods
    
    func outlineView(outlineView: NSOutlineView, heightOfRowByItem item: AnyObject) -> CGFloat {
        if outlineView == fileNavigationView {
            if (item as? RDFDocument) != nil {
                return 30
            }
            if (item as? Resource) != nil {
                return 20
            }
        }
        return 22
    }

    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        if outlineView == fileNavigationView {
            if (item as? RDFDocument) != nil {
                let document = item as! RDFDocument
                let cell = outlineView.makeViewWithIdentifier("FileView", owner: self) as? FileView
                if cell != nil {
                    cell!.fileName!.stringValue = (document.fileURL?.lastPathComponent)!
                    cell?.numberOfStatements?.stringValue = "\(document.graph!.count) Statements"
                }
                return cell
            }
            if (item as? Resource) != nil {
                let resource = item as! Resource
                let cell = outlineView.makeViewWithIdentifier("IconTextView", owner: self) as? IconTextView
                if cell != nil {
                    var title = "named graph"
                    var tooltip : String? = nil
                    if (resource as? URI) != nil {
                        title = (resource as! URI).localName
                        tooltip = (resource as! URI).stringValue
                    } else if (resource as? BlankNode) != nil {
                        title = (resource as! BlankNode).identifier
                    }
                    cell!.textField!.stringValue = title
                    cell?.toolTip = tooltip
                }
                return cell
            }
        }
        return nil
    }
}
