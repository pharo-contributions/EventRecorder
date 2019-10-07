Class {
	#name : #ERPrivacyAgreementPresenterTest,
	#superclass : #TestCase,
	#category : #'EventRecorder-UI'
}

{ #category : #tests }
ERPrivacyAgreementPresenterTest >> testMessage [

	| previousSetting |
	[ | presenter |
	previousSetting := Privacy sendDiagnosticsAndUsageData.
	presenter := ERPrivacyAgreementPresenter new.
	Privacy sendDiagnosticsAndUsageData: true.
	self assert: presenter privacyMessage equals: presenter sendingMessage.
	Privacy sendDiagnosticsAndUsageData: false.
	self assert: presenter privacyMessage equals: presenter notSendingMessage ]
		ensure: [ Privacy sendDiagnosticsAndUsageData: previousSetting ]
]

{ #category : #tests }
ERPrivacyAgreementPresenterTest >> testOpenWindowAddsItToWindowCollection [

	| presenter |
	self shouldnt: [ presenter := ERPrivacyAgreementPresenter new openWithSpec ] raise: MessageNotUnderstood.
	presenter close
]
