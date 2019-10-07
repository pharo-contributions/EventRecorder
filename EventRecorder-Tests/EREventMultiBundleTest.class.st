"
A GTEventMultiBundleTest is a test class for testing the behavior of GTEventMultiBundle
"
Class {
	#name : #EREventMultiBundleTest,
	#superclass : #TestCase,
	#instVars : [
		'bundle1',
		'bundle2',
		'bundle3',
		'multiBundle',
		'entity'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #running }
EREventMultiBundleTest >> setUp [
	super setUp.
	bundle1 := EREventBundle new 
		url: 'http://localhost/gt/events1' asZnUrl; category: #c1; data: #[1 2 3]; yourself.
	bundle2 := EREventBundle new 
		url: 'http://localhost/gt/events1' asZnUrl; category: #c1; data: #[4 5 6]; yourself.
	bundle3 := EREventBundle new 
		url: 'http://localhost/gt/events1' asZnUrl; category: #c2; data: #[7 8 9]; yourself.
	multiBundle := EREventMultiBundle new.

]

{ #category : #tests }
EREventMultiBundleTest >> testEntity [
	self assert: multiBundle entity isEmpty
]

{ #category : #tests }
EREventMultiBundleTest >> testEntity2 [
	multiBundle add: bundle1.
	entity := multiBundle entity.
	self deny: entity isEmpty.
	self assert: entity parts size equals: 2.
	self assert: entity parts first fieldName equals: 'category'.
	self assert: entity parts second fieldName equals: 'data'.
	self assert: entity parts first fieldValue equals: #c1.
	self assert: entity parts second fieldValue equals: #[1 2 3].
	
]

{ #category : #tests }
EREventMultiBundleTest >> testEntity3 [
	multiBundle add: bundle1; add: bundle2.
	entity := multiBundle entity.
	self deny: entity isEmpty.
	self assert: entity parts size equals: 4.
	self assert: entity parts first fieldName equals: 'category'.
	self assert: entity parts second fieldName equals: 'data'.
	self assert: entity parts third fieldName equals: 'category'.
	self assert: entity parts fourth fieldName equals: 'data'.
	self assert: entity parts first fieldValue equals: #c1.
	self assert: entity parts second fieldValue equals: #[1 2 3].
	self assert: entity parts third fieldValue equals: #c1.
	self assert: entity parts fourth fieldValue equals: #[4 5 6].

]

{ #category : #tests }
EREventMultiBundleTest >> testEntity4 [
	multiBundle add: bundle1; add: bundle2; add: bundle3.
	entity := multiBundle entity.
	self deny: entity isEmpty.
	self assert: entity parts size equals: 6.
	self assert: entity parts first fieldName equals: 'category'.
	self assert: entity parts second fieldName equals: 'data'.
	self assert: entity parts third fieldName equals: 'category'.
	self assert: entity parts fourth fieldName equals: 'data'.
	self assert: entity parts fifth fieldName equals: 'category'.
	self assert: entity parts sixth fieldName equals: 'data'.
	self assert: entity parts first fieldValue equals: #c1.
	self assert: entity parts second fieldValue equals: #[1 2 3].
	self assert: entity parts third fieldValue equals: #c1.
	self assert: entity parts fourth fieldValue equals: #[4 5 6].
	self assert: entity parts fifth fieldValue equals: #c2.
	self assert: entity parts sixth fieldValue equals: #[7 8 9].

]
