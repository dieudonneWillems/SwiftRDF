//
//  RDFNavigation.swift
//  Ontologist
//
//  Created by Don Willems on 21/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa
import SwiftRDFOSX

class RDFNavigation: NSObject, NSOutlineViewDelegate, NSOutlineViewDataSource, NSTableViewDelegate,NSTableViewDataSource {
    
    var documents = [RDFDocument]()
    
    var fileNavigationView : NSOutlineView?
    var statementsTable : NSTableView?
    var visibleGraph : Graph?
    
    func setVisibleGraphFromSelection() {
        visibleGraph = selectedGraph()
    }
    
    func selectedGraph() -> Graph? {
        let selectedRows = fileNavigationView?.selectedRowIndexes
        if selectedRows?.count > 1 {
            let graph = Graph()
            for row in selectedRows! {
                let rowGraph = graphAtRowInFileNavigationView(row)
                if rowGraph != nil {
                    graph.add(rowGraph!)
                }
            }
            return graph
        } else {
            if selectedRows?.count > 0 {
                return graphAtRowInFileNavigationView((selectedRows?.firstIndex)!)
            }
        }
        return nil
    }
    
    func graphAtRowInFileNavigationView(row : Int) -> Graph? {
        let item = fileNavigationView?.itemAtRow(row)
        if item != nil {
            if (item as? RDFDocument) != nil {
                return (item as! RDFDocument).graph!
            }else if (item as? Resource) != nil {
                let parentItem = fileNavigationView?.parentForItem(item)
                if parentItem != nil && (parentItem as? RDFDocument) != nil {
                    let parentGraph = (parentItem as! RDFDocument).graph!
                    let namedGraph = parentGraph.subGraph(nil, predicate: nil, object: nil, namedGraph: (item as! Resource))
                    return namedGraph
                }
            }
        }
        return nil
    }
    
    
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
    
    
    // MARK: Outline view delegate functions
    
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
    
    func outlineViewSelectionDidChange(notification: NSNotification) {
        print("Navigation view selection changed")
        setVisibleGraphFromSelection()
        statementsTable?.reloadData()
    }
    
    
    // MARK: Table Datasource functions
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if visibleGraph != nil {
            return visibleGraph!.count
        }
        return 0
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        if visibleGraph != nil {
            let graph = visibleGraph!
            let statement = graph[row]
            if tableColumn?.title == "Subject" {
                return statement.subject
            } else if tableColumn?.title == "Predicate" {
                return statement.predicate
            } else if tableColumn?.title == "Object" {
                return statement.object
            }
        }
        return "NO ITEM"
    }
    
    // MARK: Table Delegate functions 
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 16
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView == statementsTable {
            let item = self.tableView(tableView, objectValueForTableColumn: tableColumn, row: row)
            if (item as? Resource) != nil {
                var title = "No title"
                var tooltip : String? = nil
                if (item as? URI) != nil {
                    let uri = (item as! URI)
                    let qname = visibleGraph?.qualifiedName(uri)
                    if qname != nil {
                        title = qname!
                    }else {
                        title = uri.stringValue
                    }
                    tooltip = uri.stringValue
                } else if (item as? BlankNode) != nil {
                    let bnode = (item as! BlankNode)
                    title = bnode.stringValue
                }
                let cell = statementsTable!.makeViewWithIdentifier("ResourceCellView", owner: self) as? ResourceCellView
                if cell != nil {
                    cell!.textField!.stringValue = title
                    cell?.toolTip = tooltip
                }
                return cell
            } else if (item as? Literal) != nil {
                let cell = statementsTable!.makeViewWithIdentifier("LiteralCellView", owner: self) as? LiteralCellView
                cell?.literal = (item as! Literal)
                return cell
            }
        }
        return nil
    }
}
