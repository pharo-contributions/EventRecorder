"
I know how to create GTEventMultiBundle object from a collection of GTEventBundle objects.
"
Class {
	#name : #EREventMultiBundleFactory,
	#superclass : #Object,
	#instVars : [
		'multiBundles'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #accessing }
EREventMultiBundleFactory class >> default [
	^ self new
]

{ #category : #public }
EREventMultiBundleFactory class >> fromBundles: aCollection [ 
	^ self default fromBundles: aCollection
]

{ #category : #public }
EREventMultiBundleFactory >> fromBundles: aCollection [ 
	multiBundles := OrderedDictionary new.
	aCollection do: [ :aSingleOrMultiBundle | self synthetize: aSingleOrMultiBundle.].
	^ self multiBundles
]

{ #category : #accessing }
EREventMultiBundleFactory >> multiBundles [
	^ multiBundles asOrderedCollection
]

{ #category : #private }
EREventMultiBundleFactory >> synthetize: aSingleOrMultiBundle [
	aSingleOrMultiBundle accept: self
]

{ #category : #visitor }
EREventMultiBundleFactory >> visitMultiBundle: aMultiBundle [
	aMultiBundle bundles do: [ :eachSingleBundle |
		self visitSingleBundle: eachSingleBundle ]
]

{ #category : #visitor }
EREventMultiBundleFactory >> visitSingleBundle: aSingleBundle [
	| multiBundle |
	multiBundle := multiBundles 
							at: aSingleBundle url 
							ifAbsentPut: [ aSingleBundle newMultiBundle url: aSingleBundle url; yourself ].
	multiBundle add: aSingleBundle
]
