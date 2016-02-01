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
    
    var fileNavigationViewController : RDFFileNavigationController?
    var graphNavigationViewController : RDFGraphNavigationController?
    var statementsTableController : StatementTableViewController?
    var visibleGraph : Graph?
    var visibleGraphForSelectedFile : Graph?
    
    func setVisibleGraphFromSelection() {
        visibleGraph = selectedGraph
    }
    
    var selectedGraph : Graph? {
        let selectedRows = fileNavigationViewController?.fileNavigationView!.selectedRowIndexes
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
                visibleGraphForSelectedFile = graphAtRowInFileNavigationView((selectedRows?.firstIndex)!)
            }
        }
        let selectedRowsGraphs = graphNavigationViewController?.graphNavigationView?.selectedRowIndexes
        if selectedRowsGraphs?.count > 0 {
            visibleGraph = Graph()
            for row in selectedRowsGraphs! {
                let rowGraph = graphAtRowInGraphNavigationView(row)
                if rowGraph != nil {
                    visibleGraph!.add(rowGraph!)
                }
            }
            return visibleGraph
        }
        return visibleGraphForSelectedFile
    }
    
    func graphAtRowInFileNavigationView(row : Int) -> Graph? {
        let item = fileNavigationViewController?.fileNavigationView!.itemAtRow(row)
        if item != nil {
            if (item as? RDFDocument) != nil {
                return (item as! RDFDocument).graph!
            }else if (item as? Resource) != nil {
                let parentItem = fileNavigationViewController?.fileNavigationView!.parentForItem(item)
                if parentItem != nil && (parentItem as? RDFDocument) != nil {
                    let parentGraph = (parentItem as! RDFDocument).graph!
                    let namedGraph = parentGraph.subGraph(nil, predicate: nil, object: nil, namedGraph: (item as! Resource))
                    return namedGraph
                }
            }
        }
        return nil
    }
    
    func graphAtRowInGraphNavigationView(row : Int) -> Graph? {
        let item = graphNavigationViewController?.graphNavigationView!.itemAtRow(row)
        if item != nil {
            if (item as? Resource) != nil {
                let resource = (item as! Resource)
                let graph = Graph()
                let subjgraph = visibleGraphForSelectedFile?.subGraph(resource, predicate: nil, object: nil)
                if subjgraph != nil {
                    graph.add(subjgraph!)
                }
                let objgraph = visibleGraphForSelectedFile?.subGraph(nil, predicate: nil, object: resource)
                if objgraph != nil {
                    graph.add(objgraph!)
                }
                return graph
            }
        }
        return nil
    }
    
    
    // MARK: Outline Datasource functions
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if outlineView == fileNavigationViewController?.fileNavigationView {
            if item == nil {
                return documents.count
            } else if (item as? RDFDocument) != nil {
                return ((item as! RDFDocument).graph?.namedGraphs.count)!
            }
        } else if outlineView == graphNavigationViewController?.graphNavigationView {
            let visibleGraphView = graphNavigationViewController!.visibleGraphView
            if visibleGraphView == VisibleGraphView.InstancesView {
                return (visibleGraphForSelectedFile?.resources.count)!
            }
        } else {
            
        }
        return 0
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if outlineView == fileNavigationViewController?.fileNavigationView {
            if item == nil {
                return documents[index]
            } else if (item as? RDFDocument) != nil {
                return ((item as! RDFDocument).graph?.namedGraphs[index])!
            }
        } else if outlineView == graphNavigationViewController?.graphNavigationView {
            let visibleGraphView = graphNavigationViewController!.visibleGraphView
            if visibleGraphView == VisibleGraphView.InstancesView {
                if item == nil {
                    return (visibleGraphForSelectedFile?.resources[index])!
                }
            }
        } else {
            
        }
        return "NO ITEM"
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        if outlineView == fileNavigationViewController?.fileNavigationView {
            if (item as? RDFDocument) != nil {
                return ((item as! RDFDocument).graph?.namedGraphs.count > 0)
            }
        } else if outlineView == graphNavigationViewController?.graphNavigationView {
            let visibleGraphView = graphNavigationViewController!.visibleGraphView
            if visibleGraphView == VisibleGraphView.InstancesView {
                return false
            }
        } else {
            
        }
        return false
    }
    
    
    // MARK: Outline view delegate functions
    
    func outlineView(outlineView: NSOutlineView, heightOfRowByItem item: AnyObject) -> CGFloat {
        if outlineView == fileNavigationViewController?.fileNavigationView {
            if (item as? RDFDocument) != nil {
                return 30
            }
        }
        return 20
    }

    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        if outlineView == fileNavigationViewController?.fileNavigationView {
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
        } else if outlineView == graphNavigationViewController?.graphNavigationView {
            let visibleGraphView = graphNavigationViewController!.visibleGraphView
            if visibleGraphView == VisibleGraphView.InstancesView {
                let resource = item as! Resource
                let cell = outlineView.makeViewWithIdentifier("IconTextView", owner: self) as? IconTextView
                if cell != nil {
                    var title = "resource"
                    var tooltip : String? = nil
                    cell?.icon?.image = NSImage(named: "instance")
                    if (resource as? URI) != nil {
                        title = (resource as! URI).stringValue
                        if visibleGraphForSelectedFile != nil {
                            let qname = visibleGraphForSelectedFile?.qualifiedName((resource as! URI))
                            if qname != nil {
                                title = qname!
                            }
                        }
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
        statementsTableController?.statementsTable!.reloadData()
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
        if tableView == statementsTableController?.statementsTable {
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
                let cell = statementsTableController?.statementsTable!.makeViewWithIdentifier("ResourceCellView", owner: self) as? ResourceCellView
                if cell != nil {
                    cell!.textField!.stringValue = title
                    cell?.toolTip = tooltip
                }
                return cell
            } else if (item as? Literal) != nil {
                let cell = statementsTableController?.statementsTable!.makeViewWithIdentifier("LiteralCellView", owner: self) as? LiteralCellView
                cell?.literal = (item as! Literal)
                return cell
            }
        }
        return nil
    }
}
