//
//  ClassTypeEditor.swift
//  Ontologist
//
//  Created by Don Willems on 05/02/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa
import SwiftRDFOSX
import OntologistPlugins


public class ClassTypeEditor : Plugin, TypeEditorPlugin, TypeIconsPlugin {
    
    private var classIcon : NSImage?
    private var classResourceIcon : NSImage?
    private var dataTypePropertyIcon : NSImage?
    private var annotationPropertyIcon : NSImage?
    private var objectPropertyIcon : NSImage?
    private var symmetricPropertyIcon : NSImage?
    private var transitivePropertyIcon : NSImage?
    private var functionalPropertyIcon : NSImage?
    private var inverseFunctionalPropertyIcon : NSImage?
    private var listIcon : NSImage?
    private var ontologyIcon : NSImage?
    private var ontologyResourceIcon : NSImage?
    
    public required init() {
        super.init()
        let instanceIconPath = self.pluginBundle.pathForImageResource("class")
        if instanceIconPath != nil {
            classIcon = NSImage(contentsOfFile: instanceIconPath!)
        }
        let resourceIconPath = self.pluginBundle.pathForImageResource("class-resource")
        if resourceIconPath != nil {
            classResourceIcon = NSImage(contentsOfFile: resourceIconPath!)
        }
        let dataTypePropertyIconPath = self.pluginBundle.pathForImageResource("dataTypeProperty")
        if dataTypePropertyIconPath != nil {
            dataTypePropertyIcon = NSImage(contentsOfFile: dataTypePropertyIconPath!)
        }
        let annotationPropertyIconPath = self.pluginBundle.pathForImageResource("annotationProperty")
        if annotationPropertyIconPath != nil {
            annotationPropertyIcon = NSImage(contentsOfFile: annotationPropertyIconPath!)
        }
        let objectPorpertyIconPath = self.pluginBundle.pathForImageResource("objectProperty")
        if objectPorpertyIconPath != nil {
            objectPropertyIcon = NSImage(contentsOfFile: objectPorpertyIconPath!)
        }
        let symmetricPropertyIconPath = self.pluginBundle.pathForImageResource("symmetricProperty")
        if symmetricPropertyIconPath != nil {
            symmetricPropertyIcon = NSImage(contentsOfFile: symmetricPropertyIconPath!)
        }
        let transitivePropertyIconPath = self.pluginBundle.pathForImageResource("transitiveProperty")
        if transitivePropertyIconPath != nil {
            transitivePropertyIcon = NSImage(contentsOfFile: transitivePropertyIconPath!)
        }
        let functionalPropertyIconPath = self.pluginBundle.pathForImageResource("functionalProperty")
        if functionalPropertyIconPath != nil {
            functionalPropertyIcon = NSImage(contentsOfFile: functionalPropertyIconPath!)
        }
        let inverseFunctionalPropertyIconPath = self.pluginBundle.pathForImageResource("inverseFunctionalProperty")
        if inverseFunctionalPropertyIconPath != nil {
            inverseFunctionalPropertyIcon = NSImage(contentsOfFile: inverseFunctionalPropertyIconPath!)
        }
        let listIconPath = self.pluginBundle.pathForImageResource("list")
        if listIconPath != nil {
            listIcon = NSImage(contentsOfFile: listIconPath!)
        }
        let ontologyIconPath = self.pluginBundle.pathForImageResource("ontology")
        if ontologyIconPath != nil {
            ontologyIcon = NSImage(contentsOfFile: ontologyIconPath!)
        }
        let ontologyResourceIconPath = self.pluginBundle.pathForImageResource("ontology-resource")
        if ontologyResourceIconPath != nil {
            ontologyResourceIcon = NSImage(contentsOfFile: ontologyResourceIconPath!)
        }
    }
    
    public func iconForResource(resource: Resource) -> NSImage? {
        if resource == OWL.Class || resource == RDFS.Class {
            return classResourceIcon
        }
        if resource == OWL.DatatypeProperty {
            return dataTypePropertyIcon
        }
        if resource == OWL.AnnotationProperty {
            return annotationPropertyIcon
        }
        if resource == RDFS.label {
            return annotationPropertyIcon
        }
        if resource == OWL.ObjectProperty {
            return objectPropertyIcon
        }
        if resource == RDF.Property {
            return objectPropertyIcon
        }
        if resource == OWL.SymmetricProperty {
            return symmetricPropertyIcon
        }
        if resource == OWL.TransitiveProperty {
            return transitivePropertyIcon
        }
        if resource == OWL.FunctionalProperty {
            return functionalPropertyIcon
        }
        if resource == OWL.InverseFunctionalProperty {
            return inverseFunctionalPropertyIcon
        }
        if resource == RDF.List {
            return listIcon
        }
        if resource == OWL.Ontology {
            return ontologyResourceIcon
        }
        return nil
    }
    
    public func iconForInstance(type: Resource) -> NSImage? {
        if type == OWL.Class || type == RDFS.Class {
            return classIcon
        }
        if type == OWL.DatatypeProperty {
            return dataTypePropertyIcon
        }
        if type == OWL.AnnotationProperty {
            return annotationPropertyIcon
        }
        if type == OWL.ObjectProperty {
            return objectPropertyIcon
        }
        if type == OWL.SymmetricProperty {
            return symmetricPropertyIcon
        }
        if type == OWL.TransitiveProperty {
            return transitivePropertyIcon
        }
        if type == OWL.FunctionalProperty {
            return functionalPropertyIcon
        }
        if type == OWL.InverseFunctionalProperty {
            return inverseFunctionalPropertyIcon
        }
        if type == RDF.List {
            return listIcon
        }
        if type == OWL.Ontology {
            return ontologyIcon
        }
        return nil
    }
    
}
