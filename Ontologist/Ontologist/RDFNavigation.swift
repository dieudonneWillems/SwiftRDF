//
//  RDFNavigation.swift
//  Ontologist
//
//  Created by Don Willems on 21/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa
import OntologistPlugins
import SwiftRDFOSX

class RDFNavigation: NSObject, NSOutlineViewDelegate, NSOutlineViewDataSource, NSTableViewDelegate,NSTableViewDataSource {
    
    var document : RDFDocument? = nil
    
    var fileNavigationViewController : RDFFileNavigationController?
    var graphNavigationViewController : RDFGraphNavigationController?
    var statementsTableController : StatementTableViewController?
    var fullGraph : OntologyGraph?
    var visibleGraph : Graph?
    var visibleGraphForSelectedFile : Graph?
    
    var searchResults = [Resource]()
    var searchHistory = [SearchResultSet]()
    
    var selectedGraph : Graph? {
        let selectedRow = fileNavigationViewController?.fileNavigationView!.selectedRow
        var namedGraph : Resource?
        visibleGraphForSelectedFile = fullGraph
        if selectedRow >= 0  {
            visibleGraphForSelectedFile = self.fileGraphAtRowInFileNavigationView(selectedRow!)
            namedGraph = self.namedGraphAtRowInFileNavigationView(selectedRow!)
        }
        let selectedRowsGraphs = graphNavigationViewController?.graphNavigationView?.selectedRowIndexes
        if selectedRowsGraphs?.count > 0 {
            visibleGraph = Graph()
            for row in selectedRowsGraphs! {
                let rowGraph = graphAtRowInGraphNavigationView(row, namedGraph: namedGraph)
                if rowGraph != nil {
                    visibleGraph!.add(rowGraph!)
                }
            }
            return visibleGraph
        } else if namedGraph != nil {
            visibleGraph = visibleGraphForSelectedFile?.subGraph(nil, predicate: nil, object: nil, namedGraph: namedGraph!)
            return visibleGraph
        }
        return visibleGraphForSelectedFile
    }
    
