"
A GTEventRecorderExternalZipScriptTest is a test class for testing the behavior of GTEventRecorderExternalZipScript
"
Class {
	#name : #EREventRecorderExternalZipScriptTest,
	#superclass : #TestCase,
	#category : #'EventRecorder-Server-Tests'
}

{ #category : #tests }
EREventRecorderExternalZipScriptTest >> testSystem [
	| result |
	result := EREventRecorderExternalZipScript new system: 'ls .'.
	self assert: result isZero.
]

{ #category : #tests }
EREventRecorderExternalZipScriptTest >> testSystem2 [
	"Calling a command incorrectly"
	| result |
	result := EREventRecorderExternalZipScript new system: 'ls --non-existent-parameter'.
	self deny: result isZero.
]

{ #category : #tests }
EREventRecorderExternalZipScriptTest >> testSystem3 [
	"Calling a non existent command"
	| result |
	result := EREventRecorderExternalZipScript new system: 'non-existent-command'.
	self deny: result isZero.
]
