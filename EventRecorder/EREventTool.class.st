"
I simplify the process of downloading and extracting of recorded data.

You likely want to use #ensureLocalDirectory that downloads and extracts server data or #unpackAll if you want to load all data into memory.


Here is the code of the UI to open the settings

openSettingsBrowser
	| settingsBrowser window node nodePath |
	settingsBrowser := SettingBrowser new 
		changePackageSet: (RPackage organizer packageNamed: 'GT-EventRecorder') asOrderedCollection;
		yourself.
	window := settingsBrowser open.
	window position: Display extent - window extent // 2.
	settingsBrowser expandAll.
	node := settingsBrowser treeHolder nodeNamed: #sendDiagnosticsAndUsageData.
	nodePath := Array 
		with: (settingsBrowser treeHolder nodeNamed: node parentName)
		with: node.
	settingsBrowser selection: (MorphTreeMorphSingleSelection new selectedNodePath: nodePath)
	


"
Class {
	#name : #EREventTool,
	#superclass : #Object,
	#category : #'EventRecorder-Core'
}

{ #category : #accessing }
EREventTool class >> default [
	^ self new
]

{ #category : #configuration }
EREventTool >> defaultDownloadDirectory [
	^ FileSystem disk workingDirectory
]

{ #category : #configuration }
EREventTool >> defaultDownloadFilename [
	^ self defaultDownloadDirectory / 'gt-events.zip'
]

{ #category : #configuration }
EREventTool >> defaultEventsDirectory [
	^ self defaultDownloadDirectory / 'gt' / 'events'
]

{ #category : #private }
EREventTool >> defaultUrl [
	^ 'http://gc.dcc.uchile.cl/gt-events.zip'
]

{ #category : #api }
EREventTool >> download [
	"self default download"
 	UIManager default informUserDuring: [ :bar |
		bar label: 'Downloading Spotter Event Data...'.
		[ ZnClient new
			url: self defaultUrl;
			signalProgress: true;
			downloadTo: self defaultDownloadFilename ]
		on: HTTPProgress 
		do: [ :progress |
			progress isEmpty ifFalse: [ 
				bar current: progress percentage.
				progress total ifNotNil: [ :aTotalNumber | | humanReadable |
					humanReadable := self printHumanReadableSize: aTotalNumber.
					bar label: 'Downloading ', humanReadable, ' of Spotter Event Data... ' ] ].
			progress resume ] 
	]
]

{ #category : #api }
EREventTool >> ensureDownloadedData [
	self defaultDownloadFilename exists ifFalse: [ self download ]
]

{ #category : #api }
EREventTool >> ensureExtractedData [
	self defaultEventsDirectory exists ifFalse: [ self extract ]
]

{ #category : #api }
EREventTool >> ensureLocalDirectory [
	"self default ensureLocalDirectory"
	self 
		ensureDownloadedData;
		ensureExtractedData
]

{ #category : #api }
EREventTool >> extract [
	(ZipArchive new readFrom: self defaultDownloadFilename) extractAllTo: FileLocator workingDirectory.
]

{ #category : #'gt-inspector-extension' }
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

{ #category : #printing }
EREventTool >> printHumanReadableSize: aTotalNumber [
	| humanReadable length unit |
	length := ((aTotalNumber decimalDigitLength / 3) truncated) - 1 max: 0.
	humanReadable := (aTotalNumber / (1024 raisedTo: (length min: 3))) rounded.
	length = 0 ifTrue: [ unit := 'bytes' ].
	length = 1 ifTrue: [ unit := 'KB' ].
	length = 2 ifTrue: [ unit := 'MB' ].
	length = 3 ifTrue: [ unit := 'GB' ].
	^ humanReadable printString, ' ', unit
]

{ #category : #api }
EREventTool >> unpackAll [
	"self default unpackAll inspect"
	self ensureLocalDirectory.
	^ EREventUnpacking default safeUnpackDirectory: self defaultEventsDirectory.
]

{ #category : #api }
EREventTool >> unpackAll: aFileReference [
	"self default unpackAll: './gt/events' asFileReference.
	self default unpackAll: './gt/events/roassal2Examples' asFileReference.
	" 
	self ensureLocalDirectory.
	^ EREventUnpacking default safeUnpackDirectory: aFileReference.
]