    func setRDFDocument(document : RDFDocument){
        fullGraph = OntologyGraph()
        if document.graph != nil {
            fullGraph?.add(document.graph!)
            fullGraph?.progressDelegate = document
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            self.fullGraph?.index()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.visibleGraphForSelectedFile = self.fullGraph
                self.visibleGraph = self.fullGraph
                self.fileNavigationViewController?.reloadData()
                self.graphNavigationViewController?.reloadData()
            }
        }
    }
    
    func setVisibleGraphFromSelection() {
        visibleGraph = selectedGraph
    }
    
    func fileGraphAtRowInFileNavigationView(row : Int) -> Graph? {
        let item = fileNavigationViewController?.fileNavigationView!.itemAtRow(row)
        if item != nil {
            if (item as? RDFDocument) != nil {
                return (item as! RDFDocument).graph!
            }else if (item as? Resource) != nil {
                let parentItem = fileNavigationViewController?.fileNavigationView!.parentForItem(item)
                if parentItem != nil && (parentItem as? RDFDocument) != nil {
                    let parentGraph = (parentItem as! RDFDocument).graph!
                    return parentGraph
                }
            }
        }
        return nil
    }
    
    func namedGraphAtRowInFileNavigationView(row : Int) -> Resource? {
        let item = fileNavigationViewController?.fileNavigationView!.itemAtRow(row)
        if item != nil {
            if (item as? Resource) != nil {
                return (item as? Resource)
            }
        }
        return nil
    }
    
    func graphAtRowInGraphNavigationView(row : Int, namedGraph : Resource?) -> Graph? {
        let item = graphNavigationViewController?.graphNavigationView!.itemAtRow(row)
        if item != nil {
            if (item as? Resource) != nil {
                let resource = (item as! Resource)
                let graph = Graph()
                var subjgraph : Graph?
                if namedGraph == nil {
                    subjgraph = visibleGraphForSelectedFile?.subGraph(resource, predicate: nil, object: nil)
                }else {
                    subjgraph = visibleGraphForSelectedFile?.subGraph(resource, predicate: nil, object: nil, namedGraph: namedGraph!)
                }
                if subjgraph != nil {
                    graph.add(subjgraph!)
                }
                var objgraph : Graph?
                if namedGraph == nil {
                    objgraph = visibleGraphForSelectedFile?.subGraph(nil, predicate: nil, object: resource)
                } else {
                    objgraph = visibleGraphForSelectedFile?.subGraph(nil, predicate: nil, object: resource, namedGraph: namedGraph!)
                }
                if objgraph != nil {
                    graph.add(objgraph!)
                }
                return graph
            }
        }
        return nil
    }
    
    private func iconForResource(resource : Resource) -> NSImage {
        let resourceicon = PluginsManager.sharedPluginsManager.iconForResource(resource)
        if resourceicon != nil {
            return resourceicon!
        }
        let typeicon = PluginsManager.sharedPluginsManager.iconForInstance((fullGraph?.types(resource))!)
        if typeicon != nil {
            return typeicon!
        }
        return NSImage(named: "instance")!
    }
    
    
    // MARK: Searching
    
    func searchOnLabel(query : String) -> [Resource] {
        let results = (fullGraph?.searchOnLabel(query))
        if results != nil {
            searchResults = results!
            return results!
        }
        return [Resource]()
    }
    
    func addSearchResultsToHistory(query: String) {
        if query.characters.count > 0 && searchResults.count > 0 {
            let resultset = SearchResultSet(query: query, results: searchResults)
            searchHistory.insert(resultset, atIndex: 0)
        }
    }
    
    
    // MARK: Outline Datasource functions
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if outlineView == fileNavigationViewController?.fileNavigationView {
            if item == nil {
                if document == nil {
                    return 0
                }
                return 1
            } else if (item as? RDFDocument) != nil {
                return ((item as! RDFDocument).graph?.namedGraphs.count)!
            }
        } else if outlineView == graphNavigationViewController?.graphNavigationView {
            let visibleGraphView = graphNavigationViewController!.visibleGraphView
            if visibleGraphView == VisibleGraphView.InstancesView {
                return (fullGraph?.resources.count)!
            } else if visibleGraphView == VisibleGraphView.HierarchyView {
                let gindex = self.visibleHierarchyIndex()
                if gindex != nil {
                    if item == nil {
                        return gindex!.rootNodes.count
                    } else {
                        let resource = item as? Resource
                        if resource != nil {
                            let childnodes = gindex!.childNodes(resource!)
                            if childnodes != nil {
                                return childnodes!.count
                            }
                        }
                    }
                }
            } else if visibleGraphView == VisibleGraphView.PropertiesView {
                let gindex = fullGraph?.indexes[OntologyGraph.PROPERTY_HIERARCHY] as? HierarchyIndex
                if gindex != nil {
                    if item == nil {
                        return gindex!.rootNodes.count
                    } else {
                        let resource = item as? Resource
                        if resource != nil {
                            let childnodes = gindex!.childNodes(resource!)
                            if childnodes != nil {
                                return childnodes!.count
                            }
                        }
                    }
                }
            } else if visibleGraphView == VisibleGraphView.SearchView {
                if item == nil {
                    return searchResults.count + searchHistory.count
                } else if (item as? SearchResultSet) != nil {
                    let srs = (item as! SearchResultSet)
                    return srs.results.count
                }
            }
        } else {
            
        }
        return 0
    }
    
    func visibleHierarchyIndex() -> HierarchyIndex? {
        let visibleHierarchy = graphNavigationViewController?.visibleHierarchy
        if visibleHierarchy == OntologyGraph.CLASS_HIERARCHY {
            return fullGraph?.indexes[OntologyGraph.CLASS_HIERARCHY] as? HierarchyIndex
        } else if visibleHierarchy == OntologyGraph.SKOS_HIERARCHY {
            return fullGraph?.indexes[OntologyGraph.SKOS_HIERARCHY] as? HierarchyIndex
        }
        return nil
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if outlineView == fileNavigationViewController?.fileNavigationView {
            if item == nil {
                return document!
            } else if (item as? RDFDocument) != nil {
                return ((item as! RDFDocument).graph?.namedGraphs[index])!
            }
        } else if outlineView == graphNavigationViewController?.graphNavigationView {
            let visibleGraphView = graphNavigationViewController!.visibleGraphView
            if visibleGraphView == VisibleGraphView.InstancesView {
                if item == nil {
                    return (fullGraph?.resources[index])!
                }
            } else if visibleGraphView == VisibleGraphView.HierarchyView {
                let gindex = self.visibleHierarchyIndex()
                if gindex != nil {
                    if item == nil {
                        return gindex!.rootNodes[index]
                    } else {
                        let resource = item as? Resource
                        if resource != nil {
                            let childnodes = gindex!.childNodes(resource!)
                            if childnodes != nil {
                                return childnodes![index]
                            }
                        }
                    }
                }
            } else if visibleGraphView == VisibleGraphView.PropertiesView {
                let gindex = fullGraph?.indexes[OntologyGraph.PROPERTY_HIERARCHY] as? HierarchyIndex
                if gindex != nil {
                    if item == nil {
                        return gindex!.rootNodes[index]
                    } else {
                        let resource = item as? Resource
                        if resource != nil {
                            let childnodes = gindex!.childNodes(resource!)
                            if childnodes != nil {
                                return childnodes![index]
                            }
                        }
                    }
                }
            } else if visibleGraphView == VisibleGraphView.SearchView {
                if item == nil {
                    if index < searchResults.count {
                        return searchResults[index]
                    } else {
                        let hindex = index - searchResults.count
                        return searchHistory[hindex]
                    }
                } else if (item as? SearchResultSet) != nil {
                    let srs = (item as! SearchResultSet)
                    return srs.results[index]
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
            } else if visibleGraphView == VisibleGraphView.HierarchyView {
                let gindex = self.visibleHierarchyIndex()
                if gindex != nil {
                    let resource = item as? Resource
                    if resource != nil {
                        let childnodes = gindex!.childNodes(resource!)
                        if childnodes != nil {
                            return childnodes!.count > 0
                        }
                    }
                }
            } else if visibleGraphView == VisibleGraphView.PropertiesView {
                let gindex = fullGraph?.indexes[OntologyGraph.PROPERTY_HIERARCHY] as? HierarchyIndex
                if gindex != nil {
                    let resource = item as? Resource
                    if resource != nil {
                        let childnodes = gindex!.childNodes(resource!)
                        if childnodes != nil {
                            return childnodes!.count > 0
                        }
                    }
                }
            } else if visibleGraphView == VisibleGraphView.SearchView {
                if (item as? SearchResultSet) != nil {
                    return true
                }
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
            if visibleGraphView == VisibleGraphView.InstancesView || visibleGraphView == VisibleGraphView.HierarchyView || visibleGraphView == VisibleGraphView.PropertiesView || visibleGraphView == VisibleGraphView.SearchView {
                if (item as? Resource) != nil {
                    let resource = item as! Resource
                    let cell = outlineView.makeViewWithIdentifier("IconTextView", owner: self) as? IconTextView
                    if cell != nil {
                        var title = "resource"
                        var tooltip : String? = nil
                        cell?.icon?.image = self.iconForResource(resource)
                        if (resource as? URI) != nil {
                            title = (resource as! URI).stringValue
                            if fullGraph != nil {
                                let qname = fullGraph?.qualifiedName((resource as! URI))
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
                }else if (item as? SearchResultSet) != nil {
                    let srs = item as! SearchResultSet
                    let cell = outlineView.makeViewWithIdentifier("IconTextView", owner: self) as? IconTextView
                    if cell != nil {
                        let title = "\"\(srs.query)\" at \(srs.date.description)"
                        cell?.icon?.image = NSImage(named: "search")
                        cell!.textField!.stringValue = title
                    }
                    return cell
                }
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

class SearchResultSet {
    let date = NSDate()
    let query : String
    let results : [Resource]
    
    init(query : String, results : [Resource]){
        self.query = query
        self.results = results
    }
}
