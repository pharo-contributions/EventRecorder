"
I represent a basic event for the event recorder.
"
Class {
	#name : #ERBasicRecorderEvent,
	#superclass : #Object,
	#instVars : [
		'info',
		'timestamp'
	],
	#category : #'EventRecorder-Core'
}

{ #category : #comparing }
ERBasicRecorderEvent >> = otherEvent [

	^ self class == otherEvent class
	and: [ (self info = otherEvent info)
	and: [ self timestamp = otherEvent timestamp ] ].
]

{ #category : #'accessing - announcement info' }
ERBasicRecorderEvent >> announcementTimestamp [
	^ self infoAt: #timestamp ifAbsent: [ self timestamp ]
]

{ #category : #'accessing - announcement info' }
ERBasicRecorderEvent >> computerUUID [
	^ self infoAt: #computerUUID ifAbsent: [ ERGlobalIdentifier uniqueInstance computerUUID asString ]
]

{ #category : #'accessing - announcement info' }
ERBasicRecorderEvent >> eventRecorderVersion [
	^ self infoAt: #eventRecorderVersion ifAbsent: [ EREventPacking new version ]
]

{ #category : #comparing }
ERBasicRecorderEvent >> hash [
	^ self info hash bitXor: self timestamp hash
]

{ #category : #accessing }
ERBasicRecorderEvent >> hashForText: aString [
	^ self settings obfuscateIfNecessary: aString
]

{ #category : #'accessing - announcement info' }
ERBasicRecorderEvent >> imageHash [
	^ self infoAt: #imageHash ifAbsent: [ SmalltalkImage current imagePath hash ]
]

{ #category : #'accessing - announcement info' }
ERBasicRecorderEvent >> imageVersion [
	^ self infoAt: #imageVersion ifAbsent: [ SystemVersion current version ]
]

{ #category : #accessing }
ERBasicRecorderEvent >> info [
	^ info ifNil: [ info := Dictionary new ].
]

{ #category : #accessing }
ERBasicRecorderEvent >> infoAt: aSymbol [
	^ info at: aSymbol
]

{ #category : #accessing }
ERBasicRecorderEvent >> infoAt: key ifAbsent: absentBlock [
	info ifNil: [ ^ absentBlock value].
	^ info at: key ifAbsent: absentBlock
]

{ #category : #accessing }
ERBasicRecorderEvent >> infoAt: key ifAbsentPut: putBlock [
	info ifNil: [ info := Dictionary new ].
	^ info at: key ifAbsentPut: putBlock
]

{ #category : #accessing }
ERBasicRecorderEvent >> infoAt: key ifPresent: presentBlock ifAbsent: absentBlock [
	info ifNil: [ ^ absentBlock value].
	^ info at: key ifPresent: presentBlock ifAbsent: absentBlock
]

{ #category : #accessing }
ERBasicRecorderEvent >> infoAt: key put: value [
	info ifNil: [ info := Dictionary new ].
	^ info at: key put: value
]

{ #category : #accessing }
ERBasicRecorderEvent >> infoAt: key putHashForText: valueString [ 
	^ self 
		infoAt: key 
		put: (self hashForText: valueString)
]

{ #category : #initialization }
ERBasicRecorderEvent >> initialize [
	super initialize.
	timestamp := DateAndTime now.
]

{ #category : #initialization }
ERBasicRecorderEvent >> initializeObfuscated [
	self obfuscated: ERPrivacy sendEntityNames not.
]

{ #category : #'accessing - announcement info' }
ERBasicRecorderEvent >> latestUpdate [
	^ self infoAt: #latestUpdate ifAbsent: [ SystemVersion current highestUpdate ]
]

{ #category : #accessing }
ERBasicRecorderEvent >> obfuscated [
	^ self infoAt: #obfuscated ifAbsent: true
]

{ #category : #accessing }
ERBasicRecorderEvent >> obfuscated: aBoolean [
	^ self infoAt: #obfuscated put: aBoolean
]

{ #category : #'accessing - announcement info' }
ERBasicRecorderEvent >> sessionCreationTime [
	^ self infoAt: #sessionCreationTime ifAbsent: [ SmalltalkImage current session creationTime ]
]

{ #category : #accessing }
ERBasicRecorderEvent >> settings [
	^ ERGlobalIdentifier uniqueInstance
]

{ #category : #accessing }
ERBasicRecorderEvent >> timestamp [
	^ timestamp
]
