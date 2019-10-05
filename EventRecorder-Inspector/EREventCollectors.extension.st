Extension { #name : #EREventCollectors }

{ #category : #'*EventRecorder-Inspector' }
EREventCollectors >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 1>
	^ collectors ifNotNil: [ 
			(collectors gtInspectorItemsIn: composite)
				title: 'Collectors' ]
]
