Class {
	#name : #BaselineOfEventRecorder,
	#superclass : #BaselineOf,
	#category : #BaselineOfEventRecorder
}

{ #category : #baselines }
BaselineOfEventRecorder >> baseline: spec [
  <baseline>
  spec
    for: #common do: [ 
      spec
			package: 'EventRecorder'.
		spec 
			package: 'EventRecorder-Tests'
			with: [ spec requires: #( 'EventRecorder' ) ].
		spec 
			package: 'EventRecorder-Fuel'
			with: [ spec requires: #( 'EventRecorder' ) ].
		spec 
			package: 'EventRecorder-Fuel-Tests'
			with: [ spec requires: #( 'EventRecorder-Fuel' ) ].
		spec 
			package: 'EventRecorder-Inspector'
			with: [ spec requires: #( 'EventRecorder' ) ].
		spec 
			package: 'EventRecorder-Help'
			with: [ spec requires: #( 'EventRecorder') ].
		spec 
			package: 'EventRecorder-UI'
			with: [ spec requires: #( 'EventRecorder') ].
		spec 
			package: 'EventRecorder-UI-Tests'
			with: [ spec requires: #( 'EventRecorder-UI') ].
		spec 
			package: 'EventRecorder-Server'
			with: [ spec requires: #( 'EventRecorder') ].
		spec 
			package: 'EventRecorder-Server-Tests'
			with: [ spec requires: #( 'EventRecorder-Server') ].
		
		spec 
			group: 'Core' with: #('EventRecorder' );
			group: 'default' with: #('EventRecorder-Tests' 'EventRecorder-Fuel-Tests' 'EventRecorder-UI-Tests' 'EventRecorder-Server-Tests' 'EventRecorder-Help' 'EventRecorder-Inspector')
		
		]

]
