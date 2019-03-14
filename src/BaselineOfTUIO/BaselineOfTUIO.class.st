Class {
	#name : #BaselineOfTUIO,
	#superclass : #BaselineOf,
	#category : #BaselineOfTUIO
}

{ #category : #baselines }
BaselineOfTUIO >> baseline: spec [
	<baseline>
	spec
		baseline: 'OSC'
		with: [ spec repository: 'github://Ducasse/OSC' ].
	spec
		for: #pharo
		do: [ 
			spec
				package: 'TUIO-Tests'
				with: [ spec requires: #('Tuio') ].
			spec
				package: 'Tuio'
				with: [ spec requires: #('OSC') ] ]
]
