"
I'm a little framework to collect data from Pharo and publish it on server.

This framework has been developed by the GT team (probably T. Girba, A. Chis and others). Since this is a cool framework,I decided to invest in it and repackage it to avoid to have everything in a single package.

The vision is to have several packages.

EventRecorder
EventRecorderInspector
EventRecorderFuel
EventRecorderSTON
EventRecorderServer (should be migrated from SmalltalkHub -- See below)
EventRecorderHelp
and eventually adding tests

http://smalltalkhub.com/#!/~Moose/GToolkit repository, package GT-EventRecorder-Server, or load it using the following configuration:

Gofer it
	smalltalkhubUser: #Moose project: #GToolkit;
	configurationOf: #GTEventRecorderServer;
	loadStable.
"
Class {
	#name : #EREventRecorderHelp,
	#superclass : #CustomHelp,
	#category : #'EventRecorder-Help'
}

{ #category : #pages }
EREventRecorderHelp class >> analysis [
	^HelpTopic 
		title: 'Data Analysis'
		contents:	
	'!! Downloading Data

	The collected data on the server are stored using a standard Linux file system. The data are compressed every hour and can be downloaded from http://gc.dcc.uchile.cl page. 

	You can use GTEventTool class to download all collected data by executing:
	
	GTEventTool default ensureDownloadedData.
	
	It is downloaded to your working directory (next to your Pharo image). Ideally you could extract it using `GTEventTool default ensureExtractedData`, but the current Pharo version does not support ZIP signature that is used for large files. But you can do it manually using standard tools of your system. It is extracted into `./gt/events` directory.
	
!! Data Structure
	
	The data are structured per category and per month. The category is defined by the client side, see the previous section about the client. Let us say that your category is called `myCoolTool` and you have been collecting data since November 2016 to January 2017. Then you will find out the following directory structure:
	
	./gt/events/myCoolTool
		/201611/  - data collected during November 2016
		/201612/  - data collected during Dicember 2016
		/201701/  - data collected during January 2017

	Each file is a serialized GTEventAnnouncement object. The object is a data container of meta data and of collected events.

!! Analysis
	
	We recomend you to remove all data that you are not interested in and start your analysis. To load all data available in the directory executing:
	
	GTEventTool default unpackAll inspect.

	It returns an association `unpackedData -> exceptions`. The key `unpackedData` includes all your data, the value `exceptions` all catched exception that happened while loading the data. You can thus load all correct data and check all errors.
	
	Remember that semantics of the data depends on you. GT Event Recorder only provides a convenient infrustructure to collect data.' 
]

{ #category : #accessing }
EREventRecorderHelp class >> bookDescription [
	^ 'Here, we describe GT Event Recorder, a moldable infrastructure, that allows to capture and store events that are specific to different tools. It is composed of a client and a server that we describe in the following sections. The last section describes basic analysis support.'
]

{ #category : #accessing }
EREventRecorderHelp class >> bookName [
	^ 'GT Event Recorder'
]

{ #category : #pages }
EREventRecorderHelp class >> client [
	^HelpTopic 
		title: 'Client'
		contents:	 (String streamContents: [ :aStream | aStream 
nextPutAll: 
'	The client includes four main objects: GTEventRecorder, GTEventCollector, GTEventAnnouncement, and GTEventTool. The last one is described in the Data Analysis section.
		
!! GTEventRecorder

	GTEventRecorder is a singleton that is responsible for collecting and sending data to a server. You, as a GT Event Recorder user, do not need to take care much of this object. Once you register your GTEventCollector object, it does the job.
	
	It sends data to the server every twenty minutes. If you want to send data immediately, you can execute `GTEventRecorder uniqueInstance deliverNow`.

	Here is the class description:';
nextPutAll: EREventRecorder comment;
cr;
nextPutAll: 
'!! GTEventCollector

	GTEventCollector is a data collector which you want to use. You can create a new instance, register it to the GTEventRecorder and starts to collect data. Here is a basic example:
	
	GTEventCollector new
		category: #testingForFun; 	"the data are stored under the defined category."
		occupant: nil; 					"object that represents your application, if nil, the collector will be removed from GTEventRecorder object once collected data are sent"
		add: 42; 							"collected data"
		add: ''Hello Pharo user''; 	"collected data"
		register; 						"please, be aware that we collect the data"
		yourself.

	As you can see, you can collect any data that is possible to serialize. The current version uses STON for data serialization, see GTStonPacking class. 
	
	Before the data are sent to the server, it is serialized and kept by an GTEventAnnouncement object who also keeps additional information, e.g., computer-id, data and time. The additional information helps you to group collected data per computer and order them according to time. For that reason, we recommend you to collect objects that responds to #infoAt:put:. If so, the additional information is passed to your extracted data.  GTBasicRecorderEvent class represents a basic example that we recommend to use, e.g., subclass it. 

	Here is the class description:';
nextPutAll: EREventCollector comment ])
]

{ #category : #pages }
EREventRecorderHelp class >> introduction [
	^HelpTopic 
		title: 'Introduction'
		contents:	
	'	GT Event Recorder is a moldable infrastructure that allows to capture custom made events that are specific to different tools. The semantics of collected events belongs to tools and developers who use GT Event Recorder. 
	
	Essentially, GT Event Recorder provides an infrastructure that allows researchers and tool builders to collect data easily. That is what makes it interesting.
	
	GT Event Recorder is composed of a client and a server that we describe in the following sections.' 
]

{ #category : #accessing }
EREventRecorderHelp class >> pages [
	^ #(introduction client server analysis)
]

{ #category : #pages }
EREventRecorderHelp class >> server [
	^HelpTopic 
		title: 'Server'
		contents:	
	'	The server is not included in the standard Pharo image. You can find it in http://smalltalkhub.com/#!/~Moose/GToolkit repository, package GT-EventRecorder-Server, or load it using the following configuration:
	
	Gofer it
		smalltalkhubUser: #Moose project: #GToolkit;
		configurationOf: #GTEventRecorderServer;
		loadStable.
	
	The server uses standard Zinc Server (ZnServer class) and you can start it by executing:
	
	GTEventRecorderServer start.
	
	By default, it runs on port 8080. If you need to run it with other services, check GTEventRecorderDelegate class.
	
	You can stop the server using: 
	
	GTEventRecorderServer stop.
	
	The standard server is executed on http://gc.dcc.uchile.cl:8080. 
	
	The following section describes the data storage and data analysis.
	' 
]
