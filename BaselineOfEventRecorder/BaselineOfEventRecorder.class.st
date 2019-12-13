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
			package: 'GT-EventRecorder';
			package: 'GT-Spotter-EventRecorder';
			package: 'GT-EventRecorder-Tests' ]
]
