"
A GTEventConsolidateTest is a test class for testing the behavior of GTEventConsolidate
"
Class {
	#name : #EREventConsolidateTest,
	#superclass : #TestCase,
	#instVars : [
		'consolidate',
		'collector1',
		'collector2',
		'collector3',
		'collectors',
		'consolidated',
		'data'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #running }
EREventConsolidateTest >> setUp [
	super setUp.
	data := { 42. 'string'. Float pi }.
	consolidate := EREventConsolidate new.
	collector1 := EREventCollector new.
	collector2 := EREventCollector new.
	collector3 := EREventCollector new.
	collectors := Array with: collector1 with: collector2 with: collector3.
	
]

{ #category : #tests }
EREventConsolidateTest >> testConsolidated [
	"Test that all collectors are consolidated into one."
	collector1 add: data first.
	collector2 add: data second.
	collector3 add: data third.
	consolidate collectors: collectors.
	consolidated := consolidate consolidated.
	self assert: consolidated size equals: 1.
	self assert: consolidated first bundle asArray equals: data.
]

{ #category : #tests }
EREventConsolidateTest >> testConsolidated2 [
	"Test that all collectors are consolidated into one."
	collector1 add: data first.
	collector1 add: data second.
	collector2 add: data third.
	consolidate collectors: collectors.
	consolidated := consolidate consolidated.
	self assert: consolidated size equals: 1.
	self assert: consolidated first bundle asArray equals: data.
]

{ #category : #tests }
EREventConsolidateTest >> testConsolidated3 [
	"Test that all collectors are consolidated according to URL."
	collector1 add: data first; url: 'http://localhost/1' asZnUrl.
	collector2 add: data second; url: 'http://localhost/2' asZnUrl.
	collector3 add: data third; url: 'http://localhost/1' asZnUrl.
	consolidate collectors: collectors.
	consolidated := consolidate consolidated.
	self assert: consolidated size equals: 2.
	self assert: consolidated first bundle asArray equals: {data first. data third}.
	self assert: consolidated second bundle asArray equals: {data second}.
	
]

{ #category : #tests }
EREventConsolidateTest >> testConsolidated4 [
	"Test that all collectors are consolidated according to URL."
	collector1 add: data first; category: #c1.
	collector2 add: data second; category: #c2.
	collector3 add: data third; category: #c1.
	consolidate collectors: collectors.
	consolidated := consolidate consolidated.
	self assert: consolidated size equals: 2.
	self assert: consolidated first bundle asArray equals: {data first. data third}.
	self assert: consolidated second bundle asArray equals: {data second}.
	
]
