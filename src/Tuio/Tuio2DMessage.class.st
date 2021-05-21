"
I am the abstract superclass of TuioCursor and TuioObject. The paper on the TUIO protocol http://opensoundcontrol.org/, itemizes other parts of the TUIO protocol, not yet required for this application, which could be future subclasses.


"
Class {
	#name : #Tuio2DMessage,
	#superclass : #Object,
	#instVars : [
		'motionAccel',
		'rotationAccel',
		'sessionId',
		'x',
		'y'
	],
	#category : #TUIO
}

{ #category : #accessing }
Tuio2DMessage >> motionAccel [
	^ motionAccel
]

{ #category : #accessing }
Tuio2DMessage >> motionAccel: anObject [
	motionAccel := anObject
]

{ #category : #accessing }
Tuio2DMessage >> rotationAccel [
	^ rotationAccel
]

{ #category : #accessing }
Tuio2DMessage >> rotationAccel: anObject [
	rotationAccel := anObject
]

{ #category : #accessing }
Tuio2DMessage >> sessionId [
	^ sessionId
]

{ #category : #accessing }
Tuio2DMessage >> sessionId: anObject [
	sessionId := anObject
]

{ #category : #accessing }
Tuio2DMessage >> x [
	^ x
]

{ #category : #accessing }
Tuio2DMessage >> x: anObject [
	x := anObject
]

{ #category : #accessing }
Tuio2DMessage >> y [
	^ y
]

{ #category : #accessing }
Tuio2DMessage >> y: anObject [
	y := anObject
]
