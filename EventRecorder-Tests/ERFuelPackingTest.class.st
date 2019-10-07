Class {
	#name : #ERFuelPackingTest,
	#superclass : #EREventPackingTest,
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #accessing }
ERFuelPackingTest >> packingClass [
	^ ERFuelPacking
]

{ #category : #tests }
ERFuelPackingTest >> testMigration [
	| oldClass oldObject |
	oldClass := Object newAnonymousSubclass.
	oldObject := oldClass new.
	collector := EREventCollector new.
	collector add: oldObject.
	bundle := packing pack: collector.
	announcement := packing unpack: bundle data.
	self should: [ announcement unpackedData ] raise: FLClassNotFound.
]

{ #category : #tests }
ERFuelPackingTest >> testMigration2 [
	| oldClass oldObject |
	oldClass := Object newAnonymousSubclass.
	oldObject := oldClass new.
	collector := EREventCollector new.
	collector add: oldObject.
	bundle := packing pack: collector.
	packing addMigration: [ :aMaterializer |
		aMaterializer migrateClassNamed: oldClass name asSymbol toClass: ERDummyEvent ].
	announcement := packing unpack: bundle data.
	announcement migrationRules: packing migrations.
	unpackedData := announcement unpackedData.
	self assert: unpackedData isCollection.
	self assert: unpackedData size equals: 1.
	self assert: unpackedData anyOne class equals: ERDummyEvent.
]
