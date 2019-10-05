"
I represent an error that appears when a data cannot be unpacked (materialized).

Collaborators: GTEventUnpacking

"
Class {
	#name : #EREventUnpackingError,
	#superclass : #EREventRecorderError,
	#instVars : [
		'data',
		'errors'
	],
	#category : #'EventRecorder-Exceptions'
}

{ #category : #'instance creation' }
EREventUnpackingError class >> signal: aString data: aByteArray errors: aCollection [ 
	^ self new
			data: aByteArray;
			errors: aCollection;
			signal: aString;
			yourself
]

{ #category : #accessing }
EREventUnpackingError >> data [
	^ data
]

{ #category : #accessing }
EREventUnpackingError >> data: anObject [
	data := anObject
]

{ #category : #accessing }
EREventUnpackingError >> errors [
	^ errors
]

{ #category : #accessing }
EREventUnpackingError >> errors: anObject [
	errors := anObject
]

{ #category : #private }
EREventUnpackingError >> isResumable [
	"Determine whether an exception is resumable."
	^true
]
