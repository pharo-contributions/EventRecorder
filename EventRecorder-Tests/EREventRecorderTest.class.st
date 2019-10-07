Class {
	#name : #EREventRecorderTest,
	#superclass : #TestCase,
	#instVars : [
		'recorder',
		'server',
		'event1',
		'event2',
		'delegate',
		'receivedContents',
		'semaphore',
		'receiverSemaphore',
		'collector1',
		'collector2',
		'event3',
		'event4'
	],
	#category : #'EventRecorder-Tests-Core'
}

{ #category : #asserting }
EREventRecorderTest >> assertReceiverSemaphore [
	self deny: (receiverSemaphore waitTimeoutMSecs: 200)
]

{ #category : #asserting }
EREventRecorderTest >> assertSemaphore [
	self deny: (semaphore waitTimeoutMSecs: 200)
]

{ #category : #asserting }
EREventRecorderTest >> denyReceiverSemaphore [
	self assert: (receiverSemaphore waitTimeoutMSecs: 200)
]

{ #category : #'server handling' }
EREventRecorderTest >> handleRequest: request response: response [
	receivedContents nextPut: request contents.
	receiverSemaphore signal.
	^ response
]

{ #category : #running }
EREventRecorderTest >> setUp [
	super setUp.
	self setUpServer.
	semaphore := Semaphore new.
	recorder := EREventRecorder new.
	recorder offerPrivacy; offerDeliveryPermission.
	collector1 := EREventCollector new.
	collector1 url: server url.
	collector2 := EREventCollector new.
	collector2 url: server url.
	event1 := ERDummyEvent new data: 'string1'.
	event2 := ERDummyEvent new data: 42.
	event3 := ERDummyEvent new data: #symbol1.
	event4 := ERDummyEvent new data: 42.0.
	
]

{ #category : #running }
EREventRecorderTest >> setUpServer [
	receivedContents := WaitfreeQueue new.
	receiverSemaphore := Semaphore new.
	delegate := ZnDispatcherDelegate new.
	delegate
		map: '/'
		to: [ :request :response | self handleRequest: request response: response ].
	server := EREventRecorderTestServer new.
	server initializeUsingDelegate: delegate semaphore: receiverSemaphore.
]

{ #category : #running }
EREventRecorderTest >> tearDown [
	super tearDown.
	recorder deactivateDelivery.
	server stop.
	server unsubscribeAll.
]

{ #category : #tests }
EREventRecorderTest >> testAddCollector [
	recorder addCollector: EREventCollector new.
	self assert: recorder numberOfCollectors equals: 1.
]

{ #category : #tests }
EREventRecorderTest >> testAddCollector2 [
	recorder addCollector: EREventCollector new.
	self assert: recorder isDeliveryActive.
]

{ #category : #tests }
EREventRecorderTest >> testAddCollector3 [
	recorder addCollector: collector1.
	collector1 add: event1.
	collector1 add: event2.
	recorder deliveryPreSuspendingAction: [ semaphore signal ].
	self assertSemaphore.
	self waitForDelivery.
	self assert: collector1 size equals: 0.
	self assert: receivedContents size equals: 1.
	
]

{ #category : #tests }
EREventRecorderTest >> testAddCollector4 [
	recorder addCollector: collector1.
	collector1 add: event1.
	collector1 add: event2.
	recorder delivery packAndDeliver: false.
	"wait"
	self assert: collector1 size equals: 0.
	
]

{ #category : #tests }
EREventRecorderTest >> testAddCollector5 [
	recorder addCollector: EREventCollector new.
	recorder addCollector: EREventCollector new.
	self assert: recorder numberOfCollectors equals: 2.
]

{ #category : #tests }
EREventRecorderTest >> testAddCollector6 [
	recorder addCollector: collector1.
	recorder addCollector: collector1.
	self assert: recorder numberOfCollectors equals: 1.
]

{ #category : #tests }
EREventRecorderTest >> testDeliverAllInOneHttpRequest [
	collector1 category: #category1.
	collector2 category: #category2.
	collector1 add: event1; add: event2.
	collector2 add: event3; add: event4.
	recorder deliveryPreSuspendingAction: [ semaphore signal ].
	recorder addCollector: collector1.
	recorder addCollector: collector2.
	self assertSemaphore.
	self waitForDelivery.
	self denyReceiverSemaphore.
	self assert: collector1 size equals: 0.
	self assert: collector2 size equals: 0.
	self assert: receivedContents size equals: 1.

]

{ #category : #tests }
EREventRecorderTest >> testDeliverNow [
	"Just test that we can ask for delivering."
	recorder deliverNow
]

{ #category : #tests }
EREventRecorderTest >> testDeliverNow2 [
	"Ensure that liberated collector is removed."
	recorder deliveryPreSuspendingAction: [ semaphore signal ].
	collector1 add: 42.
	recorder addCollector: collector1.
	self assertSemaphore.
	recorder deliverNow.
	self assertSemaphore.
	self assert: collector1 size equals: 0.
	self assert: recorder numberOfCollectors equals: 0.
]

{ #category : #tests }
EREventRecorderTest >> testDeliverNow3 [
	"Ensure that collector with registerd holder is not removed."
	recorder deliveryPreSuspendingAction: [ semaphore signal ].
	collector1 add: 42.
	collector1 occupant: self.
	recorder addCollector: collector1.
	self assertSemaphore.
	recorder deliverNow.
	self assertSemaphore.
	self assert: collector1 size equals: 0.
	self assert: recorder numberOfCollectors equals: 1.
]

{ #category : #tests }
EREventRecorderTest >> testIsDeliveryActive [
	self deny: recorder isDeliveryActive.
]

{ #category : #tests }
EREventRecorderTest >> testNotDeliveredDataShouldBeResent [
	"If the data are not received, we will resent them."
	collector1 category: #category1.
	collector1 add: event1; add: event2.
	"Server will not receive anything."
	server server delegate: ZnDispatcherDelegate new.
	recorder deliveryPreSuspendingAction: [ semaphore signal ].
	recorder addCollector: collector1.
	self assertSemaphore.
	recorder deliverNow.
	self assertSemaphore.
	self denyReceiverSemaphore.
	self assert: collector1 size equals: 0.
	self assert: receivedContents size equals: 0.
	self assert: recorder numberOfDeliveryData equals: 1.
	"Send again."
	server server delegate: delegate.
	self waitForDelivery.
	self denyReceiverSemaphore.
	self assert: receivedContents size equals: 1.
	self assert: recorder numberOfDeliveryData equals: 0.

]

{ #category : #tests }
EREventRecorderTest >> testPack [
	"Ensure that delivery pack is prepared and collector empty."
	recorder addCollector: collector1.
	collector1 add: event1.
	collector1 add: event2.
	recorder pack.
	self assert: collector1 size equals: 0.
	self assert: recorder delivery size equals: 1.
]

{ #category : #tests }
EREventRecorderTest >> testPack2 [
	"Ensure that there is only one delivery pack when collectors are of the same URL and category."
	recorder addCollector: collector1.
	collector1 add: event1.
	collector1 add: event2.
	recorder addCollector: collector2.
	collector2 add: event3.
	collector2 add: event4.
	recorder pack.
	self assert: collector1 size equals: 0.
	self assert: collector2 size equals: 0.
	self assert: recorder delivery size equals: 1.
]

{ #category : #tests }
EREventRecorderTest >> testPack3 [
	"Ensure that empty collector is not delivered."
	recorder addCollector: collector1.
	self assert: collector1 size equals: 0.
	recorder pack.
	self assert: collector1 size equals: 0.
	self assert: recorder delivery size equals: 0.
]

{ #category : #'as yet unclassified' }
EREventRecorderTest >> testPrivacyChanged [
	"Ensure that delivery is turn off when privacy is disabled."
	self assert: recorder canSendDiagnosticsAndUsageData.
	self assert: recorder delivery hasPermission.
	recorder withdrawPrivacy.
	self deny: recorder canSendDiagnosticsAndUsageData.
	self assert: recorder delivery hasPermission.
	recorder privacyChanged.
	self deny: recorder canSendDiagnosticsAndUsageData.
	self deny: recorder delivery hasPermission.

]

{ #category : #'as yet unclassified' }
EREventRecorderTest >> testPrivacyChanged2 [
	"Ensure that delivery is turn off when privacy is available, but there is no any collector."
	self testPrivacyChanged.
	recorder offerPrivacy.
	self assert: recorder canSendDiagnosticsAndUsageData.
	self deny: recorder delivery hasPermission.
	recorder privacyChanged.
	self assert: recorder canSendDiagnosticsAndUsageData.
	self deny: recorder delivery hasPermission.

]

{ #category : #'as yet unclassified' }
EREventRecorderTest >> testPrivacyChanged3 [
	"Ensure that delivery is turn on when privacy is available and there is a collector."
	self testPrivacyChanged.
	recorder addCollector: collector1.
	self deny: recorder canSendDiagnosticsAndUsageData.
	self deny: recorder delivery hasPermission.
	recorder offerPrivacy.
	self assert: recorder canSendDiagnosticsAndUsageData.
	self deny: recorder delivery hasPermission.
	recorder privacyChanged.
	self assert: recorder canSendDiagnosticsAndUsageData.
	self assert: recorder delivery hasPermission.

]

{ #category : #'as yet unclassified' }
EREventRecorderTest >> testPrivacyChanged4 [
	"Ensure that delivery is turn on when privacy is available and there is a collector."
	self testPrivacyChanged.
	recorder offerPrivacy.
	self assert: recorder canSendDiagnosticsAndUsageData.
	self deny: recorder delivery hasPermission.
	recorder privacyChanged.
	self assert: recorder canSendDiagnosticsAndUsageData.
	self deny: recorder delivery hasPermission.
	recorder addCollector: collector1.
	self assert: recorder canSendDiagnosticsAndUsageData.
	self assert: recorder delivery hasPermission.

]

{ #category : #tests }
EREventRecorderTest >> testRemoveCollector [
	recorder removeCollector: EREventCollector new.
	self assert: recorder numberOfCollectors equals: 0.
]

{ #category : #tests }
EREventRecorderTest >> testRemoveCollector2 [
	recorder addCollector: collector1.
	self assert: recorder isDeliveryActive.
	recorder removeCollector: collector1.
	self deny: recorder isDeliveryActive.
]

{ #category : #tests }
EREventRecorderTest >> testTwiceDeliveredDataSholdBeDetected [
	"It happens regularly that the server receives the same data several times.
	We need to be sure that we can detect it easily."
	| bundles data |
	collector1 category: #category1.
	collector1 add: event1; add: event2.
	"Server will not receive anything."
	server server delegate: ZnDispatcherDelegate new.
	recorder deliveryPreSuspendingAction: [ semaphore signal ].
	recorder addCollector: collector1.
	self assertSemaphore.
	recorder deliverNow.
	self assertSemaphore.
	self denyReceiverSemaphore.
	self assert: collector1 size equals: 0.
	self assert: receivedContents size equals: 0.
	self assert: recorder numberOfDeliveryData equals: 1.
	bundles := recorder delivery bundles.
	self assert: bundles size equals: 1.
	self assert: recorder numberOfDeliveryData equals: 0.
	"Send twice."
	server server delegate: delegate.
	recorder delivery deliver: bundles first signalProgress: false.
	recorder delivery deliver: bundles first signalProgress: false.
	self waitForDelivery.
	self waitForDelivery.
	self denyReceiverSemaphore.
	self assert: receivedContents size equals: 2.
	self assert: recorder numberOfDeliveryData equals: 0.
	"Check that we can detect duplication"
	data := OrderedCollection new.
	receivedContents flush: [ :each | data addLast: each ].
	self assert: data first second contents equals: data second second contents.
]

{ #category : #asserting }
EREventRecorderTest >> waitForDelivery [
	recorder deliverNow.
	self assertReceiverSemaphore.
]
