"
I am weak holder of an object that uses GTEventCollector. If the object disappears from object memory (or #liberate message is sent), GTEventCollector can be removed from a GTEventRecorder object.

For the Collaborators Part: GTEventCollector

Public API and Key Messages

- object: 
- liberate
- isLiberated

Internal Representation and Key Implementation Points.

    Instance Variables
	weakHolder:		<Object>

"
Class {
	#name : #EREventRegistry,
	#superclass : #Object,
	#instVars : [
		'weakHolder'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #initialization }
EREventRegistry >> initialize [
	super initialize.
	weakHolder := WeakArray new: 1.
]

{ #category : #testing }
EREventRegistry >> isLiberated [
	^ (weakHolder at: 1) isNil
]

{ #category : #actions }
EREventRegistry >> liberate [
	self object: nil.
]

{ #category : #accessing }
EREventRegistry >> object: anObject [ 
	weakHolder at: 1 put: anObject.
]

{ #category : #printing }
EREventRegistry >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (self isLiberated ifTrue: [ 'liberated' ] ifFalse: [ 'used' ]);
		nextPut: $)
]
