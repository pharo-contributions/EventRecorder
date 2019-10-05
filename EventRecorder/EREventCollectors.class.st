"
I represent a collection of GTEventCollector objects. GTEventRecorder uses me and I am responsible for adding and removing the collectors.

Public API and Key Messages

- add:  
- remove:
 
Internal Representation and Key Implementation Points.

    Instance Variables
	collectors:		<OrderedCollection>
	mutex:		<Mutex>

"
Class {
	#name : #EREventCollectors,
	#superclass : #Object,
	#instVars : [
		'mutex',
		'collectors'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #adding }
EREventCollectors >> add: aGTEventCollector [
	^ mutex critical: [ 
		(collectors identityIncludes: aGTEventCollector)
			ifFalse: [ collectors add: aGTEventCollector ]
			ifTrue: [ aGTEventCollector ] ]
]

{ #category : #enumerating }
EREventCollectors >> do: oneArgBlock [
	mutex critical: [ collectors do: oneArgBlock ]
]

{ #category : #initialization }
EREventCollectors >> initialize [
	super initialize.
	mutex := Mutex new.
	collectors := OrderedCollection new.
]

{ #category : #accessing }
EREventCollectors >> numberOfEvents [
	^ mutex critical: [ 
		collectors 
			ifEmpty: 0
			ifNotEmpty: [ collectors sum: #size ] ]
]

{ #category : #printing }
EREventCollectors >> printOn: aStream [
	super printOn: aStream.
	aStream
		space;
		nextPut: $[;
		print: self size;
		space;
		nextPutAll: ('collector' asPluralBasedOn: self size);
		nextPutAll: ', ';
		print: self numberOfEvents;
		space;
		nextPutAll: ('event' asPluralBasedOn: self numberOfEvents);
		nextPut: $]
]

{ #category : #removing }
EREventCollectors >> remove: aGTEventCollector [ 
	^ mutex critical: [ collectors remove: aGTEventCollector ifAbsent: nil ]
]

{ #category : #removing }
EREventCollectors >> removeLiberatedCollectors [
	mutex critical: [ | liberated |
		liberated := collectors select: #isLiberated.
		collectors removeAll: liberated ]
]

{ #category : #accessing }
EREventCollectors >> size [
	^ mutex critical: [ collectors size ]
]
