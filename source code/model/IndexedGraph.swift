//
//  IndexedGraph.swift
//  
//
//  Created by Don Willems on 02/02/16.
//
//

import Foundation

public class IndexedGraph : Graph {
    
    
    
    // MARK: Access to resources in the `Graph`
    
    /**
    The resources used in this `Graph` excluding properties (predicates).
    */
    public private(set) var resources = [Resource]()
    
    /**
     The different properties used in the `Graph`.
     */
    public private(set) var properties = [URI]()
    
    
    
    // MARK: Indexes
    
    private var subjectIndex = [String : [Statement]]()
    
    private var predicateIndex = [String : [Statement]]()
    
    // Only for objects that are a resource.
    private var objectIndex = [String : [Statement]]()
    
    private var namedGraphIndex = [String : [Statement]]()
    
    private var unindexed = [Statement]()
    
    public private(set) var needsIndexing : Bool = false
    
    
    /**
     Adds the specfied statement to the `Graph`. If the graph is a named graph, the URI identifier of
     this named graph is added as named graph to the statement.
     
     - parameter statement: The statement to be added to the graph.
     */
    public override func add(statement : Statement){
        super.add(statement)
        needsIndexing = true
        unindexed.append(statement)
    }
    
    /**
     Deletes statements with the specified subject, predicate, and object from the `Graph`.
     If one of the optional parameters (e.g. subject) is `nil`, all values for that parameter in the
     statement will match. If, for instance, this function is called with subject and object `nil`, and
     `RDFS.label` as predicate, then all statements that have `RDF.label` as predicate will be deleted
     from the graph, regardless the values for the subject or object in the statement. If all three parameters
     are `nil`, all statements will be deleted from the graph, as all statements will match with the conditions.
     
     - parameter subject: The subject of the statements to be deleted, or nill if the statement can have any
     subject value for it to be deleted.
     - parameter predicate: The predicate of the statements to be deleted, or nill if the statement can have any
     predicate value for it to be deleted.
     - parameter object: The object of the statements to be deleted, or nill if the statement can have any
     object value for it to be deleted.
     - returns: The statements being removed from the Graph.
     */
    public override func deleteStatements(subject: Resource?, predicate: Resource?, object: Value?) -> [Statement] {
        let deletedStatements = super.deleteStatements(subject, predicate: predicate, object: object)
        for statement in deletedStatements {
            self.deleteStatementFromIndex(statement)
        }
        return deletedStatements
    }
    
    /**
     Indexes all statements to the specified indexes. This action needs to be performed when statements were
     added from the Graph.
     */
    public func index() {
        for var index = 0; index < unindexed.count; index++ {
            let statement = unindexed[index]
            extractDistinctResourcesAndProperties(statement)
            indexStatement(statement)
        }
        needsIndexing = false
    }
    
    /**
     Reindexes all statements to the specified indexes.
     */
    public func reindex() {
        resources.removeAll()
        properties.removeAll()
        unindexed = statements
        index()
    }
    
    /**
     Checks the statement for resources (in subject or object) and properties that have not been defined before and
     if so puts these in the `resources` or `properties` array.
     
     - parameter statement: The statement to be checked for distinct resources or properties.
     */
    private func extractDistinctResourcesAndProperties(statement : Statement) {
        if !resources.contains({$0 == statement.subject}){
            resources.append(statement.subject)
        }
        if (statement.object as? Resource) != nil && !resources.contains({$0 == statement.object}){
            resources.append((statement.object as! Resource))
        }
        if !properties.contains({$0 == statement.predicate}){
            properties.append(statement.predicate)
        }
    }
    
    /**
     Adds a statement to the indexes. All three elements of a triple (subject, predicate, and object)
     are indexed.
     
     - parameter statement: The statement to be added to the indexes.
     */
    private func indexStatement(statement : Statement){
        let subjectStr = statement.subject.stringValue
        var statementsForSubject = subjectIndex[subjectStr]
        if statementsForSubject == nil {
            statementsForSubject = [Statement]()
        }
        statementsForSubject?.append(statement)
        subjectIndex[subjectStr] = statementsForSubject
        
        let predicateStr = statement.predicate.stringValue
        var statementsForPredicate = predicateIndex[predicateStr]
        if statementsForPredicate == nil {
            statementsForPredicate = [Statement]()
        }
        statementsForPredicate?.append(statement)
        predicateIndex[predicateStr] = statementsForPredicate
        
        if (statement.object as? Resource) != nil {
            let objectStr = statement.object.stringValue
            var statementsForObject = objectIndex[objectStr]
            if statementsForObject == nil {
                statementsForObject = [Statement]()
            }
            statementsForObject?.append(statement)
            objectIndex[objectStr] = statementsForObject
        }
        
        let namedgraphs = statement.namedGraphs
        for namedGraph in namedgraphs {
            let namedGraphStr = namedGraph.stringValue
            var statementsForNamedGraph = namedGraphIndex[namedGraphStr]
            if statementsForNamedGraph == nil {
                statementsForNamedGraph = [Statement]()
            }
            statementsForNamedGraph?.append(statement)
            namedGraphIndex[namedGraphStr] = statementsForNamedGraph
        }
    }
    
