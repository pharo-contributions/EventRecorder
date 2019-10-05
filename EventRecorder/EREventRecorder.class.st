"
I represent an event recorder, an object that collects data and regularly sends them to a server. The data could represent user activity, tool usage, or any other statistic usefule for further analysis. 

I cover data collectors, packing, and delivery objects the way they cooperate together and the collected data are regularly send to server(s). It is not mandatory, but it is supposed that I represent a Singleton pattern.

I collaborate with GTEventCollector objects, that are responsible for collecting data. I keep any number of those objects and whenever GTEventDelivery asks me for collected data, GTEventPacking object packs data from each GTEventCollector and hand them as collection of GTEventBundle objects to the GTEventDelivery. GTEventDelivery sends the bundles to server(s).

Public API and Key Messages

- addCollector: it adds GTEventCollector object and activates delivery process if inactive   
- removeCollector: it removes  GTEventCollector object and deactivates delivery process if there are no other collectors.
- activateDelivery: activates delivery process
- deactivateDelivery: deactivates delivery process

Internal Representation and Key Implementation Points.

    Instance Variables
	announcer:		<Annoucner>
	collectors:		<GTEventCollectors>
	delivery:		<GTEventDelivery>
	packing:		<GTEventPacking>
	privacy:		<true|false|ClosureBlock>

"
Class {
	#name : #EREventRecorder,
	#superclass : #Object,
	#instVars : [
		'collectors',
		'delivery',
		'packing',
		'privacy',
		'announcer'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'EventRecorder-Core'
}

