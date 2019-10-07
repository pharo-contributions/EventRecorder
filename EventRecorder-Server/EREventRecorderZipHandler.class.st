"
I know how to handle GET request on /gt/zip?category=categoryName path.
I compress the given category directory and return corresponding ZIP file URL as a HTTP redirect response.

See value:value: method. This is an entry point to a corresponding HTTP request.

I am used by GTEventRecorderDelegate.
"
Class {
	#name : #EREventRecorderZipHandler,
	#superclass : #Object,
	#instVars : [
		'fileDirectory',
		'zipDirectory',
		'zipRootUrl',
		'archiver'
	],
	#category : #'EventRecorder-Server-Core'
}

{ #category : #accessing }
EREventRecorderZipHandler >> archiver [
	"Return an object that is responsible for compressing files."
	^ archiver ifNil: [ archiver := EREventRecorderExternalZipScript new ]
]

{ #category : #accessing }
EREventRecorderZipHandler >> archiver: anObject [
	"Set an object that is responsible for compressing files.
	It should understand #compress: directory method that returns compressed filename."
	^ archiver := anObject
]

{ #category : #accessing }
EREventRecorderZipHandler >> categoryUrlFor: aString [ 
	"Return a public URL for a given category ZIP file."
	^ self zipRootUrl / aString
]

{ #category : #private }
EREventRecorderZipHandler >> compress: aFileReference [ 
	"Compress aFileReference directory and return ZIP file name."
	^ self archiver compress: aFileReference
]

{ #category : #private }
EREventRecorderZipHandler >> compressCategory: aString request: aZnRequest response: aZnResponse [ 
	| directory fileName url |
	directory := self fileDirectory / aString.
	directory exists ifFalse: [ 
			^ aZnResponse 
				statusLine: ZnStatusLine notFound; 
				entity: (ZnEntity textCRLF: 'Category Not Found ', aString asString );
				yourself ].
	fileName := self compress: directory.
	url := self categoryUrlFor: fileName.
	^ aZnResponse 
		statusLine: ZnStatusLine redirect;
		setLocation: url asString;
		entity: (ZnEntity textCRLF: 'Redirect ', url asString);
		yourself
]

{ #category : #accessing }
EREventRecorderZipHandler >> fileDirectory [
	"Return a FileReference object where unpacked data are stored."
	^ fileDirectory
]

{ #category : #accessing }
EREventRecorderZipHandler >> fileDirectory: anObject [
	"Set a FileReference object where unpacked data are stored."
	fileDirectory := anObject asFileReference
]

{ #category : #private }
EREventRecorderZipHandler >> handleGetRequest: aZnRequest response: aZnResponse [ 
	"Handle GET request. aZnRequest should have category value and 
	we should compress a corresponding files and return a ZIP URL."
	| category |
	category := aZnRequest url queryAt: 'category' ifAbsent: [ nil ].
	category ifNil: [	^ aZnResponse
		statusLine: ZnStatusLine badRequest;
		entity: (ZnEntity textCRLF: '?category=<category-name> is missing in ', aZnRequest uri asString);
		yourself ].
	^ self compressCategory: category request: aZnRequest response: aZnResponse.
]

{ #category : #evaluating }
EREventRecorderZipHandler >> value: aZnRequest value: aZnResponse [
	"Process GET request. The other requests are invalid."
	aZnRequest method = #GET ifTrue: [ ^ self handleGetRequest: aZnRequest response: aZnResponse ].
	^ aZnResponse
		statusLine: ZnStatusLine badRequest;
		entity: (ZnEntity textCRLF: 'Only GET is supported in ', aZnRequest uri);
		yourself
]

{ #category : #accessing }
EREventRecorderZipHandler >> zipRootUrl [
	"Return a ZnUrl object from which compressed ZIP files are available on the Internet."
	^ zipRootUrl
]

{ #category : #accessing }
EREventRecorderZipHandler >> zipRootUrl: anObject [
	"Set a ZnUrl object from which compressed ZIP files are available on the Internet."
	zipRootUrl := anObject asZnUrl
]