    /**
     Deletes a statement from the indexes.
     
     - parameter statement: The statement to be deleted from the indexes.
     */
    private func deleteStatementFromIndex(statement : Statement) {
        let subjectStr = statement.subject.stringValue
        var statementsForSubject = subjectIndex[subjectStr]
        if statementsForSubject != nil {
            let ninded = statementsForSubject?.indexOf(statement)
            if ninded != nil {
                statementsForSubject?.removeAtIndex(ninded!)
                subjectIndex[subjectStr] = statementsForSubject
            }
        }
        let predicateStr = statement.predicate.stringValue
        var statementsForPredicate = predicateIndex[predicateStr]
        if statementsForPredicate != nil {
            let ninded = statementsForPredicate?.indexOf(statement)
            if ninded != nil {
                statementsForPredicate?.removeAtIndex(ninded!)
                predicateIndex[predicateStr] = statementsForPredicate
            }
        }
        if (statement.object as? Resource) != nil {
            let objectStr = statement.object.stringValue
            var statementsForObject = objectIndex[objectStr]
            if statementsForObject != nil {
                let ninded = statementsForObject?.indexOf(statement)
                if ninded != nil {
                    statementsForObject?.removeAtIndex(ninded!)
                    objectIndex[objectStr] = statementsForObject
                }
            }
        }
        for namedGraph in namedGraphs {
            let namedGraphStr = namedGraph.stringValue
            var statementsForNamedGraph = namedGraphIndex[namedGraphStr]
            if statementsForNamedGraph != nil {
                let ninded = statementsForNamedGraph?.indexOf(statement)
                if ninded != nil {
                    statementsForNamedGraph?.removeAtIndex(ninded!)
                    namedGraphIndex[namedGraphStr] = statementsForNamedGraph
                }
            }
            statementsForNamedGraph?.append(statement)
        }
    }
    
    /**
     Returns a subgraph containing all statements that match the conditions specified by the parameters.
     Statements are added to the subgraph when the subject of the statement matches the subject parameter,
     when the predicate of the statement matches the predicate parameter, when the object of the statement
     matches the object parameter, and if one of the named graphs to which the statement belongs is the
     same as one of the named graphs in the parameter.
     
     All parameters are optional. If a parameter is `nil` (e.g. the subject), then all statements will match
     for that parameter. The other parameters still need to match of course.
     
     For instance, when calling the function `myGraph.subGraph(subject: nil, predicate: RDFS.label, object: nil)`,
     will returns a sub graph with all statements that have a `RDFS.label` as a predicate, regardless of the
     subject or object values.
     
     If all parameters are `nil`, this function will return a sub graph containing all statements in the
     reciever.
     
     - parameter subject: The subject of the statements to be added to the subgraph, or nill if all subjects match.
     - parameter predicate: The predicate of the statements to be added to the subgraph, or nill if all predicates match.
     - parameter object: The object of the statements to be added to the subgraph, or nill if all objects match.
     - parameter namedGraph: The set of named graph URIs that is matched with the named graphs of each statement.
     - returns: A subgraph containing all statements that match the conditions specified by the parameters.
     */
    public override func subGraph(subject: Resource?, predicate: Resource?, object: Value?, namedGraph: Resource...) -> Graph {
        let graph = Graph()
        self.copyStatementsToGraph(graph)
        var selectedStatements = statements
        if subject != nil {
            let statementsForSubject = subjectIndex[subject!.stringValue]
            if statementsForSubject == nil {
                return graph
            }
            if predicate == nil && object == nil && namedGraph.count <= 0 {
                graph.add(statementsForSubject!)
                return graph
            }
            selectedStatements = statementsForSubject!
        }
        if predicate != nil {
            let statementsForPredicate = predicateIndex[predicate!.stringValue]
            if statementsForPredicate == nil {
                return graph
            }
            if subject == nil && object == nil && namedGraph.count <= 0 {
                graph.add(statementsForPredicate!)
                return graph
            }
            if statementsForPredicate!.count < selectedStatements.count {
                selectedStatements = statementsForPredicate!
            }
        }
        if object != nil && (object as? Resource) != nil {
            let statementsForObject = objectIndex[object!.stringValue]
            if statementsForObject == nil {
                return graph
            }
            if subject == nil && predicate == nil && namedGraph.count <= 0 {
                graph.add(statementsForObject!)
                return graph
            }
            if statementsForObject!.count < selectedStatements.count {
                selectedStatements = statementsForObject!
            }
        }
        
        if namedGraph.count > 0 {
            var statsng = [Statement]()
            for ng in namedGraph {
                let statementsForNamedGraph = namedGraphIndex[ng.stringValue]
                if statementsForNamedGraph != nil {
                    statsng.appendContentsOf(statementsForNamedGraph!)
                }
            }
            if subject == nil && predicate == nil && object == nil {
                graph.add(statsng)
                return graph
            }
            if statsng.count < selectedStatements.count {
                selectedStatements = statsng
            }
        }
        
        for statement in selectedStatements {
            if (subject == nil || subject! == statement.subject) && (predicate == nil || predicate! == statement.predicate) && (object == nil || object! == statement.object) {
                if namedGraph.count > 0 {
                    for ng in namedGraph {
                        if statement.inNamedGraph(ng) {
                            graph.add(statement)
                            break
                        }
                    }
                } else {
                    graph.add(statement)
                }
            }
        }
        let prefixes = self.namespacePrefixes
        for prefix in prefixes {
            graph.addNamespace(prefix, namespaceURI: namespaceForPrefix(prefix)!)
        }
        return graph
    }
    
    /**
     Copies the namespaces in the reciever graph to the specified graph.
     
     - parameter graph: The graph to which the namespaces have to be added.
     */
    private func copyStatementsToGraph(graph : Graph){
        for prefix in namespaces.keys {
            graph.addNamespace(prefix, namespaceURI: self.namespaceForPrefix(prefix)!)
        }
    }
    
}
