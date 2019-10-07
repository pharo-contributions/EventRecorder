"
A GTEventBundleTest is a test class for testing the behavior of GTEventBundle
"
Class {
	#name : #EREventBundleTest,
	#superclass : #TestCase,
	#instVars : [
		'bundle',
		'data',
		'category',
		'url',
		'entity'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #running }
EREventBundleTest >> setUp [
	super setUp.
	bundle := EREventBundle new.
	data := #[1 2 3 4].
	category := #category1.
	url := 'http://localhost/gt/events' asZnUrl.
	
]

{ #category : #tests }
EREventBundleTest >> testData [
	"It is really important that it is the same object."
	bundle data: data.
	self assert: bundle data == bundle data.
]

{ #category : #tests }
EREventBundleTest >> testEntity [
	bundle data: data.
	entity := bundle entity.
	self assert: (entity isKindOf: ZnByteArrayEntity).
	self assert: entity bytes equals: data.
]
