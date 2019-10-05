"
I represent data that are sent to a server.

When GTEventPacking object asks for data to send, the data are packed and added to #data:, then there are other general information about the bundle, e.g. computer id. I keep all those information. I can also unpack the data using #unpackedData.

For the simple backward compatibility, all my data are stored in a dictionary.

For the Collaborators Part:  
- GTEventCollector creates instance of me and adds additional information about sent data, see GTEventCollector>>#updateAnnouncement:
- GTEventPacking serialize #data and me in order to send me to a server

Public API and Key Messages

- unpackedData   
 
Internal Representation and Key Implementation Points.

    Instance Variables
	dictionary:		<Dictionary>

"
Class {
	#name : #EREventAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'dictionary'
	],
	#category : #'EventRecorder-Announcements'
}

{ #category : #examples }
EREventAnnouncement class >> gtExampleAnnouncement [
	<gtExample>
	^ self new
			data: #[ 1 2 3 4 ];
			timestamp: DateAndTime now;
			imageHash: SmalltalkImage current imagePath hash;
			sessionCreationTime: SmalltalkImage current session creationTime;
			imageVersion: SystemVersion current version;
			latestUpdate: SystemVersion current highestUpdate;
			yourself
]

{ #category : #examples }
EREventAnnouncement class >> gtExampleEmptyAnnouncement [
	<gtExample>
	^ self new
]

{ #category : #updating }
EREventAnnouncement >> addInfoFor: aGTSpotterRecorderEvent [ 
	(aGTSpotterRecorderEvent respondsTo: #infoAt:put:) ifTrue: [
		dictionary keysAndValuesDo: [ :key :value |
			key = #data ifFalse: [ 
				aGTSpotterRecorderEvent infoAt: key put: value ] ] ]
]

{ #category : #converting }
EREventAnnouncement >> associations [
	^ dictionary 
			ifNil: [ #() ]
			ifNotNil: [ dictionary associations ]
]

{ #category : #accessing }
EREventAnnouncement >> at: key [
	^ self dictionary at: key ifAbsent: [ nil ]
]

{ #category : #accessing }
EREventAnnouncement >> at: key put: value [
	^ self dictionary at: key put: value
]

{ #category : #accessing }
EREventAnnouncement >> category [
	^ self at: #category
]

{ #category : #accessing }
EREventAnnouncement >> category: aSymbol [
	^ self at: #category put: aSymbol
]

{ #category : #accessing }
EREventAnnouncement >> computerUUID [
	^ self at: #computerUUID
]

{ #category : #accessing }
EREventAnnouncement >> computerUUID: anObject [
	self at: #computerUUID put: anObject
]

{ #category : #accessing }
EREventAnnouncement >> data [
	^ self at: #data
]

{ #category : #accessing }
EREventAnnouncement >> data: aByteArray [ 
	self at: #data put: aByteArray
]

{ #category : #accessing }
EREventAnnouncement >> dictionary [
	^ dictionary ifNil: [ dictionary := Dictionary new ]
]

{ #category : #accessing }
EREventAnnouncement >> eventRecorderVersion [
	^ self at: #eventRecorderVersion
]

{ #category : #accessing }
EREventAnnouncement >> eventRecorderVersion: anObject [
	self at: #eventRecorderVersion put: anObject
]

{ #category : #accessing }
EREventAnnouncement >> events [
	| events |
	events := self unpackedData.
	events do: [ :each | self addInfoFor: each ].
	^ events
]

{ #category : #'gt-inspector-extension' }
EREventAnnouncement >> gtInspectorActionUnpackData [
	<gtInspectorAction>
	^ GLMGenericAction new
		action: [ :composite |
			composite selection: self unpackedData ];
		icon: GLMUIThemeExtraIcons glamorousAdd;
		condition: [ self data isNotNil ];
		title: 'Unpack data'
]

{ #category : #'gt-inspector-extension' }
EREventAnnouncement >> gtInspectorItems [
	^ OrderedCollection withAll: self associations
]

{ #category : #'gt-inspector-extension' }
EREventAnnouncement >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: -1>  
	^ (composite table)
		title: 'Info';
		display: [ :anEvent | anEvent gtInspectorItems ];
		children: [ :each | 
			(each value isDictionary) 
				ifTrue: [ each value associations ] 
				ifFalse: [ (each value isArray and: [ each value allSatisfy: #isDictionary ])
						ifTrue: [ each value collectWithIndex: [:x :i | i -> x ] ]
						ifFalse: [ #() ] ] ];
		column: 'Key' 
			evaluated: [:each | GTObjectPrinter asTruncatedTextFrom: each key ];
		column: 'Value' 
			evaluated: [:each | GTObjectPrinter asTruncatedTextFrom: each value ];
		showOnly: 50
]

{ #category : #accessing }
EREventAnnouncement >> imageHash [
	^ self at: #imageHash
]

{ #category : #accessing }
EREventAnnouncement >> imageHash: anObject [
	self at: #imageHash put: anObject
]

{ #category : #accessing }
EREventAnnouncement >> imageVersion [
	^ self at: #imageVersion
]

{ #category : #accessing }
EREventAnnouncement >> imageVersion: anObject [
	self at: #imageVersion put: anObject
]

{ #category : #accessing }
EREventAnnouncement >> latestUpdate [
	^ self at: #latestUpdate
]

{ #category : #accessing }
EREventAnnouncement >> latestUpdate: anObject [
	self at: #latestUpdate put: anObject
]

{ #category : #accessing }
EREventAnnouncement >> migrationRules [
	^ self dictionary at: #migrationRules ifAbsent: [ nil ]
]

{ #category : #accessing }
EREventAnnouncement >> migrationRules: aCollectionOrNil [
	^ self dictionary at: #migrationRules put: aCollectionOrNil
]

{ #category : #accessing }
EREventAnnouncement >> safeUnpackedData [
	"On any error, returns empty collection"
	^ [ self unpackedData ] on: Error do: [ #() ]
]

{ #category : #accessing }
EREventAnnouncement >> serializedBy [
	^ self dictionary at: #serializedBy ifAbsent: [ ERFuelPacking name ]
]

{ #category : #accessing }
EREventAnnouncement >> serializedBy: anObject [
	self at: #serializedBy put: anObject
]

{ #category : #accessing }
EREventAnnouncement >> sessionCreationTime [
	^ self at: #sessionCreationTime
]

{ #category : #accessing }
EREventAnnouncement >> sessionCreationTime: anObject [
	self at: #sessionCreationTime put: anObject
]

{ #category : #accessing }
EREventAnnouncement >> sessionUUID [
	^ self at: #sessionUUID
]

{ #category : #accessing }
EREventAnnouncement >> sessionUUID: anObject [
	self at: #sessionUUID put: anObject
]

{ #category : #accessing }
EREventAnnouncement >> timestamp [
	^ self at: #timestamp
]

{ #category : #accessing }
EREventAnnouncement >> timestamp: anObject [
	self at: #timestamp put: anObject
]

{ #category : #accessing }
EREventAnnouncement >> unpackedData [
	^ self data ifNotNil: [ :aData | 
		(self class environment at: self serializedBy) new
			migrations: self migrationRules;
			unpack: aData ]
]
