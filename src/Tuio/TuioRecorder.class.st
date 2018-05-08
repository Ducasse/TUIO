"
I am used to record Tuio sequences for reproductability purpose
"
Class {
	#name : #TuioRecorder,
	#superclass : #TuioClient,
	#instVars : [
		'record',
		'started',
		'received',
		'semaphore'
	],
	#category : #TUIO
}

{ #category : #recording }
TuioRecorder class >> recordNextGesture [

	^ self singleInstance recordNextGesture
]

{ #category : #recording }
TuioRecorder class >> recordNextGestureInto: aFileName [
 	| string file |
	
	string := self singleInstance recordNextGesture.
	
	file := (FileSystem workingDirectory resolve: aFileName).
	file ensureFile.
	file writeStreamDo: [:s | s nextPutAll: string ]
]

{ #category : #recording }
TuioRecorder >> drive [
	| msgArray |
	
	received := false.
	msgArray := self oscServer nextMessage.
	started := true.
	received := true.
	record 
		nextPutAll: msgArray asString;
		cr.

]

{ #category : #recording }
TuioRecorder >> recordNextGesture [

	started:= false.
	record := ReadWriteStream on: ''.
	self start.
	
	semaphore wait.
	^ record contents.
]

{ #category : #recording }
TuioRecorder >> start [

	super start.
	semaphore := Semaphore new.
	[ [ isRunning ] whileTrue: [
		0.5 seconds asDelay wait.
		(received not and: started) ifTrue: [ self stop ] ] ] fork.

]

{ #category : #recording }
TuioRecorder >> stop [

	super stop.
	semaphore signal.
]
