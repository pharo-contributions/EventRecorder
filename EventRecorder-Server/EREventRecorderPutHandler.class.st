Class {
	#name : #EREventRecorderPutHandler,
	#superclass : #Object,
	#instVars : [
		'storage'
	],
	#category : #'EventRecorder-Server-Core'
}

{ #category : #accessing }
EREventRecorderPutHandler >> directory: aFileReference [ 
	self storage directory: aFileReference
]

{ #category : #testing }
EREventRecorderPutHandler >> hasCategoryAndDataParts: aCollection [
	aCollection pairsDo: [ :aCategoryPart :aDataPart |
		aCategoryPart fieldName = 'category' ifFalse: [ ^ false ].
		aDataPart fieldName = 'data' ifFalse: [ ^ false ].
		(aCategoryPart contentType matches: ZnMimeType textPlain) ifFalse: [ ^ false ].
		(aDataPart contentType matches: ZnMimeType applicationOctetStream) ifFalse: [ ^ false ].
	 ].
	^ true
]

{ #category : #testing }
EREventRecorderPutHandler >> isApplicationOctetStream: aZnRequest [
	^ aZnRequest hasEntity and: [ aZnRequest contentType matches: ZnMimeType applicationOctetStream ]
]

{ #category : #testing }
EREventRecorderPutHandler >> isMultiPartFormData: aZnRequest [
	^ aZnRequest hasEntity 
		and: [ (aZnRequest contentType matches: ZnMimeType multiPartFormData)
		and: [ (aZnRequest entity isEmpty not)
		and: [ aZnRequest entity parts size even
		and: [ self hasCategoryAndDataParts: aZnRequest entity parts ] ] ] ]
]

{ #category : #private }
EREventRecorderPutHandler >> saveByteArray: aByteArray [
	"storage is responsible for storing aByteArray.
	It returns location."
	^ self storage put: aByteArray.
]

{ #category : #private }
EREventRecorderPutHandler >> saveByteArray: aByteArray category: aString [ 
	"storage is responsible for storing aByteArray.
	It returns location."
	^ self storage atCategory: aString put: aByteArray.
]

{ #category : #private }
EREventRecorderPutHandler >> saveMultiPartFormData: anEntity [
	"storage is responsible for storing aByteArray.
	It returns location."
	| keys |
	keys := OrderedCollection new.
	anEntity parts pairsDo: [ :category :data | | key |
		key := self saveByteArray: data fieldValue category: category fieldValue.
		keys addLast: key.
	 ].
	^ keys size printString
]

{ #category : #accessing }
EREventRecorderPutHandler >> storage [
	^ storage
]

{ #category : #accessing }
EREventRecorderPutHandler >> storage: anObject [
	storage := anObject
]

{ #category : #evaluating }
EREventRecorderPutHandler >> value: aZnRequest value: aZnResponse [
	| badRequest key |
	badRequest := [ ^ ZnResponse badRequest: aZnRequest ].
	aZnRequest method = #GET	ifTrue: [ ^ ZnResponse ok: (ZnEntity text: 'OK') ].
	aZnRequest method = #PUT ifFalse: [ badRequest value ].
	(self isApplicationOctetStream: aZnRequest) ifTrue: [ 
			[ key := self saveByteArray: aZnRequest entity bytes ] on: Error do: badRequest.
			^ ZnResponse created: key ].
	(self isMultiPartFormData: aZnRequest) ifTrue: [ 
			[ key := self saveMultiPartFormData: aZnRequest entity ] on: Error do: badRequest.
			^ ZnResponse created: key ].
	badRequest value.
]
