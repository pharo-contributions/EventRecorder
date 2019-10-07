"
A GTEventDeliveryTest is a test class for testing the behavior of GTEventDelivery
"
Class {
	#name : #EREventDeliveryTest,
	#superclass : #TestCase,
	#instVars : [
		'delivery',
		'announcer',
		'semaphore'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #converting }
EREventDeliveryTest >> assertSemaphore [
	self deny: (semaphore waitTimeoutMSecs: 200)
]

{ #category : #testing }
EREventDeliveryTest >> isGlobalRecorder [
	^ false
]

{ #category : #running }
EREventDeliveryTest >> setUp [
	super setUp.
	semaphore := Semaphore new.
	delivery := GTEventDelivery new
]

{ #category : #running }
EREventDeliveryTest >> tearDown [
	super tearDown.
	delivery deactivate.
]

{ #category : #tests }
EREventDeliveryTest >> testPrintOn [
	self assert: (String streamContents: [ :stream | delivery printOn: stream ]) notEmpty.
]

{ #category : #tests }
EREventDeliveryTest >> testPrintOn2 [
	| string |
	delivery recorder: self.
	delivery preSuspendingAction: [ semaphore signal ].
	delivery activate.	
	self assertSemaphore.
	200 milliSeconds wait.
	string := String streamContents: [ :stream | delivery printOn: stream ].
	self assert: string notEmpty.
	self assert: (string includesSubstring: 'next cycle in').
]

{ #category : #tests }
EREventDeliveryTest >> testPrintProcessName [
	self assert: delivery printProcessName isNotEmpty
]
