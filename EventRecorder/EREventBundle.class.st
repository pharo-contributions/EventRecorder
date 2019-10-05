"
I associate a piece of data that should be delivered to a remote server with the url of that remote server.

Instances of me should be sent to a GTEventDelivery.


"
Class {
	#name : #EREventBundle,
	#superclass : #Object,
	#instVars : [
		'url',
		'category',
		'data'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #visitor }
EREventBundle >> accept: aVisitor [ 
	^ aVisitor visitSingleBundle: self
]

{ #category : #accessing }
EREventBundle >> category [
	^ category
]

{ #category : #accessing }
EREventBundle >> category: anObject [
	category := anObject
]

{ #category : #accessing }
EREventBundle >> data [
	^ data
]

{ #category : #accessing }
EREventBundle >> data: anObject [
	data := anObject
]

{ #category : #'accessing - computed' }
EREventBundle >> entity [
	^ ZnByteArrayEntity bytes: self data
]

{ #category : #accessing }
EREventBundle >> url [
	^ url
]

{ #category : #accessing }
EREventBundle >> url: anObject [
	url := anObject
]
