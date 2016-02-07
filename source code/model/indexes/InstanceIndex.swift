//
//  InstanceIndex.swift
//  
//
//  Created by Don Willems on 04/02/16.
//
//

import Foundation

public class InstanceIndex : Index {
    
    private var labelProperties = [RDFS.label,SKOS.prefLabel,SKOS.altLabel]
    private var resourceToLabelIndex = [String : [Literal]]()
    private var resourceToTypeIndex = [String : [Resource]]()
    private var labelsAndNamesIndex = [(label: String, resource: Resource)]()
    
    public func types(resource : Resource) -> [Resource] {
        let types = resourceToTypeIndex[resource.stringValue]
        if types != nil {
            return types!
        }
        return [Resource]()
    }
    
    /**
     Indexes `Graph` according to the indexing properties set for this `Index`.
     */
    public override func index() {
        if needsIndexing {
            for statement in indexedGraph.statements {
                self.index(statement)
            }
        }
    }
    
    /**
     Indexes the specified `Statement` according to the indexing properties set for this `Index`.
     
     - parameter statement: The statement to be indexed.
     */
    public override func index(statement : Statement) {
        let subject = statement.subject
        let predicate = statement.predicate
        let object = statement.object
        if predicate == RDF.type { // type
            if (object as? Resource) != nil {
                let type = (object as! Resource)
                var types = resourceToTypeIndex[subject.stringValue]
                if types == nil {
                    types = [Resource]()
                }
                if !types!.contains({$0 == type}) {
                    types!.append(type)
                }
                resourceToTypeIndex[subject.stringValue] = types!
            }
        } else if labelProperties.contains({$0 == predicate}) { // label
            if (object as? Literal) != nil {
                var labels = resourceToLabelIndex[subject.stringValue]
                if labels == nil {
                    labels = [Literal]()
                }
                if labels!.contains({$0 == object}) {
                    labels!.append(object as! Literal)
                }
                resourceToLabelIndex[subject.stringValue] = labels
                self.addResourceWithLabelToIndex(subject, label: (object as! Literal))
            }
        }
        self.addResourceWithoutLabelToIndex(subject)
        self.addResourceWithoutLabelToIndex(predicate)
        if (object as? Resource) != nil {
            self.addResourceWithoutLabelToIndex((object as! Resource))
        }
    }
    
    private func addResourceWithLabelToIndex(resource: Resource, label : Literal){
        self.addResourceWithStringLabelToIndex(resource, label: label.stringValue)
        let labelAr = label.stringValue.characters.split{$0 == " "}.map(String.init)
        for var index = 1; index < labelAr.count; index++ {
            var str = ""
            for var i = index; i < labelAr.count; i++ {
                if str.characters.count > 0 {
                    str += " "
                }
                str += labelAr[i]
            }
            self.addResourceWithStringLabelToIndex(resource, label: str)
        }
    }
    
    private func addResourceWithoutLabelToIndex(resource: Resource){
        self.addResourceWithStringLabelToIndex(resource, label: resource.stringValue)
        if (resource as? URI) != nil {
            let localName = (resource as! URI).localName
            self.addResourceWithStringLabelToIndex(resource, label: localName)
            let qname = indexedGraph.qualifiedName(resource as! URI)
            if qname != nil {
                self.addResourceWithStringLabelToIndex(resource, label: qname!)
            }
        }
    }
    
    private func addResourceWithStringLabelToIndex(resource: Resource, label : String){
        let index = self.indexForStringLabel(label, min: 0, max: labelsAndNamesIndex.count)
        let tuple = (label: label, resource: resource)
        let tupleExists = self.labelTupleExists(tuple, index: index)
        if !tupleExists {
            labelsAndNamesIndex.insert(tuple, atIndex: index)
        }
    }
    
    private func labelTupleExists(tuple : (label: String,resource: Resource), index : Int) -> Bool {
        var exists = false
        var i = index
        while !exists && i < labelsAndNamesIndex.count {
            let testTuple : (label: String,resource: Resource) = labelsAndNamesIndex[i]
            if testTuple.label == tuple.label {
                if testTuple.resource == tuple.resource {
                    exists = true
                }
            } else {
                break
            }
            i++
        }
        return exists
    }
    
    private func indexForStringLabel(label : String, min : Int, max : Int) -> Int {
        if min == max {
            return min
        }
        let pos = (max-min)/2+min
        let plabel = labelsAndNamesIndex[pos].label.lowercaseString
        let lclabel = label.lowercaseString
        if plabel == lclabel {
            return pos
        }
        if plabel > lclabel {
            return self.indexForStringLabel(label,min: min, max: pos)
        }
        return self.indexForStringLabel(label,min: pos+1, max: max)
    }
    
    public func searchOnLabel(query : String) -> [Resource] {
        let lcquery = query.lowercaseString
        let startIndex = indexForStringLabel(query, min: 0, max: labelsAndNamesIndex.count)
        var index = startIndex
        var resources = [Resource]()
        while index < labelsAndNamesIndex.count {
            let tuple : (label :String, resource : Resource) = labelsAndNamesIndex[index]
            if tuple.label.lowercaseString.hasPrefix(lcquery) {
                resources.append(tuple.resource)
                index++
            } else {
                break
            }
        }
        return resources
    }
    
    /**
     Deletes the specified statement from the index.
     
     - parameter statement: The statement to be removed from the index.
     */
    public override func deleteStatement(statement : Statement){
        needsIndexing = true
    }
    
    /**
     Resets the index. The graph needs to be indexed again for the index to be consistent again.
     */
    public override func reset() {
        super.reset()
    }
}