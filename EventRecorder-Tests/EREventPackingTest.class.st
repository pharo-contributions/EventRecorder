"
A GTEventPackingTest is a test class for testing the behavior of GTEventPacking
"
Class {
	#name : #EREventPackingTest,
	#superclass : #TestCase,
	#instVars : [
		'packing',
		'event1',
		'event2',
		'collector',
		'bundle',
		'announcement',
		'unpackedData',
		'storage',
		'file'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #testing }
EREventPackingTest class >> isAbstract [
	^ self name = EREventPackingTest name
]

{ #category : #asserting }
EREventPackingTest >> assertBundle [
	bundle := packing pack: collector.
	self assert: bundle url equals: collector url.
	self assert: bundle data isLiteral.
	self assert: bundle category equals: collector category.
]

{ #category : #asserting }
EREventPackingTest >> assertUnpackedData [
	unpackedData := announcement unpackedData.
	self assert: unpackedData size equals: 2.
	self assert: unpackedData first equals: event1.
	self assert: unpackedData second equals: event2
]

{ #category : #accessing }
EREventPackingTest >> packingClass [
	^ self subclassResponsibility
]

{ #category : #running }
EREventPackingTest >> setUp [
	super setUp.
	event1 := ERDummyEvent new data: 'string'.
	event2 := ERDummyEvent new data: 42.
	collector := EREventCollector new.
	collector add: event1; add: event2.
	collector category: #category1.
	packing := self packingClass new.
	storage := FileSystem memory.
	file := storage workingDirectory / 'data'.

]

{ #category : #'tests-packing' }
EREventPackingTest >> testNewAnnouncementFor [
	announcement := packing newAnnouncementFor: collector.
	self assert: announcement serializedBy equals: packing class name.
	self assert: announcement eventRecorderVersion equals: packing version.
	self assert: announcement category equals: collector category.
]

{ #category : #'tests-packing' }
EREventPackingTest >> testNewAnnouncementFor2 [
	collector updateAnnouncementBlock: [ :anAnnouncement | 
		anAnnouncement at: #testNewAnnouncementFor2 put: 42 ].
	announcement := packing newAnnouncementFor: collector.
	self assert: announcement serializedBy equals: packing class name.
	self assert: announcement eventRecorderVersion equals: packing version.
	self assert: (announcement at: #testNewAnnouncementFor2) equals: 42.
]

{ #category : #'tests-packing' }
EREventPackingTest >> testPack [
	self assertBundle.
	announcement := packing unpack: bundle data.
	self assertUnpackedData
]

{ #category : #'tests-packing' }
EREventPackingTest >> testUnpackBinaryBinaryStream [
	self assertBundle.
	file binaryWriteStreamDo: [ :aStream | 
		aStream nextPutAll: bundle data ].
	file binaryReadStreamDo: [ :aStream | 
		announcement := packing unpack: aStream contents ].
	self assertUnpackedData.

]

{ #category : #'tests-packing' }
EREventPackingTest >> testUnpackBinaryUnspecifiedStream [
	self assertBundle.
	file binaryWriteStreamDo: [ :aStream | 
		aStream nextPutAll: bundle data ].
	announcement := packing unpack: file contents.
	self assertUnpackedData.
]

{ #category : #'tests-packing' }
EREventPackingTest >> testUnpackUnspecifiedBinaryStream [
	self assertBundle.
	file binaryWriteStreamDo: [ :aStream | 
		aStream nextPutAll: bundle data ].
	file binaryReadStreamDo: [ :aStream | 
		announcement := packing unpack: aStream contents ].
	self assertUnpackedData.

]

{ #category : #'tests-packing' }
EREventPackingTest >> testUnpackUnspecifiedUnspecifiedStream [
	self assertBundle.
	file binaryWriteStreamDo: [ :aStream | 
		aStream nextPutAll: bundle data ].
	announcement := packing unpack: file contents.
	self assertUnpackedData.
]
