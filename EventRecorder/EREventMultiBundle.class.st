"
I keep all GTEventBundle objects that should be delivered to the same remote server. That way, all data can be sent to the server at one HTTP request.

By calling #entity, you receive ZnMultiPartFormDataEntity object that contains ZnMimePart objects in a sequence 'category', 'data', 'category', 'data', etc. Server is then responsible for spliting this object into the parts and store each data in to a right position (directory).

For the Collaborators Part: 
- GTEventBundle: I keep collection of those objects and asks them for a ZnEntity object calling #entity.
- GTEventMultiBundleFactory knows how to create instances.
- GTEventDelivery knows how to send my #entity to a server.

Internal Representation and Key Implementation Points.

    Instance Variables
	bundles:		<Collection>
	url:			<ZnUrl>

"
Class {
	#name : #EREventMultiBundle,
	#superclass : #Object,
	#instVars : [
		'url',
		'bundles'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #visitor }
EREventMultiBundle >> accept: aVisitor [ 
	^ aVisitor visitMultiBundle: self
]

{ #category : #adding }
EREventMultiBundle >> add: aGTEventBundle [ 
	^ self bundles addLast: aGTEventBundle
]

{ #category : #accessing }
EREventMultiBundle >> bundles [
	^ bundles ifNil: [ bundles := OrderedCollection new ]
]

{ #category : #accessing }
EREventMultiBundle >> entity [
	| entity |
	entity := ZnMultiPartFormDataEntity new.
	self updateEntity: entity.
	^ entity
]

{ #category : #private }
EREventMultiBundle >> updateEntity: aZnMultiPartFormDataEntity [

	bundles ifNil: [ ^ self ].
	self bundles do: [ :eachEventBundle | 
		self
			updateEntity: aZnMultiPartFormDataEntity
			forSingleBundle: eachEventBundle ]
]

{ #category : #private }
EREventMultiBundle >> updateEntity: aZnMultiPartFormDataEntity forSingleBundle: aSingleBundle [

	aZnMultiPartFormDataEntity
		addPart:
			(ZnMimePart fieldName: 'category' value: aSingleBundle category);
		addPart: (ZnMimePart fieldName: 'data' entity: aSingleBundle entity)
]

{ #category : #accessing }
EREventMultiBundle >> url [
	^ url
]

{ #category : #accessing }
EREventMultiBundle >> url: anObject [
	url := anObject
]
