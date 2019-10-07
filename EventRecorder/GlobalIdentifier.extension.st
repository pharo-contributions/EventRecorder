Extension { #name : #GlobalIdentifier }

{ #category : #'*EventRecorder' }
GlobalIdentifier >> obfuscateIfNecessary: anObject [
	^ ERPrivacy sendEntityNames
			ifTrue: [ anObject ]
			ifFalse: [ self obfuscate: anObject ]
]
