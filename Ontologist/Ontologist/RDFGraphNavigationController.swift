//
//  RDFGraphNavigationController.swift
//  Ontologist
//
//  Created by Don Willems on 19/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa
import SwiftRDFOSX

class RDFGraphNavigationController: NSViewController {
    
    var navigation = RDFNavigation()
    
    private(set) var visibleGraphView = VisibleGraphView.HierarchyView
    private var previousGraphView : VisibleGraphView? = VisibleGraphView.HierarchyView // only to be set when non-programaticaly switching
    
    private(set) var visibleHierarchy = OntologyGraph.CLASS_HIERARCHY
    
    @IBOutlet weak var graphNavigationView: NSOutlineView?
    @IBOutlet weak var hierarchyViewButton: NSButton?
    @IBOutlet weak var instancesViewButton: NSButton?
    @IBOutlet weak var propertiesViewButton: NSButton?
    @IBOutlet weak var searchViewButton: NSButton?
    
    @IBOutlet weak var classHierarchyViewButton: NSButton?
    @IBOutlet weak var skosHierarchyViewButton: NSButton?
    @IBOutlet weak var searchField: NSSearchField?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setVisibleGraphNavigationView(VisibleGraphView.HierarchyView)
        let nib2 = NSNib(nibNamed: "IconTextView", bundle: NSBundle.mainBundle())
        graphNavigationView!.registerNib(nib2!, forIdentifier: "IconTextView")
        // Do view setup here.
    }
    
    
    override var representedObject: AnyObject? {
        didSet {
            if representedObject != nil && (representedObject as? RDFNavigation) != nil {
                navigation = (representedObject as! RDFNavigation)
                navigation.graphNavigationViewController = self
                graphNavigationView?.setDelegate(navigation)
                graphNavigationView?.setDataSource(navigation)
                graphNavigationView?.reloadData()
            }
        }
    }
    
    func setVisibleGraphNavigationView(visibleView : VisibleGraphView){
        let previousGraphView = visibleGraphView
        visibleGraphView = visibleView
        instancesViewButton?.state = NSOffState
        propertiesViewButton?.state = NSOffState
        searchViewButton?.state = NSOffState
        hierarchyViewButton?.state = NSOffState
        if visibleGraphView == VisibleGraphView.HierarchyView {
            hierarchyViewButton?.state = NSOnState
        } else if visibleGraphView == VisibleGraphView.InstancesView {
            instancesViewButton?.state = NSOnState
        } else if visibleGraphView == VisibleGraphView.PropertiesView {
            propertiesViewButton?.state = NSOnState
        } else if visibleGraphView == VisibleGraphView.SearchView {
            searchViewButton?.state = NSOnState
        }
        if previousGraphView != visibleGraphView {
            if previousGraphView == VisibleGraphView.SearchView { // create history result set
                let query = searchField?.stringValue
                if query != nil {
                    navigation.addSearchResultsToHistory(query!)
                }
            }
            graphNavigationView?.reloadData()
        }
    }
    
    func setVisibleHierarchyView(visibleHierarchy : String){
        let previousHierarchy = self.visibleHierarchy
        self.visibleHierarchy = visibleHierarchy
        classHierarchyViewButton?.state = NSOffState
        skosHierarchyViewButton?.state = NSOffState
        if visibleHierarchy == OntologyGraph.CLASS_HIERARCHY {
            classHierarchyViewButton?.state = NSOnState
        } else if visibleHierarchy == OntologyGraph.SKOS_HIERARCHY {
            skosHierarchyViewButton?.state = NSOnState
        }
        if previousHierarchy != self.visibleHierarchy {
            graphNavigationView?.reloadData()
        }
    }
    
    @IBAction func graphNavigationViewSelected(sender: NSButton) {
        if sender == instancesViewButton {
            setVisibleGraphNavigationView(VisibleGraphView.InstancesView)
        } else if sender == propertiesViewButton {
            setVisibleGraphNavigationView(VisibleGraphView.PropertiesView)
        } else if sender == searchViewButton {
            setVisibleGraphNavigationView(VisibleGraphView.SearchView)
        } else if sender == hierarchyViewButton {
            setVisibleGraphNavigationView(VisibleGraphView.HierarchyView)
        }
        previousGraphView = self.visibleGraphView // set by user because in action
    }
    
    @IBAction func hierarchyViewSelected(sender: NSButton) {
        if sender == classHierarchyViewButton {
            setVisibleHierarchyView(OntologyGraph.CLASS_HIERARCHY)
        } else if sender == skosHierarchyViewButton {
            setVisibleHierarchyView(OntologyGraph.SKOS_HIERARCHY)
        }
    }
    
    @IBAction func search(sender: NSSearchField) {
        if sender == searchField && sender.stringValue.characters.count > 0 {
            navigation.searchOnLabel(sender.stringValue)
            setVisibleGraphNavigationView(VisibleGraphView.SearchView)
            graphNavigationView?.reloadData()
        } else if sender == searchField && sender.stringValue.characters.count <= 0 { // empty search
            if previousGraphView != nil {
                setVisibleGraphNavigationView(previousGraphView!)
                graphNavigationView?.reloadData()
            }
        }
    }
}

enum VisibleGraphView {
    case HierarchyView, InstancesView, PropertiesView, SearchView
}