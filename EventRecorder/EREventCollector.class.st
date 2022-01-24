"
I represent a collection of data that should be sent to a specific URL. 

I am responsible for collecting data (#add: method) and for giving collected data to GTEventPacking object (#bundle method).

You should consider to set #category. This value is used for separating data on the server to directories. That way you will then easier receive your collected data. If you creates a subclass of me, you can override #defaultCategory method.

You should also consider set #occupant:. This could be an object that uses me and feeds me with data. I keep this occupant weakly. So, if the object is removed from the memory, GTEventRecorder knows that I can be removed too. 

I collaborate with GTEventPacking object that receives collected data and URL, serilize the collected data, and creates GTEventBundle object. My subclasses can handle differently what data to send together to server by rewritting #bundle method.

Public API and Key Messages

- bundle   
- url
- category
- occupant:
- register

Example for playing with me:
	GTEventCollector new
		category: #testingForFun;
		occupant: nil ""object that represents your application"";
		add: 42;
		add: 'Hallo Pharo user';
		yourself.

Example for serious use:
	GTEventCollector new
		category: #testingForReal;
		occupant: nil ""object that represents your application, if nil, the collector will be removed from GTEventRecorder object once collected data are sent"";
		register; ""please do not register just for fun, because we collects those data""
		yourself
 
Internal Representation and Key Implementation Points.

    Instance Variables
	recordedEvents:		<WaitfreeQueue>
	url:		<ZnUrl>

"
Class {
	#name : #EREventCollector,
	#superclass : #Object,
	#instVars : [
		'url',
		'category',
		'recordedEvents',
		'registry',
		'updateAnnouncementBlock',
		'xp',
		'task'
	],
	#category : #'EventRecorder-Core'
}

{ #category : #examples }
EREventCollector class >> notRegisteredCollector [
	<sampleInstance>

	^ self new
		category: #testingForFun; "the data are stored under the defined category."
		occupant: nil; "object that represents your application, if nil, the collector will be removed from GTEventRecorder object once collected data are sent"
		add: 42; "collected data"
		add: 'Hallo Pharo user'; "collected data"
		register; "please, be aware that we collect the data"
		yourself.
]

{ #category : #adding }
EREventCollector >> add: anEvent [ 
	"And an event (any object) that you want to send to a server."
	^ recordedEvents nextPut: anEvent
]

{ #category : #adding }
EREventCollector >> addIfAvailable: anEvent [
	"It add event to a queue only if sending diagnostic and usage data is enabled."
	ERPrivacy sendDiagnosticsAndUsageData ifFalse: [ ^ anEvent ].	
	^ self add: anEvent
]

{ #category : #accessing }
EREventCollector >> bundle [
	"It returns all collected events that are supposed to be sent. If you need to send just a portion of the collected events, this is the place to overwrite."
	^ self bundle: OrderedCollection new.
]

{ #category : #accessing }
EREventCollector >> bundle: aCollection [
	recordedEvents flush: [ :eachEvent | aCollection addLast: eachEvent ].
	^ aCollection
]

{ #category : #accessing }
EREventCollector >> category [
	^ category ifNil: [ category := self defaultCategory ]
]

{ #category : #accessing }
EREventCollector >> category: aString [ 
	"It is used for distinguishing data from different application on a server.
	The data are stored separately on a server according to category name."
	^ category := aString
]

{ #category : #configuration }
EREventCollector >> defaultCategory [
	"Default category name. You can set your own by calling #category: or 
	by overwriting this method if you have a spetialized subclass."
	^ #unknown
]

{ #category : #accessing }
EREventCollector >> flush [
	"Be careful when using it. You will lost all data."
	recordedEvents flush
]

{ #category : #initialization }
EREventCollector >> initialize [
	super initialize.	
	recordedEvents := WaitfreeQueue new.
]

{ #category : #testing }
EREventCollector >> isLiberated [
	"When I answer true, I can be removed from a GTEventRecorder object."
	^ self registry isLiberated and: [ recordedEvents isEmpty ]
]

{ #category : #actions }
EREventCollector >> liberate [
	"Liberate me from the occupant so I can be removed from GTEventRecorder object in the next delivery cycle."
	^ self registry liberate.
]

{ #category : #packing }
EREventCollector >> newAnnouncement [
	^ EREventAnnouncement new
]

{ #category : #packing }
EREventCollector >> newAnnouncementForPacking [

	| announcement |
	announcement := self newAnnouncement.
	announcement category: self category.
	^ announcement
]

{ #category : #packing }
EREventCollector >> newBundle [

	^ EREventBundle new
]

{ #category : #packing }
EREventCollector >> newBundleForPacking [

	| bundle |
	bundle := self newBundle.
	bundle
		url: self url;
		category: self category.
	^bundle
]

{ #category : #accessing }
EREventCollector >> occupant: anObject [ 
	"anObject sends me data. I weakly keeps anObject and once it is released, I can be removed from GTEventRecorder object."
	self registry object: anObject
]

{ #category : #printing }
EREventCollector >> printOn: aStream [
	super printOn: aStream.
	aStream
		space;
		nextPut: $[;
		print: recordedEvents size;
		space;
		nextPutAll: ('item' asPluralBasedOn: recordedEvents size);
		nextPut: $]
]

{ #category : #initialization }
EREventCollector >> register [
	"Register to the global GTEventRecorder."
	EREventRecorder uniqueInstance addCollector: self.
]

{ #category : #accessing }
EREventCollector >> registry [
	"Registry is a weak holder of my owner. Once it is nil, I can be removed from GTEventRecorder object."
	^ registry ifNil: [ registry := EREventRegistry new ]
]

{ #category : #accessing }
EREventCollector >> size [
	"It returns number of collected events."
	^ recordedEvents size
]

{ #category : #updating }
EREventCollector >> updateAnnouncement: aGTEventAnnouncement [ 
	updateAnnouncementBlock ifNil: [ ^ aGTEventAnnouncement ].
	updateAnnouncementBlock cull: aGTEventAnnouncement.
	^ aGTEventAnnouncement
]

{ #category : #updating }
EREventCollector >> updateAnnouncementBlock: aBlockClosure [ 
	updateAnnouncementBlock := aBlockClosure
]

{ #category : #accessing }
EREventCollector >> url [
	"It returns URL indicating where to send collected data."
	^ url ifNil: [ url := EREventRecorderSettings url ]
]

{ #category : #accessing }
EREventCollector >> url: aZnUrl [
	"URL that indicates where to send collected data."
	url := aZnUrl
]
