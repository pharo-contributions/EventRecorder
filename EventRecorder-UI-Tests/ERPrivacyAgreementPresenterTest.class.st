Class {
	#name : #ERPrivacyAgreementPresenterTest,
	#superclass : #TestCase,
	#category : #'EventRecorder-UI-Tests'
}

{ #category : #tests }
ERPrivacyAgreementPresenterTest >> testMessage [

	| previousSetting |
	[ | presenter |
	previousSetting := ERPrivacy sendDiagnosticsAndUsageData.
	presenter := ERPrivacyAgreementPresenter new.
	ERPrivacy sendDiagnosticsAndUsageData: true.
	self assert: presenter privacyMessage equals: presenter sendingMessage.
	ERPrivacy sendDiagnosticsAndUsageData: false.
	self assert: presenter privacyMessage equals: presenter notSendingMessage ]
		ensure: [ ERPrivacy sendDiagnosticsAndUsageData: previousSetting ]
]

{ #category : #tests }
ERPrivacyAgreementPresenterTest >> testOpenWindowAddsItToWindowCollection [

	| presenter |
	self shouldnt: [ presenter := ERPrivacyAgreementPresenter new openWithSpec ] raise: MessageNotUnderstood.
	presenter close
]
