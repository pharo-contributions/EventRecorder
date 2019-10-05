Extension { #name : #EREventTool }

{ #category : #'*EventRecorder-Inspector' }
EREventTool >> gtInspectorActionHelp [
	<gtInspectorAction>
	^ GLMGenericAction new
		action: [:b | 
		HelpBrowser open selectTopicSatisfying: [:each |
			each owner notNil and:  [
			(each owner key = EREventRecorderHelp key) and: [
				each title = 'Data Analysis' ] ] ] ];
		icon: GLMUIThemeExtraIcons glamorousHelp;
		title: 'Help'
]
