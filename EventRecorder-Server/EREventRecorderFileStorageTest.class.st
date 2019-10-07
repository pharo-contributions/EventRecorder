"
A GTEventRecorderFileStorageTest is a test class for testing the behavior of GTEventRecorderFileStorage
"
Class {
	#name : #EREventRecorderFileStorageTest,
	#superclass : #TestCase,
	#instVars : [
		'fileSystem',
		'storage'
	],
	#category : #'EventRecorder-Server-Tests'
}

{ #category : #asserting }
EREventRecorderFileStorageTest >> assertLocation: location input: input [
	| file output |
	file := storage directory resolveString: location.
	self assert: file exists.
	output := file binaryReadStreamDo: [ :stream | stream upToEnd ].
	self assert: output equals: input
]

{ #category : #running }
EREventRecorderFileStorageTest >> setUp [
	super setUp.
	fileSystem := FileSystem memory.
	storage := EREventRecorderFileStorage new.
	storage directory: fileSystem workingDirectory.
]

{ #category : #tests }
EREventRecorderFileStorageTest >> testAtCategoryPut [
	| location input category |
	input := #[1 2 3 4].
	category := 'category1'.
	location := storage atCategory: category put: input.
	self assertLocation: location input: input
]

{ #category : #tests }
EREventRecorderFileStorageTest >> testDirectory [
	self assert: storage directory exists.
	self assert: storage directory isWritable.
]

{ #category : #tests }
EREventRecorderFileStorageTest >> testPut [
	| location input |
	input := #[ 1 2 3 4 ].
	location := storage put: input.
	self assertLocation: location input: input
]
