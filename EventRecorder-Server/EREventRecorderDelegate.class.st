Class {
	#name : #EREventRecorderDelegate,
	#superclass : #Object,
	#instVars : [
		'dispatcher',
		'putHandler',
		'zipHandler'
	],
	#category : #'EventRecorder-Server-Core'
}

{ #category : #public }
EREventRecorderDelegate >> handleRequest: request [
	^ dispatcher handleRequest: request
]

{ #category : #initialization }
EREventRecorderDelegate >> initialize [
	super initialize.
	putHandler := EREventRecorderPutHandler new.
	putHandler storage: (EREventRecorderFileStorage new
		directory: FileLocator home / 'gt' / 'events';
		yourself).
	zipHandler := EREventRecorderZipHandler new.
	zipHandler 
		fileDirectory: FileLocator home / 'gt' / 'events';
		zipRootUrl: 'http://gc.dcc.uchile.cl/' asZnUrl;
		archiver: EREventRecorderExternalZipScript new.
	dispatcher := ZnDispatcherDelegate new.
	self initializeDispatcher
]

{ #category : #initialization }
EREventRecorderDelegate >> initializeDispatcher [
	| okResponse |
	okResponse := [ :request :response | ZnResponse ok: (ZnEntity text: 'OK') ].
	dispatcher 
		map: '/' to: okResponse;
		map: '/gt' to: okResponse;
		map: '/gt/' to: okResponse;
		map: '/gt/zip' to: zipHandler;
		map: '/gt/zip/' to: zipHandler;
		map: '/gt/events' to: putHandler;
		map: '/gt/events/' to: putHandler;
		yourself
]

{ #category : #accessing }
EREventRecorderDelegate >> putHandler [
	"for the testing purpose"
	^ putHandler
]

{ #category : #accessing }
EREventRecorderDelegate >> zipHandler [
	"for the testing purpose"
	^ zipHandler
]
