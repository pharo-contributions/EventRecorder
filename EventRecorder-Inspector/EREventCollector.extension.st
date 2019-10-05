Extension { #name : #EREventCollector }

{ #category : #'*EventRecorder-Inspector' }
EREventCollector >> gtInspectorActionHelp [
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
