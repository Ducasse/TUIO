"
I am in charge of generating tuio events for tuioClient
"
Class {
	#name : #TuioClientSimulator,
	#superclass : #Object,
	#instVars : [
		'tuioClient'
	],
	#category : #TUIO
}

{ #category : #'simulating-private' }
TuioClientSimulator >> execute: aBlock [

	[ 
		aBlock value.
		0.5 seconds asDelay wait.
		self removeAllBlobs ] fork
]

{ #category : #'simulating-private' }
TuioClientSimulator >> execute: aBlock from: start to: stop [

	self execute: aBlock from: start to: stop by: 1
]

{ #category : #'simulating-private' }
TuioClientSimulator >> execute: aBlock from: start to: stop by: offset [

	[ 
		start to:stop by:offset do: [ :i |
			0.05 seconds asDelay wait.
			aBlock value: i ].
		self removeAllBlobs ] fork.
]

{ #category : #protocol }
TuioClientSimulator >> removeAllBlobs [
	"Remove all of the blobs"
	
	self tuioClient removeAllBlobs
]

{ #category : #protocol }
TuioClientSimulator >> set2D: aBlobId x: x y: y X: X Y: Y m: m [

	self tuioClient set2D: aBlobId x: x y: y X: X Y: Y m: m
]

{ #category : #protocol }
TuioClientSimulator >> set: aBlobId x: x y: y [
	
	self tuioClient set: aBlobId x: x y: y
]

{ #category : #protocol }
TuioClientSimulator >> setAlive: blobIdList [

	self tuioClient setAlive: blobIdList
]

{ #category : #simulating }
TuioClientSimulator >> simulateDoubleClick [
	"Send one point, remove it and send an new point to make a double click."
	
	self setAlive: {1}.
	self set: 1 x: 0.5 y: 0.5.
	
	self setAlive: {2}.
	self set: 2 x: 0.5 y: 0.5.
]

{ #category : #simulating }
TuioClientSimulator >> simulateDrag [
	"Send two points and modify their positions to the TUIOClient  in order to simulate a left scroll."
	
	| blobsId |
	blobsId := {1}.
	self setAlive: blobsId.
	75 to: 25 by: -1 do: [ :i |
		self set: blobsId first x: 0.01*i  y: 0.4 ].
]

{ #category : #simulating }
TuioClientSimulator >> simulateOneFingerClick [
	"Send one point to the TUIOClient  in order to simulate a simple click."
	
	self setAlive: {1}.
	self set: 1 x: 0.5 y: 0.5.
]

{ #category : #simulating }
TuioClientSimulator >> simulatePinchIn [
	"Send two points and modify their positions to the TUIOClient  in order to simulate a scroll top."
	
	| blobsId |
	blobsId := {1 . 2}.
	self setAlive: blobsId.
	45 to: 1 by: -1 do: [ :i |
		self set: blobsId first x: 0.01*i y: 0.4 .
		self set: blobsId second x: (1-0.01*i)  y: 0.4 . ].
]

{ #category : #simulating }
TuioClientSimulator >> simulateScrollDown [
	"Send two points and modify their positions to the TUIOClient  in order to simulate a down scroll."
	
	| blobsId |
	blobsId := {1 . 2}.
	self setAlive: blobsId.
	1 to: 90 do: [ :i |
		self set: blobsId first x: 0.4  y: 0.01*i.
		self set: blobsId second x: 0.6  y: 0.01*i. ].
]

{ #category : #simulating }
TuioClientSimulator >> simulateScrollLeft [

	"Send two points and modify their positions to the TUIOClient  in order to simulate a left scroll."
	
	| blobsId |
	
	blobsId := {1 . 2}.
	
	self setAlive: blobsId.
	
	90 to: 1 by: -1 do: [ :i |
		self set: blobsId first x: 0.01*i  y: 0.4.
		self set: blobsId second x: 0.01*i  y: 0.6. ].
]

{ #category : #simulating }
TuioClientSimulator >> simulateScrollRight [
	"Send two points and modify their positions to the TUIOClient  in order to simulate a right scroll."

	| blobsId |
	blobsId := {1 . 2}.
	self setAlive: blobsId.
	1 to: 90 do: [ :i | 
		self set: blobsId first x: 0.01 * i y: 0.4. 
		self set: blobsId second x: 0.01 * i y: 0.6 ]
]

{ #category : #simulating }
TuioClientSimulator >> simulateScrollUp [

	"Send two points and modify their positions to the TUIOClient  in order to simulate a scroll top."
	
	| blobsId |
	
	blobsId := {1 . 2}.
	
	self setAlive: blobsId.
	
	90 to: 1 by: -1 do: [ :i |
		self set: blobsId first x: 0.4  y: 0.01*i.
		self set: blobsId second x: 0.6  y: 0.01*i. ].
]

{ #category : #simulating }
TuioClientSimulator >> simulateTwoFingerClick [

	"Send two points to the TUIOClient  in order to simulate a two finger click."
	
	| blobsId |
	
	blobsId := {1 . 2}.
	
	self setAlive: blobsId.
	
	self set: blobsId first x: 0.4 y: 0.5.
	self set: blobsId second  x: 0.6 y: 0.5.
]

{ #category : #simulating }
TuioClientSimulator >> simulateTwoFingerRotate [
	"Send two points to the TUIOClient  in order to simulate a two finger click."
	| blobsId |
	
	blobsId := {1 . 2}.
	self setAlive: blobsId.
	
	0 to: 1.57 by: 0.2 do: [ :rot || x1 y1 x2 y2 |
		x1 := (1+rot cos)/2.
		y1 := 1-((1+rot sin)/2).
		x2 := (1+(Float pi+rot) cos)/2.
		y2 := 1-((1+(Float pi+rot) sin)/2).
		self set: blobsId first x: x1 y: y1.
		self set: blobsId second  x: x2 y: y2 ]
]

{ #category : #accessing }
TuioClientSimulator >> tuioClient [
	^ tuioClient ifNil: [ tuioClient := TuioClient singleInstance ]
]

{ #category : #accessing }
TuioClientSimulator >> tuioClient: anObject [
	tuioClient := anObject
]

{ #category : #simulating }
TuioClientSimulator >> viewDoubleClick [
	"Send one point, remove it and send an new point to make a double click."
	
	self execute: [	
		self setAlive: {1}.
		self set: 1 x: 0.5 y: 0.5.
		
		0.2 seconds wait.
		self removeAllBlobs.
		0.2 seconds wait.
			
		self setAlive: {2}.
		self set: 2 x: 0.5 y: 0.5 ].
	
]

{ #category : #simulating }
TuioClientSimulator >> viewDrag [

	"Send two points and modify their positions to the TUIOClient  in order to simulate a left scroll."
	
	| blobsId |
	
	blobsId := {1}.
	
	self setAlive: blobsId.
	
	self execute: [ :i |
		self set: blobsId first x: 0.01*i  y: 0.4 ] from: 75 to: 25 by: -1 .
]

{ #category : #simulating }
TuioClientSimulator >> viewOneFingerClick [

	"Send one point to the TUIOClient  in order to simulate a simple click."
	self execute: [
		self setAlive: {1}.
		self set: 1 x: 0.5 y: 0.5 ].
]

{ #category : #simulating }
TuioClientSimulator >> viewPinchIn [
	"Send two points and modify their positions to the TUIOClient  in order to simulate a scroll top."
	
	| blobsId |
	
	blobsId := {1 . 2}.
	
	self setAlive: blobsId.
	
	self execute: [ :i |
		self set: blobsId first x: 0.01*i y: 0.4 .
		self set: blobsId second x: (1-(0.01*i))  y: 0.4 . ] from: 1 to: 45
]

{ #category : #simulating }
TuioClientSimulator >> viewPinchOut [
	"Send two points and modify their positions to the TUIOClient  in order to simulate a scroll top."
	
	| blobsId |
	
	blobsId := {1 . 2}.
	
	self setAlive: blobsId.
	
	self execute: [ :i |
		self set: blobsId first x: 0.01*i y: 0.4 .
		self set: blobsId second x: (1-(0.01*i))  y: 0.4 . ] from: 45 to: 1 by: -1
]

{ #category : #simulating }
TuioClientSimulator >> viewScrollDown [

	"Send two points and modify their positions to the TUIOClient  in order to simulate a down scroll."
	
	| blobsId |
	
	blobsId := {1 . 2}.
	
	self setAlive: blobsId.
			
	self execute: [ :i |
		self set: blobsId first x: 0.4  y: 0.01*i.
		self set: blobsId second x: 0.6  y: 0.01*i. ] from: 1 to: 90
]

{ #category : #simulating }
TuioClientSimulator >> viewScrollLeft [

	"Send two points and modify their positions to the TUIOClient  in order to simulate a left scroll."
	
	| blobsId |
	
	blobsId := {1 . 2}.
	
	self setAlive: blobsId.
	
	self execute: [:i |
		self set: blobsId first x: 0.01*i  y: 0.4.
		self set: blobsId second x: 0.01*i  y: 0.6. ] from: 90 to: 1 by: -1
]

{ #category : #simulating }
TuioClientSimulator >> viewScrollRight [

	"Send two points and modify their positions to the TUIOClient  in order to simulate a right scroll."
	
	| blobsId |
	
	blobsId := {1 . 2}.
	
	self setAlive: blobsId.
	
	self execute: [:i |
		self set: blobsId first x: 0.01*i  y: 0.4.
		self set: blobsId second x: 0.01*i  y: 0.6. ] from: 1 to: 90
]

{ #category : #simulating }
TuioClientSimulator >> viewScrollUp [

	"Send two points and modify their positions to the TUIOClient  in order to simulate a scroll top."
	
	| blobsId |
	
	blobsId := {1 . 2}.
	
	self setAlive: blobsId.
	
	self execute: [ :i |
		self set: blobsId first x: 0.4  y: 0.01*i.
		self set: blobsId second x: 0.6  y: 0.01*i. ] from: 90 to: 1 by: -1
]

{ #category : #simulating }
TuioClientSimulator >> viewTwoFingerClick [
	"Send two points to the TUIOClient  in order to simulate a two finger click."
	| blobsId |
	
	blobsId := {1 . 2}.
	
	self execute: [
		self setAlive: blobsId.
		
		self set: blobsId first x: 0.4 y: 0.5.
		self set: blobsId second  x: 0.6 y: 0.5 ].
]

{ #category : #simulating }
TuioClientSimulator >> viewTwoFingerRotate [
	"Send two points to the TUIOClient  in order to simulate a two finger click."
	| blobsId |
	
	blobsId := {1 . 2}.
	self setAlive: blobsId.
	
	self execute: [ :rot || x1 y1 x2 y2 |
		x1 := (1+rot cos)/2.
		y1 := 1-((1+rot sin)/2).
		x2 := (1+(Float pi+rot) cos)/2.
		y2 := 1-((1+(Float pi+rot) sin)/2).
		self set: blobsId first x: x1 y: y1.
		self set: blobsId second  x: x2 y: y2 ] from: 0 to: 1.57 by: 0.12 .
]
