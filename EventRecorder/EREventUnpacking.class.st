"
I represent an unpacking object that is able to receive serialized objects, e.g., FUEL or STON, and tries all available packing systems to unpack the serialized objects.

Others can ask me for materializing an object by sending me #unpack:. I resent the request to GTEventPacking objects and if anyone is able to materialize it, I will return the materialized object. Otherwise, I raise an error.

Collaborators Part: GTEventPacking, GTEventInitializationError, GTEventUnpackingError.

Public API and Key Messages

- unpack: aByteArray
- addPacking: aGTEventPacking
- how to create instances: #default on the class side.

Example:
	(GTEventUnpacking default
		unpack: (GTEventPacking ston 
					pack: (GTEventCollector new 
							add: 1; add: 2; add: 3; yourself)) 
			data) unpackedData
 
Internal Representation and Key Implementation Points.

    Instance Variables
	packings:		<OrderedCollection>

"
Class {
	#name : #EREventUnpacking,
	#superclass : #Object,
	#instVars : [
		'packings'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #'instance creation' }
EREventUnpacking class >> default [
	^ self new
			addPacking: EREventPacking fuel;
			addPacking: EREventPacking ston;
			yourself
]

{ #category : #adding }
EREventUnpacking >> addPacking: aGTEventPacking [ 
	^ self packings addLast: aGTEventPacking
]

{ #category : #accessing }
EREventUnpacking >> packings [
	^ packings ifNil: [ packings := OrderedCollection new ]
]

{ #category : #packing }
EREventUnpacking >> safeUnpackDirectory: aFileReference [
	"self default safeUnpackDirectory: './gt/events/' asFileReference"
	| unpackedData exceptions |
	exceptions := OrderedCollection new.
	[ unpackedData := self unpackDirectory: aFileReference ] on: EREventUnpackingError do: [ :exception |
		exceptions addLast: exception.
		exception resume ].
	^ unpackedData -> exceptions
]

{ #category : #packing }
EREventUnpacking >> unpack: aByteArray [
	| exceptions |
	exceptions := OrderedCollection new: self packings size.
	self packings do: [ :eachEventPacking |
		[ ^ eachEventPacking unpack: aByteArray ] on: Error
			do: [ :exception | exceptions addLast: exception ] ].
	exceptions
		ifEmpty: [ EREventInitializationError signal: 'Uninitialized unpacking system' ]
		ifNotEmpty: [ EREventUnpackingError 
								signal: 'Cannot unpack data' 
								data: aByteArray 
								errors: exceptions ].
	"In case of resumed exception it returns nil object."
	^ nil
]

{ #category : #packing }
EREventUnpacking >> unpackDirectory: aFileReference [
	"self default unpackDirectory: './gt/events/' asFileReference"
	^ aFileReference asFileReference allFiles 
			collect: [ :eachFile | 
				(eachFile basename = '.DS_Store') 
					ifTrue: [ nil ]
					ifFalse: [ self unpackFile: eachFile ] ]
			thenSelect: #notNil
]

{ #category : #packing }
EREventUnpacking >> unpackFile: aFileReference [
	"self default unpackFile: './gt/events/' asFileReference allFiles atRandom"
	^ [ self unpack: (aFileReference binaryReadStreamDo: [ :aStream |  aStream contents ]) ]
		on: EREventUnpackingError do: [ :anException |
			anException data: aFileReference.
			anException pass ]
]
