Extension { #name : #ERGlobalIdentifier }

{ #category : #'*EventRecorder' }
ERGlobalIdentifier >> obfuscateIfNecessary: anObject [
	^ ERPrivacy sendEntityNames
			ifTrue: [ anObject ]
			ifFalse: [ self obfuscate: anObject ]
]
