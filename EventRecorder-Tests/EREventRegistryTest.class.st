"
A GTEventRegistryTest is a test class for testing the behavior of GTEventRegistry
"
Class {
	#name : #EREventRegistryTest,
	#superclass : #TestCase,
	#instVars : [
		'registry'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #running }
EREventRegistryTest >> setUp [
	super setUp.
	registry := EREventRegistry new.
]

{ #category : #'as yet unclassified' }
EREventRegistryTest >> testIsLiberated [
	"By default it should answer yes."
	self assert: registry isLiberated
]

{ #category : #'as yet unclassified' }
EREventRegistryTest >> testIsLiberated2 [
	"By default it should answer yes."
	registry object: self.
	self deny: registry isLiberated.
]

{ #category : #'as yet unclassified' }
EREventRegistryTest >> testIsLiberated3 [
	"By default it should answer yes."
	registry object: self.
	self deny: registry isLiberated.
	registry object: nil.
	self assert: registry isLiberated.
]
