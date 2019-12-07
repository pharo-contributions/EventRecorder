"
I'm a simple window to display privacy information based on previously set settings.
"
Class {
	#name : #ERPrivacyAgreementPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'text',
		'settingButton'
	],
	#category : #'EventRecorder-UI'
}

{ #category : #specs }
ERPrivacyAgreementPresenter class >> defaultSpec [

	^  SpBoxLayout newVertical
			add: #text;
			add:
			(SpBoxLayout newHorizontal
				add: #settingButton;
				yourself)
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		yourself
]

{ #category : #actions }
ERPrivacyAgreementPresenter class >> openSettingsBrowser [
	| settingsBrowser window node nodePath |
	settingsBrowser := SettingBrowser new 
		changePackageSet: (RPackage organizer packageNamed: 'EventRecorder') asOrderedCollection;
		yourself.
	window := settingsBrowser open.
	window position: Display extent - window extent // 2.
	settingsBrowser expandAll.
	node := settingsBrowser treeHolder nodeNamed: #sendDiagnosticsAndUsageData.
	nodePath := Array 
		with: (settingsBrowser treeHolder nodeNamed: node parentName)
		with: node.
	settingsBrowser selection: (MorphTreeMorphSingleSelection new selectedNodePath: nodePath).
]

{ #category : #initialize }
ERPrivacyAgreementPresenter >> initializePresenters [

	text := self newText.
	text text: self privacyMessage.
	settingButton := self newButton.
	settingButton
		label: 'Go to setting ';
		action: [ self openSettingsBrowser ].
]

{ #category : #initialize }
ERPrivacyAgreementPresenter >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self title;
		initialExtent: 400 @ 200
]

{ #category : #initialize }
ERPrivacyAgreementPresenter >> notSendingMessage [

	^ 'No diagnostic and usage data is being sent. Would you like to send diagnostic and usage data to help us improve Pharo?'
]

{ #category : #initialize }
ERPrivacyAgreementPresenter >> openSettingsBrowser [
	self class openSettingsBrowser
]

{ #category : #initialize }
ERPrivacyAgreementPresenter >> privacyMessage [

	^ self sendUsageData 
		ifTrue: [ self sendingMessage ]
		ifFalse: 	[ self notSendingMessage ]
]

{ #category : #initialize }
ERPrivacyAgreementPresenter >> sendUsageData [	
	^ ERPrivacy sendDiagnosticsAndUsageData 
]

{ #category : #initialize }
ERPrivacyAgreementPresenter >> sendingMessage [

	^ 'You are sending diagnostic and usage data to help us improve Pharo. Thanks!' 
]

{ #category : #initialize }
ERPrivacyAgreementPresenter >> title [

	^ 'Privacy agreement'
]
