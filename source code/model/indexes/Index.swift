//
//  Index.swift
//  
//
//  Created by Don Willems on 03/02/16.
//
//

import Foundation

/**
 Instances of the `Index` class are used to create specific indexes on `Graph` for searching through the 
 statements contained in a graph. This class is used as the superclass for specific types of indexes.
 Possible indexes can for instance enable search on strings or numbers in labels, or index the different
 `owl:Class` instances in the triple store to provide a hierarchical view on an ontology.
 */
public class Index {
    
    /**
     The `Graph` that is indexed using this `Index`.
     */
    public let indexedGraph : IndexedGraph
    
    /**
     This property is true when the index is in an inconsistent state and needs to be (re)indexed.
     */
    public var needsIndexing = true
    
    
    /**
     Creates a new index for the specified `indexedGraph`.
     Use the function`index(statement: Statement)` to index the contents of this graph.
     
     - parameter identifier: The unique identifier for this index.
     - parameter indexedGraph: The graph that is to be indexed.
     */
    public init(identifier: String, indexedGraph : IndexedGraph){
        self.indexedGraph = indexedGraph
        self.indexedGraph.addIndex(identifier, index: self)
    }
    
    /**
     Indexes `Graph` according to the indexing properties set for this `Index`.
     */
    public func index() {
        
    }
    
    /**
     Indexes the specified `Statement` according to the indexing properties set for this `Index`.
     
     - parameter statement: The statement to be indexed.
     */
    public func index(statement : Statement) {
        needsIndexing = true
    }
    
    /**
     Deletes the specified statement from the index.
     
     - parameter statement: The statement to be removed from the index.
     */
    public func deleteStatement(statement : Statement){
        needsIndexing = true
    }
    
    /**
     Resets the index. The graph needs to be indexed again for the index to be consistent again.
     */
    public func reset() {
        needsIndexing = true
    }
}
