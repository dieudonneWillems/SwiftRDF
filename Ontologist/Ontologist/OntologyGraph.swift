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
    
    public static let CLASS_HIERARCHY = "CLASS"
    public static let PROPERTY_HIERARCHY = "Properties"
    public static let SKOS_HIERARCHY = "SKOS"
    public static let INSTANCES = "INSTANCES"
    
    
    // MARK: Hierarchy Index
    
    private var classIndex : HierarchyIndex?
    private var propertyIndex : HierarchyIndex?
    private var skosIndex : HierarchyIndex?
    private var instanceIndex : InstanceIndex?
    
    public override init() {
        super.init()
        classIndex = HierarchyIndex(identifier: OntologyGraph.CLASS_HIERARCHY, hierarchyNodeType: [RDFS.Class,OWL.Class], parentNodeProperty: RDFS.subClassOf, childNodeProperty: nil, requiresNodeType: false, indexedGraph: self)
        propertyIndex = HierarchyIndex(identifier: OntologyGraph.PROPERTY_HIERARCHY, hierarchyNodeType: [RDF.Property,OWL.ObjectProperty,OWL.OntologyProperty,OWL.DatatypeProperty,OWL.AnnotationProperty], parentNodeProperty: RDFS.subPropertyOf, childNodeProperty: nil, requiresNodeType: false, indexedGraph: self)
        skosIndex = HierarchyIndex(identifier: OntologyGraph.SKOS_HIERARCHY, hierarchyNodeType: [SKOS.Concept], parentNodeProperty: SKOS.broader, childNodeProperty: SKOS.narrower, requiresNodeType: true, indexedGraph: self)
        instanceIndex = InstanceIndex(identifier: OntologyGraph.INSTANCES, indexedGraph: self)
    }
    
    public func types(resource : Resource) -> [Resource] {
        if instanceIndex != nil {
            return instanceIndex!.types(resource)
        }
        return [Resource]()
    }
}
