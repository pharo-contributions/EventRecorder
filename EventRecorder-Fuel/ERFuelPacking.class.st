"
I serialize or materialize objects using FUEL framework. Create instance of me calling GTEventPacking fuel.
"
Class {
	#name : #ERFuelPacking,
	#superclass : #EREventPacking,
	#instVars : [
		'migrations'
	],
	#category : #'EventRecorder-Fuel'
}

{ #category : #adding }
ERFuelPacking >> addMigration: oneArgBlock [ 
	^ self migrations addLast: oneArgBlock
]

{ #category : #initialization }
ERFuelPacking >> initializeMaterializer: aFLMaterializer [ 
	self migrations do: [ :eachMigration | eachMigration value: aFLMaterializer ]
]

{ #category : #initialization }
ERFuelPacking >> initializeMigrations [
	| pragmas |
	pragmas := Pragma allNamed: #fuelMaterializerMigration in: self class.
	migrations := pragmas
		collect: [ :eachPragma | self perform: eachPragma methodSelector ]
		as: OrderedCollection
]

{ #category : #private }
ERFuelPacking >> materialize: aByteArray [
	| materializer stream gzstream materialization |
	stream := aByteArray asByteArray readStream. 
	gzstream := GZipReadStream on: stream.
	materializer := FLMaterializer newDefault.
	self initializeMaterializer: materializer.
	materialization := materializer materializeFrom: gzstream.
	gzstream close.
	stream close.
	^ materialization root.
]

{ #category : #accessing }
ERFuelPacking >> migrations [
	migrations ifNil: [ self initializeMigrations ].
	^ migrations
]

{ #category : #accessing }
ERFuelPacking >> migrations: aCollectionOrNil [
	migrations := aCollectionOrNil
]

{ #category : #private }
ERFuelPacking >> serialize: anObject [
	| serializer stream gzstream |
	stream := ByteArray new writeStream binary. 
	gzstream := GZipWriteStream on: stream.
	serializer := FLSerializer newDefault.
	serializer at: #recorderVersion putAdditionalObject: self version.
	serializer stream: gzstream.
	serializer serialize: anObject.
	gzstream close.
	stream close.
	^ stream contents.
]

{ #category : #accessing }
ERFuelPacking >> technologyName [
	^ 'fuel'
]
