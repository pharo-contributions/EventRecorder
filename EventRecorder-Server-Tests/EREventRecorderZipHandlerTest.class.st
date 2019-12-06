"
A GTEventRecorderZipHandlerTest is a test class for testing the behavior of GTEventRecorderZipHandler
"
Class {
	#name : #EREventRecorderZipHandlerTest,
	#superclass : #TestCase,
	#instVars : [
		'fileSystem',
		'handler'
	],
	#category : #'EventRecorder-Server-Tests'
}

{ #category : #initialization }
EREventRecorderZipHandlerTest >> setUp [
	super setUp.
	fileSystem := FileSystem memory.
	handler := EREventRecorderZipHandler new.
	handler fileDirectory: fileSystem workingDirectory / 'files'.
	handler zipRootUrl: 'http://localhost/gt/zip/' asZnUrl.
]

{ #category : #initialization }
EREventRecorderZipHandlerTest >> testZipUrl [
	self assert: handler zipRootUrl notNil.
	self assert: handler zipRootUrl asString equals: 'http://localhost/gt/zip/'
]
