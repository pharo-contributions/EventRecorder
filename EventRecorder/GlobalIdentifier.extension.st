Extension { #name : #GlobalIdentifier }

{ #category : #'*EventRecorder' }
GlobalIdentifier >> obfuscateIfNecessary: anObject [
	^ Privacy sendEntityNames
			ifTrue: [ anObject ]
			ifFalse: [ self obfuscate: anObject ]
]
