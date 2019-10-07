"
A GTEventCollectorsTest is a test class for testing the behavior of GTEventCollectors
"
Class {
	#name : #EREventCollectorsTest,
	#superclass : #TestCase,
	#instVars : [
		'collectors'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #running }
EREventCollectorsTest >> setUp [
	super setUp.
	collectors := EREventCollectors new.
]

{ #category : #tests }
EREventCollectorsTest >> testAdd [
	collectors add: EREventCollector new.
	self assert: collectors size equals: 1.
]

{ #category : #tests }
EREventCollectorsTest >> testAdd2 [
	collectors add: EREventCollector new.
	collectors add: EREventCollector new.
	self assert: collectors size equals: 2.
]

{ #category : #tests }
EREventCollectorsTest >> testAdd3 [
	| collector |
	collector := EREventCollector new.
	collectors add: collector.
	collectors add: collector.
	self assert: collectors size equals: 1.
]

{ #category : #tests }
EREventCollectorsTest >> testDefault [
	self assert: collectors size equals: 0.
]

{ #category : #tests }
EREventCollectorsTest >> testDo [
	"Ensure that collectors are iterated in the same order as they are added."
	| collector1 collector2 interatedCollectors |
	collector1 := EREventCollector new.
	collector2 := EREventCollector new.
	collectors add: collector2.
	collectors add: collector1.
	interatedCollectors := OrderedCollection new.
	collectors do: [ :eachCollector | interatedCollectors addLast: eachCollector ].
	self assert: interatedCollectors size equals: 2.
	self assert: interatedCollectors first == collector2.
	self assert: interatedCollectors second == collector1.
	
]

{ #category : #tests }
EREventCollectorsTest >> testDo2 [
	"Ensure that collectors are iterated in the same order as they are added."
	| collector1 collector2 interatedCollectors |
	collector1 := EREventCollector new.
	collector2 := EREventCollector new.
	collectors add: collector1.
	collectors add: collector2.
	interatedCollectors := OrderedCollection new.
	collectors do: [ :eachCollector | interatedCollectors addLast: eachCollector ].
	self assert: interatedCollectors size equals: 2.
	self assert: interatedCollectors first == collector1.
	self assert: interatedCollectors second == collector2.
	
]

{ #category : #tests }
EREventCollectorsTest >> testPrintOn [
	self assert: (String streamContents: [ :stream | collectors printOn: stream ]) notEmpty.
]
