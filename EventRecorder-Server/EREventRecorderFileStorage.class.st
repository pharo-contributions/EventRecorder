Class {
	#name : #EREventRecorderFileStorage,
	#superclass : #Object,
	#instVars : [
		'directory'
	],
	#category : #'EventRecorder-Server'
}

{ #category : #accessing }
EREventRecorderFileStorage >> atCategory: aString put: aByteArray [
	| subDirectory date monthDirectoryName monthDirectory fileName file |
	subDirectory := (self directory / aString) ensureCreateDirectory; yourself.
	date := Date today.
	monthDirectoryName := date year printString, (date month index printStringBase: 10 nDigits: 2).
	monthDirectory := subDirectory / monthDirectoryName.
	monthDirectory ensureCreateDirectory.
	fileName := UUID new printString.
	file := monthDirectory / fileName.
	file exists ifTrue: [ 
		fileName := fileName, '-time-', DateAndTime now asUnixTime printString.
		file := monthDirectory / fileName ].
	file ensureDelete.
	file binaryWriteStreamDo: [ :aStream | aStream nextPutAll: aByteArray ].
	^ aString, '/', monthDirectoryName, '/', fileName
]

{ #category : #accessing }
EREventRecorderFileStorage >> directory [
	^ directory
]

{ #category : #accessing }
EREventRecorderFileStorage >> directory: anObject [
	directory := anObject
]

{ #category : #accessing }
EREventRecorderFileStorage >> put: aByteArray [
	^ self atCategory: #unspecified put: aByteArray
]
