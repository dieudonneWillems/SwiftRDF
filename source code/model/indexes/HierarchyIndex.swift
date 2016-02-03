//
//  HierarchyIndex.swift
//  
//
//  Created by Don Willems on 03/02/16.
//
//

import Foundation

/**
 A hierarchy index builds a hierarchy of nodes (of the types specified by `hierarchyNodeType`) and connected with parent-child
 relations (specified by `parentNodeProperty` and/or `childNodeProperty`). The hierarchy can then easily be accessed via the
 instance of this class.
 */
public class HierarchyIndex : Index {
    
    /**
     The type that has to be defined for a resource in the RDF graph (with the `rdf:type` property) for the
     resource to be a node in the hierarchy.
     */
    public let hierarchyNodeType : [Resource]
    
    /**
     A list types, one of which has to be defined for a resource in the RDF graph (with the `rdf:type` property) for the
     resource to be a node in the hierarchy. It consists of the provided `hierarchyNodeType` and its defined subclasses.
     */
    private var hierarchyNodeTypes = [Resource]()
    
    /**
     The parent node property that is used in the RDF graph to define parents of a node resource.
     This property can be `nil` when no parent node property is defined in the RDF graph.
     */
    public let parentNodeProperty : URI?
    
    /**
     All properties that can be used to specify a parent node of a node. It consists of the provided
     `parentNodeProperty` and sub-properties of this property when defined.
     */
    private var parentNodeProperties = [URI]()
    
    /**
     The child node property that is used in the RDF graph to define child nodes of a node resource.
     This property can be `nil` when no child node property is defined in the RDF graph.
     */
    public let childNodeProperty : URI?
    
    /**
     All properties that can be used to specify a child node of a node. It consists of the provided
     `childNodeProperty` and sub-properties of this property when defined.
     */
    private var childNodeProperties = [URI]()
    
    /**
     All resources that are nodes in the hierarchy.
     */
    public private(set) var nodes = [Resource]()
    
    /**
     The root nodes in the hierarchy, i.e. the nodes that have no parent node.
     */
    public private(set) var rootNodes = [Resource]()
    
    /**
     The child nodes for each node. The key in this dictionary is the string value of the node resource.
     */
    private var childNodes = [String : [Resource]]()
    
    /**
     The parent nodes for each node. The key in this dictionary is the string value of the node resource.
     */
    private var parentNodes = [String : [Resource]]()
    
    /**
     True when a possible node needs to be of one of the specified node types, or false when an existing parent or child relation
     is sufficient for a resource to be defined as a node.
     */
    public let requiresNodeType : Bool
    
    /**
     Creates a new hierarchy index for the specified `indexedGraph`.
     
     During indexing the `HierarchyIndex` looks for statements with a predicate `rdf:type` and as object one of the specified `hierarchyNodeType`s.
     For instance, if you want to create an OWL class hierarchy, you should use `OWL.Class` and `RDFS.Class` as `hierarchyNodeType`.
     When the `hierarchyNodeType` array is empty, nodes can be of any type.
     
     The `parentNodeProperty` and `childNodeProperty` are used to specify the parent and child relations in the RDF graph. At least one of these
     two parameters should not be `nil`.
     For instance, if you want to create an OWL class hierarchy, you should use `RDFS.subClassOf` as the parent node property. No child node 
     property is used as OWL/RDFS do not define a inverse property for `RDFS.subClassOf`.
     
     Use the function`index(statement: Statement)` to index the contents of this graph.
     
     - parameter identifier: The unique identifier for this index.
     - parameter hierarchyNodeType: The types (`rdf:type`) of resources that can be a node in the hierarchy. If the array is empty
     any resource can be a node.
     - parameter parentNodeProperty: The parent property that links a node to a parent node.
     - parameter childNodeProperty: The child property that links a node to a child node.
     - parameter requiresNodeType: Set to true when a possible node needs to be of one of the specified node types, or false when an existing parent or child relation
     is sufficient for a resource to be defined as a node.
     - parameter indexedGraph: The graph that is to be indexed.
     */
    public init(identifier: String, hierarchyNodeType : [Resource], parentNodeProperty : URI?, childNodeProperty : URI?, requiresNodeType : Bool, indexedGraph : IndexedGraph){
        assert(!(parentNodeProperty == nil && childNodeProperty == nil), "At least one of 'parentNodeProperty' or 'childNodeProperty' should not be nil when initialising a Hierarchy Index.")
        self.hierarchyNodeType = hierarchyNodeType
        self.parentNodeProperty = parentNodeProperty
        self.childNodeProperty = childNodeProperty
        self.requiresNodeType = requiresNodeType
        super.init(identifier: identifier,indexedGraph: indexedGraph)
    }
    
    
    /**
     Creates a new hierarchy index for the specified `indexedGraph`.
     
     During indexing the `HierarchyIndex` looks for statements with a predicate `rdf:type` and as object one of the specified `hierarchyNodeType`s.
     For instance, if you want to create an OWL class hierarchy, you should use `OWL.Class` and `RDFS.Class` as `hierarchyNodeType`.
     When the `hierarchyNodeType` array is empty, nodes can be of any type.
     
     The `parentNodeProperty` and `childNodeProperty` are used to specify the parent and child relations in the RDF graph. At least one of these
     two parameters should not be `nil`.
     For instance, if you want to create an OWL class hierarchy, you should use `RDFS.subClassOf` as the parent node property. No child node
     property is used as OWL/RDFS do not define a inverse property for `RDFS.subClassOf`.
     
     Use the function`index(statement: Statement)` to index the contents of this graph.
     
     - parameter identifier: The unique identifier for this index.
     - parameter hierarchyNodeType: The types (`rdf:type`) of resources that can be a node in the hierarchy. If the array is empty
     any resource can be a node.
     - parameter parentNodeProperty: The parent property that links a node to a parent node.
     - parameter childNodeProperty: The child property that links a node to a child node.
     - parameter indexedGraph: The graph that is to be indexed.
     */
    public convenience init(identifier: String, hierarchyNodeType : [Resource], parentNodeProperty : URI?, childNodeProperty : URI?, indexedGraph : IndexedGraph){
        self.init(identifier: identifier, hierarchyNodeType: hierarchyNodeType, parentNodeProperty: parentNodeProperty, childNodeProperty: childNodeProperty, requiresNodeType: true, indexedGraph: indexedGraph)
    }
    
