"
A GTEventUnpackingTest is a test class for testing the behavior of GTEventUnpacking
"
Class {
	#name : #EREventUnpackingTest,
	#superclass : #TestCase,
	#instVars : [
		'unpacking',
		'collector',
		'unpackedData',
		'initialData',
		'bundle'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #running }
EREventUnpackingTest >> setUp [
	super setUp.
	initialData := #('GT' 'Team' 2015).
	collector := EREventCollector new.
	initialData do: [ :each | collector add: each ].
	unpacking := EREventUnpacking default.
]

{ #category : #tests }
EREventUnpackingTest >> testUnpack [
	bundle := EREventPacking default pack: collector.
	unpackedData := unpacking unpack: bundle data.
	self assert: unpackedData class equals: EREventAnnouncement.
	self assert: unpackedData unpackedData asArray equals: initialData.
]

{ #category : #tests }
EREventUnpackingTest >> testUnpack2 [
	self should: [ unpacking unpack: initialData ] raise: EREventUnpackingError
]

{ #category : #tests }
EREventUnpackingTest >> testUnpack3 [
	bundle := EREventPacking default pack: collector.
	unpacking := EREventUnpacking new.
	self should: [ unpacking unpack: bundle data ] raise: EREventInitializationError
]

{ #category : #tests }
EREventUnpackingTest >> testUnpack4 [
	bundle := EREventPacking ston pack: collector.
	unpacking := EREventUnpacking new.
	unpacking addPacking: EREventPacking fuel.
	self should: [ unpacking unpack: bundle data ] raise: EREventUnpackingError 
]

{ #category : #tests }
EREventUnpackingTest >> testUnpack5 [
	bundle := EREventPacking fuel pack: collector.
	unpacking := EREventUnpacking new.
	unpacking addPacking: EREventPacking ston.
	self should: [ unpacking unpack: bundle data ] raise: EREventUnpackingError 
]

{ #category : #tests }
EREventUnpackingTest >> testUnpackFuel [
	bundle := EREventPacking fuel pack: collector.
	unpackedData := unpacking unpack: bundle data.
	self assert: unpackedData class equals: EREventAnnouncement.
	self assert: unpackedData unpackedData asArray equals: initialData.
]

{ #category : #tests }
EREventUnpackingTest >> testUnpackSton [
	bundle := EREventPacking ston pack: collector.
	unpackedData := unpacking unpack: bundle data.
	self assert: unpackedData class equals: EREventAnnouncement.
	self assert: unpackedData unpackedData asArray equals: initialData.
]
