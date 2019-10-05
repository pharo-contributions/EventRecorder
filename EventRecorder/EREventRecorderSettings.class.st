"
I represents Privacy settings. You can open Settings Browser and see Privacy group.

Execute: SettingBrowser open
"
Class {
	#name : #EREventRecorderSettings,
	#superclass : #Object,
	#classInstVars : [
		'url'
	],
	#category : #'EventRecorder-Settings'
}

{ #category : #cleanup }
EREventRecorderSettings class >> cleanUp [
	"Clean settings."
	url := nil
]

{ #category : #accessing }
EREventRecorderSettings class >> stringUrl [
	^ self url asString
]

{ #category : #accessing }
EREventRecorderSettings class >> stringUrl: aUrlString [
	^ self url: aUrlString
]

{ #category : #accessing }
EREventRecorderSettings class >> url [
	^ url ifNil: [ url := 'http://gc.dcc.uchile.cl.:8080/gt/events' asZnUrl ]
]

{ #category : #accessing }
EREventRecorderSettings class >> url: aZnUrl [
	url := aZnUrl ifNotNil: [ aZnUrl asZnUrl ]
]

{ #category : #settings }
EREventRecorderSettings class >> urlSettingsOn: aBuilder [ 
	<systemsettings>	
	(aBuilder setting: #stringUrl)
		parent: #gt;
		target: self;
		description: 'The default URL for the Event Recorder server.';
		label: 'Event Recorder URL address'

]