    /**
     Indexes `Graph` according to the indexing properties set for this `Index`.
     */
    public override func index() {
        // Delete the current index
        rootNodes.removeAll()
        hierarchyNodeTypes.removeAll()
        childNodeProperties.removeAll()
        parentNodeProperties.removeAll()
        nodes.removeAll()
        childNodes.removeAll()
        parentNodes.removeAll()
        
        for type in hierarchyNodeType { // Finds subclasses of the hierarchy node types
            hierarchyNodeTypes.append(type)
            hierarchyNodeTypes.appendContentsOf(self.subClassesOf(type))
        }
        if childNodeProperty != nil { // Finds sub-properties of the child node property
            childNodeProperties = self.subPropertiesOf(childNodeProperty!)
            childNodeProperties.append(childNodeProperty!)
        }
        if parentNodeProperty != nil { // Finds sub-properties of the parent node property
            parentNodeProperties = self.subPropertiesOf(parentNodeProperty!)
            parentNodeProperties.append(parentNodeProperty!)
        }
        
        for type in hierarchyNodeTypes { // Finds all resources that have a type that is in the list of hierarchy types.
            let subGraph = indexedGraph.subGraph(nil, predicate: RDF.type, object: type)
            for var index = 0; index < subGraph.count; index++ {
                let subject = subGraph[index].subject
                if !nodes.contains({$0 == subject}) {
                    nodes.append(subject)
                }
            }
        }
        
        let requireNodeType = hierarchyNodeTypes.count > 0 && requiresNodeType // if the list of hierarchy node types is empty, all resources may be a node when they have one of the parent or child properties.
        
        for childProp in childNodeProperties { // Find all statements that use the specified child property.
            let subGraph = indexedGraph.subGraph(nil, predicate: childProp, object: nil)
            for var index = 0; index < subGraph.count; index++ {
                let parent = subGraph[index].subject
                let object = subGraph[index].object
                if (object as? Resource) != nil {
                    let child = object as! Resource
                    if !requireNodeType && !nodes.contains({$0 == child}) { // If the node type is not required, any resource that uses the child property can be a node
                        nodes.append(child)
                    }
                    if !requireNodeType && !nodes.contains({$0 == parent}) { // If the node type is not required, any resource that uses the child property can be a node
                        nodes.append(parent)
                    }
                    if !requireNodeType || // If the node type is not required, any resource that uses the child property can be a node and the child and parent relations should be added to the hierarchy
                        (nodes.contains({$0 == parent}) && nodes.contains({$0 == child})) { // If the node type is required, check if both child and parent are of the required type (and are therefore nodes).
                        self.addChildNode(parent, child: child)
                        self.addParentNode(parent, child: child)
                    }
                }
            }
        }
        
        for parentProp in parentNodeProperties { // Find all statements that use the specified parent property.
            let subGraph = indexedGraph.subGraph(nil, predicate: parentProp, object: nil)
            for var index = 0; index < subGraph.count; index++ {
                let child = subGraph[index].subject
                let object = subGraph[index].object
                if (object as? Resource) != nil {
                    let parent = object as! Resource
                    if !requireNodeType && !nodes.contains({$0 == child}) { // If the node type is not required, any resource that uses the parent property can be a node
                        nodes.append(child)
                    }
                    if !requireNodeType && !nodes.contains({$0 == parent}) { // If the node type is not required, any resource that uses the parent property can be a node
                        nodes.append(parent)
                    }
                    if !requireNodeType ||  // If the node type is not required, any resource that uses the parent property can be a node and the child and parent relations should be added to the hierarchy
                        (nodes.contains({$0 == parent}) && nodes.contains({$0 == child})) { // If the node type is required, check if both child and parent are of the required type (and are therefore nodes).
                        self.addChildNode(parent, child: child)
                        self.addParentNode(parent, child: child)
                    }
                }
            }
        }
        
        // Find root nodes, i.e. nodes that have no parents.
        for node in nodes {
            let parents = parentNodes[node.stringValue]
            if parents == nil || parents?.count <= 0 {
                rootNodes.append(node)
            }
        }
        
        // sorting
        rootNodes = rootNodes.sort({$0.stringValue < $1.stringValue})
        for (key,list) in parentNodes {
            let sorted = list.sort({$0.stringValue < $1.stringValue})
            parentNodes[key] = sorted
        }
        for (key,list) in childNodes {
            let sorted = list.sort({$0.stringValue < $1.stringValue})
            childNodes[key] = sorted
        }
    }
    
