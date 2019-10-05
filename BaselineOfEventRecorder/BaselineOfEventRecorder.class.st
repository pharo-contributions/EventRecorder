Class {
	#name : #BaselineOfEventRecorder,
	#superclass : #BaselineOf,
	#category : #BaselineOfEventRecorder
}

{ #category : #baselines }
BaselineOfEventRecorder >> baseline: spec [
  <baseline>
  spec
    for: #(common)
    do: [ 
      spec
			package: 'EventRecorder' 
			with: [ spec requires: #('System-Identification' 
													'Compression' 'Fuel-Core' 'STON-Core' 'Zinc-HTTP' 'Help-Core') ]    
		"should be better done"
		"spec postLoadDoIt: #postLoadActions" ]

]
