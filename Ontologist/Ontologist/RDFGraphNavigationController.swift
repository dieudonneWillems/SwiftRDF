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
    
    @IBOutlet weak var graphNavigationView: NSOutlineView?
    @IBOutlet weak var hierarchyViewButton: NSButton?
    @IBOutlet weak var instancesViewButton: NSButton?
    @IBOutlet weak var propertiesViewButton: NSButton?
    @IBOutlet weak var searchViewButton: NSButton?

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
    }
}

enum VisibleGraphView {
    case HierarchyView, InstancesView, PropertiesView, SearchView
}