    /**
     Adds a child node for a specific parent node.
     
     - parameter parent: The parent node.
     - parameter child: The child node.
     */
    private func addChildNode(parent : Resource, child : Resource){
        let parentstr = parent.stringValue
        var cnodes = childNodes[parentstr]
        if cnodes == nil {
            cnodes = [Resource]()
        }
        if !cnodes!.contains({$0 == child}){
            cnodes!.append(child)
        }
        childNodes[parentstr] = cnodes
    }
    
    /**
     Adds a parent node for a specific child node.
     
     - parameter parent: The parent node.
     - parameter child: The child node.
     */
    private func addParentNode(parent : Resource, child : Resource){
        let childstr = child.stringValue
        var cnodes = parentNodes[childstr]
        if cnodes == nil {
            cnodes = [Resource]()
        }
        if !cnodes!.contains({$0 == parent}){
            cnodes!.append(parent)
        }
        parentNodes[childstr] = cnodes
    }
    
    /**
     Returns all subclasses of the specified class resource. This function is recursive.
     
     - parameter classResource: The class resource whose subclasses need to be found.
     - returns: The list of subclasses.
     */
    private func subClassesOf(classResource: Resource) -> [Resource] {
        let subGraph = indexedGraph.subGraph(nil, predicate: RDFS.subClassOf, object: classResource)
        var subclasses = [Resource]()
        for var index = 0; index < subGraph.count; index++ {
            subclasses.append(subGraph[index].subject)
            subclasses.appendContentsOf(self.subClassesOf(subGraph[index].subject))
        }
        return subclasses
    }
    
    /**
     Returns all sub-properties of the specified property resource. This function is recursive.
     
     - parameter propertyResource: The property resource whose sub-properties need to be found.
     - returns: The list of sub-properties.
     */
    private func subPropertiesOf(propertyResource: URI) -> [URI] {
        let subGraph = indexedGraph.subGraph(nil, predicate: RDFS.subPropertyOf, object: propertyResource)
        var subproperties = [URI]()
        for var index = 0; index < subGraph.count; index++ {
            let subject = subGraph[index].subject
            if (subject as? URI) != nil {
                let subjectURI = subject as! URI
                subproperties.append(subjectURI)
                subproperties.appendContentsOf(self.subPropertiesOf(subjectURI))
            }
        }
        return subproperties
    }
    
    /**
     Returns the child nodes of the specified node in the hierarchy. The return value may be `nil` if the
     specified `node` resource is not a node in the hierarchy.
     
     - parameter node: The node for which the child nodes are requested.
     - returns: The child nodes of the specified node.
     */
    public func childNodes(node: Resource) -> [Resource]? {
        return childNodes[node.stringValue]
    }
    
    /**
     Returns the child nodes of the specified node in the hierarchy. The return value may be `nil` if the
     specified `node` resource is not a node in the hierarchy.
     
     - parameter node: The node for which the child nodes are requested.
     - returns: The child nodes of the specified node.
     */
    public func parentNodes(node: Resource) -> [Resource]? {
        return parentNodes[node.stringValue]
    }
    
}