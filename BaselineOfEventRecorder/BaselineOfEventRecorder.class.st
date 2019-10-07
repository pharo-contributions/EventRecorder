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
			package: 'EventRecorder' 
			"with: [ spec requires: #('System-Identification' 
													'Compression'  'STON-Core' 'Zinc-HTTP')]".
		spec 
			package: 'EventRecorder-Fuel'
			with: [ spec requires: #( 'EventRecorder' ) ].
			"with: [ spec requires: #( 'Fuel-Core' 'EventRecorder' ) ]."
		spec 
			package: 'EventRecorder-Inspector'
			with: [ spec requires: #( 'EventRecorder' ) ].
		spec 
			package: 'EventRecorder-Help'
			"with: [ spec requires: #( 'EventRecorder' 'HelpSystem-Core') ]."
			with: [ spec requires: #( 'EventRecorder') ].
		spec 
			package: 'EventRecorder-UI'
			with: [ spec requires: #( 'EventRecorder') ].
		spec 
			package: 'EventRecorder-Server'
			with: [ spec requires: #( 'EventRecorder') ].
		
		"should be better done"
		"spec postLoadDoIt: #postLoadActions" 
		spec 
			group: 'Core' with: #('EventRecorder' );
			group: 'All' with: #('EventRecorder' 'EventRecorder-Fuel' 'EventRecorder-UI' 'EventRecorder-Server' 'EventRecorder-Help' 'EventRecorder-Inspector')
		
		]

]
