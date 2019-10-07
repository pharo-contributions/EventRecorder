"
A GTEventRecorderDelegateTest is a test class for testing the behavior of GTEventRecorderDelegate
"
Class {
	#name : #EREventRecorderDelegateTest,
	#superclass : #TestCase,
	#instVars : [
		'serverSemaphore',
		'delegate',
		'server',
		'client',
		'fileSystem'
	],
	#category : #'EventRecorder-Server-Tests'
}

{ #category : #converting }
EREventRecorderDelegateTest >> assertLocation: location input: input [
	| file output |
	file := fileSystem workingDirectory resolveString: location.
	self assert: file exists.
	output := file binaryReadStreamDo: [ :stream | stream upToEnd ].
	self assert: output equals: input
]

{ #category : #private }
EREventRecorderDelegateTest >> compress: aFileReference [
	^ (aFileReference basename, '.zip')
]

{ #category : #running }
EREventRecorderDelegateTest >> setUp [
	super setUp.
	serverSemaphore := Semaphore new.
	fileSystem := FileSystem memory.
	delegate := EREventRecorderDelegate new.
	delegate putHandler directory: fileSystem workingDirectory / 'files'.
	delegate zipHandler 
		fileDirectory: fileSystem workingDirectory / 'files';
		zipRootUrl: 'http://localhost/gt/zip' asZnUrl;
		archiver: self.
	server := GTEventRecorderTestServer new.
	server initializeUsingDelegate: delegate semaphore: serverSemaphore.
	client := ZnClient new
		url: server url;
		followRedirects: false;
		numberOfRetries: 0;
		enforceHttpSuccess: true;
		logToTranscript;
		yourself.
]

{ #category : #running }
EREventRecorderDelegateTest >> tearDown [
	super tearDown.
	server stop.
	server unsubscribeAll.
]

{ #category : #tests }
EREventRecorderDelegateTest >> testHandleGetFromEvents [
	| contents |
	client path: '/gt/events'; get.
	self assert: client isSuccess.
	contents := client response contents.
	self assert: contents isString.
	self assert: contents equals: 'OK'.
]

{ #category : #tests }
EREventRecorderDelegateTest >> testHandleGetFromEvents2 [
	| contents |
	client path: '/gt/events/'; get.
	self assert: client isSuccess.
	contents := client response contents.
	self assert: contents isString.
	self assert: contents equals: 'OK'.
]

{ #category : #tests }
EREventRecorderDelegateTest >> testHandleGetFromGT [
	| contents |
	client path: '/gt'; get.
	self assert: client isSuccess.
	contents := client response contents.
	self assert: contents isString.
	self assert: contents equals: 'OK'.
]

{ #category : #tests }
EREventRecorderDelegateTest >> testHandleGetFromGT2 [
	| contents |
	client path: '/gt/'; get.
	self assert: client isSuccess.
	contents := client response contents.
	self assert: contents isString.
	self assert: contents equals: 'OK'.
]

{ #category : #tests }
EREventRecorderDelegateTest >> testHandleGetFromRoot [
	| contents |
	client get.
	self assert: client isSuccess.
	contents := client response contents.
	self assert: contents isString.
	self assert: contents equals: 'OK'.
]

{ #category : #tests }
EREventRecorderDelegateTest >> testHandleGetFromRoot2 [
	| contents |
	client path: '//'; get.
	self assert: client isSuccess.
	contents := client response contents.
	self assert: contents isString.
	self assert: contents equals: 'OK'.
]

{ #category : #tests }
EREventRecorderDelegateTest >> testHandleGetFromZip [
	"It returns 404 if a category does not exist."
	client 
		path: '/gt/zip'; 
		queryAt: 'category' put: 'categoryOne';
		enforceHttpSuccess: false;
		get.
	self deny: client isSuccess.
	self assert: client response code equals: 404.
	self assert: client contents equals: 'Category Not Found categoryOne', String crlf
]

{ #category : #tests }
EREventRecorderDelegateTest >> testHandleGetFromZip2 [
	"It returns 200 if a category does exist."
	| directory |
	directory := (fileSystem workingDirectory / 'files' / 'categoryOne').
	directory ensureCreateDirectory.
	client 
		followRedirects: false;
		path: '/gt/zip'; queryAt: 'category' put: 'categoryOne'; 
		get.
	self assert: client isRedirect.
	self assert: client response code equals: 302.
	self assert: client response location equals: 'http://localhost/gt/zip/categoryOne.zip'.
]

{ #category : #tests }
EREventRecorderDelegateTest >> testHandleGetFromZip3 [
	"It returns 404 if a category is not specified."
	client 
		path: '/gt/zip'; 
		enforceHttpSuccess: false;
		get.
	self deny: client isSuccess.
	self assert: client response code equals: 400.
	self assert: client contents equals: '?category=<category-name> is missing in /gt/zip', String crlf
]

{ #category : #tests }
EREventRecorderDelegateTest >> testHandlePut [
	| data entity |
	data := #[1 2 3 4].
	entity := ZnByteArrayEntity bytes: data.
	client
		addPathSegment: 'gt';
		addPathSegment: 'events';
		entity: entity;
		put.
	self assert: client isSuccess.
	self assert: client isCreated.
	self assertLocation: 'files/' , client response location input: data
	
]

{ #category : #tests }
EREventRecorderDelegateTest >> testHandlePut2 [
	| data entity |
	data := #[1 2 3 4].
	entity := ZnByteArrayEntity bytes: data.
	client
		path: 'gt/events/';
		entity: entity;
		put.
	self assert: client isSuccess.
	self assert: client isCreated.
	self assertLocation: 'files/' , client response location input: data

]

{ #category : #tests }
EREventRecorderDelegateTest >> testHandlePutOfEventRecorder [
	| recorder collector semaphore files contents unpackedData |
	semaphore := Semaphore new.
	server when: ZnConnectionAcceptedEvent do: [ :announcement | semaphore signal ].
	server when: ZnServerConnectionClosedEvent do: [ :announcement | semaphore signal ].
	recorder := GTEventRecorder new.
	recorder deliveryPreSuspendingAction: [ recorder deliveryPreSuspendingAction: []. semaphore signal ].
	recorder offerPrivacy.
	collector := GTEventCollector new.
	collector url: (server url
		addPathSegment: 'gt';
		addPathSegment: 'events';
		yourself).
	collector category: #testingCategory.
	recorder addCollector: collector.
	collector add: 42.
	[	self deny: (semaphore waitTimeoutMSecs: 200).
		recorder deliverNow.	
		self deny: (semaphore waitTimeoutMSecs: 200).
		self deny: (semaphore waitTimeoutMSecs: 200) ] ensure: [ recorder deactivateDelivery ].
	files := (fileSystem workingDirectory / 'files' / 'testingCategory') allFiles.
	self assert: files size equals: 1.
	contents := GTEventUnpacking default unpackFile: files first.
	self assert: (contents isKindOf: GTEventAnnouncement).
	unpackedData := contents unpackedData.
	self assert: unpackedData isCollection.
	self assert: unpackedData size equals: 1.
	self assert: unpackedData first equals: 42.
	
]
