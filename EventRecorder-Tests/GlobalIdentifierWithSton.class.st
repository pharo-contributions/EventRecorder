Class {
	#name : #GlobalIdentifierWithSton,
	#superclass : #GlobalIdentifierTest,
	#category : #'EventRecorder-Tests-Identifier'
}

{ #category : #accessing }
GlobalIdentifierWithSton >> fileName [
	^ 'preferences.ston'
]

{ #category : #running }
GlobalIdentifierWithSton >> setUpPersistenceStrategy [
	identifier persistenceStrategy: GlobalIdentifierPersistence ston.
	identifier persistenceStrategy preferences: preferences
]
