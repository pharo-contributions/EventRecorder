"
I represent an object that is kept by a GTEventCollector. I serve only for the testing purpose.
"
Class {
	#name : #ERDummyEvent,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #comparing }
ERDummyEvent >> = aDummyEvent [
	^ self class = aDummyEvent class and: [ 
		self data = aDummyEvent data ]
]

{ #category : #accessing }
ERDummyEvent >> data [
	^ data
]

{ #category : #accessing }
ERDummyEvent >> data: anObject [
	data := anObject
]

{ #category : #comparing }
ERDummyEvent >> hash [
	^ self class hash bitXor: self data
]
