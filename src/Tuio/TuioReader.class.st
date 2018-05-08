"
I am reading stream simulating tuio events for reproductibility purpose
"
Class {
	#name : #TuioReader,
	#superclass : #TuioClient,
	#instVars : [
		'stream',
		'semaphore'
	],
	#category : #Tuio
}

{ #category : #'as yet unclassified' }
TuioReader class >> read: aFileName [
	^ self singleInstance 
		read: aFileName;
		yourself
]

{ #category : #'osc server access' }
TuioReader >> nextMessage [
	| message |

	message := self stream nextLine.
	^ message 
		ifNil: [ self stop. nil ]
		ifNotNil: [ Compiler evaluate: message ]
]

{ #category : #protocol }
TuioReader >> read: aFileName [

	stream := (FileSystem workingDirectory resolve: aFileName) readStream.
]

{ #category : #'osc server access' }
TuioReader >> start [
	semaphore := Semaphore new.
	stream position: 0.
	super start.
	semaphore wait
]

{ #category : #'osc server access' }
TuioReader >> stop [
	semaphore signal.
	super stop.
	
	
]

{ #category : #accessing }
TuioReader >> stream [
	^ stream ifNil: [ stream := '' readStream ]
]

{ #category : #accessing }
TuioReader >> stream: anObject [
	stream := anObject
]