{ #category : #cleanup }
EREventRecorder class >> cleanUp [
	self reset.
]

{ #category : #initialization }
EREventRecorder class >> initializeUniqueInstance [
	uniqueInstance ifNotNil: [ ^ uniqueInstance ].
	uniqueInstance := self new.
	self registerInterestToSystemAnnouncement.
	^ uniqueInstance
]

{ #category : #testing }
EREventRecorder class >> isGlobalRecorder: aGTEventRecorder [
	^ uniqueInstance 
			ifNil: false
			ifNotNil: [ :anInstance | anInstance == aGTEventRecorder  ]
]

{ #category : #initialization }
EREventRecorder class >> registerInterestToSystemAnnouncement [
	<systemEventRegistration>
	
	uniqueInstance ifNil: [ ^ self ].
	SystemAnnouncer uniqueInstance
		unsubscribe: uniqueInstance.
	SystemAnnouncer uniqueInstance weak 
			when: ERPrivacyChangedAnnouncement
			send: #privacyChanged 
			to: uniqueInstance
]

{ #category : #initialization }
EREventRecorder class >> reset [
	"Stop and remove the process for sending usage data. Delete all recorder that from the queue."
	uniqueInstance ifNil: [ ^ self ].
	SystemAnnouncer uniqueInstance unsubscribe: uniqueInstance.
	uniqueInstance deactivateDelivery ifNotNil: [ :aProcess | 
			[ aProcess terminate ] on: Error do: [ "ignore error" ] ].
	uniqueInstance := nil.
]

{ #category : #accessing }
EREventRecorder class >> uniqueInstance [
	uniqueInstance ifNil: [ self initializeUniqueInstance ].
	^ uniqueInstance
]

{ #category : #delivery }
EREventRecorder >> activateDelivery [
	^ delivery activate
]

{ #category : #delivery }
EREventRecorder >> activateDeliveryIfAvailable [
	^ self canSendDiagnosticsAndUsageData 
		ifTrue: [ self activateDelivery ]
		ifFalse: [ nil ]
]

{ #category : #adding }
EREventRecorder >> addCollector: aGTEventCollector [
	self activateDeliveryIfAvailable.
	^ collectors add: aGTEventCollector
]

{ #category : #accessing }
EREventRecorder >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #testing }
EREventRecorder >> canSendDiagnosticsAndUsageData [
	^ privacy value
]

{ #category : #delivery }
EREventRecorder >> deactivateDelivery [
	^ delivery deactivate
]

{ #category : #delivery }
EREventRecorder >> deliverNow [
	delivery now
]

{ #category : #accessing }
EREventRecorder >> delivery [
	"Testing purpose."
	^ delivery
]

{ #category : #configuration }
EREventRecorder >> deliveryPreSuspendingAction: aBlockClosure [ 
	self delivery preSuspendingAction: aBlockClosure
]

{ #category : #packing }
EREventRecorder >> flush [
	"Be careful! You will lost all data."
	collectors do: #flush
]

{ #category : #'gt-inspector-extension' }
EREventRecorder >> gtInspectorActionHelp [
	<gtInspectorAction>
	^ GLMGenericAction new
		action: [:b | 
		HelpBrowser open selectTopicSatisfying: [:each |
			each owner notNil and:  [
			(each owner key = EREventRecorderHelp key) and: [
				each title = 'Client' ] ] ] ];
		icon: GLMUIThemeExtraIcons glamorousHelp;
		title: 'Help'
]

{ #category : #'gt-inspector-extension' }
EREventRecorder >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 1>
	^ collectors ifNotNil: [ 
			(collectors gtInspectorItemsIn: composite) ]
]

{ #category : #initialization }
EREventRecorder >> initialize [
	super initialize.
	privacy := [ ERPrivacy sendDiagnosticsAndUsageData ].
	collectors := EREventCollectors new.
	delivery := EREventDelivery new.
	delivery recorder: self.
	packing := EREventPacking default.
	self canSendDiagnosticsAndUsageData 
			ifTrue: [ delivery offerPermission ]
			ifFalse: [ delivery withdrawPermission ]
]

{ #category : #testing }
EREventRecorder >> isDeliveryActive [
	^ delivery isActive
]

{ #category : #testing }
EREventRecorder >> isGlobalRecorder [
	^ self class isGlobalRecorder: self
]

{ #category : #convenient }
EREventRecorder >> numberOfCollectors [
	^ collectors size
]

{ #category : #convenient }
EREventRecorder >> numberOfDeliveryData [
	^ delivery size
]

{ #category : #configuration }
EREventRecorder >> offerDeliveryPermission [
	delivery offerPermission
]

{ #category : #configuration }
EREventRecorder >> offerPrivacy [
	"testing purpose"
	privacy := true
]

{ #category : #packing }
EREventRecorder >> pack [
	| allCollectors consolidatedCollectors |
	self canSendDiagnosticsAndUsageData ifFalse: [ ^ self flush; yourself ].
	allCollectors := OrderedCollection new: collectors size.
	collectors do: [ :eachCollector | allCollectors addLast: eachCollector ].
	consolidatedCollectors := EREventConsolidate new collectors: allCollectors; consolidated.
	consolidatedCollectors do: [ :eachCollector | | bundle |
		eachCollector size > 0 ifTrue: [ 
			bundle := packing pack: eachCollector.
			delivery add: bundle] ].
	self removeLiberatedCollectors.
]

{ #category : #'event handling' }
EREventRecorder >> privacyChanged [
	self canSendDiagnosticsAndUsageData 
		ifTrue: [ self numberOfCollectors > 0 
						ifTrue: [ self activateDelivery ] ]
		ifFalse: [ self deactivateDelivery ]
]

{ #category : #removing }
EREventRecorder >> removeCollector: aGTEventCollector [ 
	| removedCollector |
	removedCollector := collectors remove: aGTEventCollector.
	collectors size = 0 ifTrue: [ self deactivateDelivery ].
	^ removedCollector
]

{ #category : #removing }
EREventRecorder >> removeLiberatedCollectors [
	collectors removeLiberatedCollectors
]

{ #category : #configuration }
EREventRecorder >> withdrawDeliveryPermission [
	delivery withdrawPermission
]

{ #category : #configuration }
EREventRecorder >> withdrawPrivacy [
	"testing purpose"
	privacy := false
]
