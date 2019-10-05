Extension { #name : #EREventRecorder }

{ #category : #'*EventRecorder-Inspector' }
EREventRecorder >> gtInspectorActionHelp [
	<gtInspectorAction>
	^ GLMGenericAction new
		action: [:b | 
		HelpBrowser open selectTopicSatisfying: [:each |
			each owner notNil and:  [
			(each owner key = EREventRecorderHelp key) and: [
				each title = 'Client' ] ] ] ];
		icon: GLMUIThemeExtraIcons glamorousHelp;
		title: 'Help'
]

{ #category : #'*EventRecorder-Inspector' }
EREventRecorder >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 1>
	^ collectors ifNotNil: [ 
			(collectors gtInspectorItemsIn: composite) ]
]
