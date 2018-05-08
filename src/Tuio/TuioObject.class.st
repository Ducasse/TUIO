"
I am used by TuioClient to reify transmitted  information (such as position and angle) about a numbered fiducial marker that has been seen by a video camera using Reactivision.

TuioClient uses the multicast system to send me as an argument via the message updateTuioObject: withClassId: to an object that has registered with tuioClient. 

At present,  recipients of such multicasts will be subclasses of TuioListener such as TuiDemo and TuioDump.

I am not designed to be seen directly by the enduser. Applications such as TuioDemo use information from me to create a corresponding Morph.

See TuioListener, TuioClient and TuioDemo for more information.

"
Class {
	#name : #TuioObject,
	#superclass : #Tuio2DMessage,
	#instVars : [
		'angle',
		'fiducialId',
		'movementX',
		'movementY',
		'rotationVector'
	],
	#category : #TUIO
}

{ #category : #equality }
TuioObject >> = aTuioObject [
	^ (self fiducialId = aTuioObject fiducialId)
]

{ #category : #accessing }
TuioObject >> angle [
	^ angle
]

{ #category : #accessing }
TuioObject >> angle: anObject [
	angle := anObject
]

{ #category : #accessing }
TuioObject >> fiducialId [
	^ fiducialId
]

{ #category : #accessing }
TuioObject >> fiducialId: anObject [
	fiducialId := anObject
]

{ #category : #equality }
TuioObject >> hash [
	^ (self  fiducialId) + self sessionId
]

{ #category : #accessing }
TuioObject >> movementX [
	^ movementX
]

{ #category : #accessing }
TuioObject >> movementX: anObject [
	movementX := anObject
]

{ #category : #accessing }
TuioObject >> movementY [
	^ movementY
]

{ #category : #accessing }
TuioObject >> movementY: anObject [
	movementY := anObject
]

{ #category : #printing }
TuioObject >> printOn: aStream [
	super printOn: aStream.
	aStream  nextPutAll: ' fiducial Id: ';
			 print: self fiducialId ;
			 tab;
			 nextPutAll: 'position ';
			 print: (self x @ self y) ;
			 tab;
			 nextPutAll: ' angle ';
			 print: self  angle ;
			 cr.

]

{ #category : #accessing }
TuioObject >> rotationVector [
	^ rotationVector
]

{ #category : #accessing }
TuioObject >> rotationVector: anObject [
	rotationVector := anObject
]
