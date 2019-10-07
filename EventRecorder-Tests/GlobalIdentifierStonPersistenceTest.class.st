Class {
	#name : #GlobalIdentifierStonPersistenceTest,
	#superclass : #GlobalIdentifierPersistenceTest,
	#category : #'EventRecorder-Tests-Identifier'
}

{ #category : #accessing }
GlobalIdentifierStonPersistenceTest >> persistenceClass [
	^ GlobalIdentifierStonPersistence
]

{ #category : #running }
GlobalIdentifierStonPersistenceTest >> setUpPreferences [
	| memory |
	memory := FileSystem memory.
	preferences := memory workingDirectory / self folderName / 'pharoX' / 'preferences.ston'.
	preferences ensureDelete.
]

{ #category : #running }
GlobalIdentifierStonPersistenceTest >> setUpPreferencesAndChecker [
	| memory |
	memory := FileSystem memory.
	preferences := memory workingDirectory / self folderName / 'pharoX' / 'preferences.ston'.
	preferences ensureDelete.
	checker := GlobalIdentifierPersistenceMockChecker new
		answer: [ memory workingDirectory exists ]
]
