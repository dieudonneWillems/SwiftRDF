//
//  OntologyGraph.swift
//  Ontologist
//
//  Created by Don Willems on 02/02/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Foundation
import SwiftRDFOSX

public class OntologyGraph : IndexedGraph {
    
    // MARK: Indexes for class specific data
    
    /**
     A list of resources that represent a Class (`owl:Class` or `rdfs:Class`).
     */
    public private(set) var classes = [Resource]()
    
    /// Dictionary with class id as key and set of statements in which the class is either subject or object.
    private var statementsPerClass = [String : Graph]()
    
    // Dictionary with class id as key and set of resources that are subclasses of this class.
    private var subclassesPerClass = [String : [Resource]]()
    
    // Dictionary with class id as key and set of resources that are superclasses of this class.
    private var superclassesPerClass = [String : [Resource]]()
    
    // Dictionary with class id as key and set of properties for which the class is in the domain. Should take subclassing into account.
    private var classAsDomainProperties = [String : [URI]]()
    
    // Dictionary with class id as key and set of properties for which the class is in the range. Should take subclassing into account.
    private var classAsRangeProperties = [String : [URI]]()
    
    
    
    // MARK: Indexes for property specific data
    
    /// Dictionary with property id as key and set of statements in which the property is either subject or object.
    private var statementsPerProperty = [String : Graph]()
    
    
    
    
    // MARK: Indexes for class instances
    
    // Dictionary with class id as key and set of resources that are instances of this class.
    private var instancesPerClass = [String : [Resource]]()
}
