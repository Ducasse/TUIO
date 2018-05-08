"
TUIO is a protocol for tangible user interface programming with Reactivision.
See the comment in TuiClient for more information.

I can be run using ""TuioDemo new start"". This will create and start the TuioClient and OSC server automatically

Nothing very exciting will happen unless you have downloaded and are running
Reactivision from http://mtg.upf.edu/reactable/?software. You  will  need a webcam or other suitable video camera. You can then  download and printoff some fiducial markers from the same site, and wave them around in front of your camera (or even better build your own light table).

To make sure all garbage created by the OSC/TUI processes is cleaned up, terminate me using ""stop"".

The amount of the screen used to display fiducials and the frequency of full screen refresh  can be adjusted by editing the  initialize method. (The screen refresh does not really seem to be needed.)

Depending on the framerate of the camera, it may be useful to adjust the millisecond value responsePeriod variable in OSCServer>>initialize.




"
Class {
	#name : #TuioDemo,
	#superclass : #TuioListener,
	#instVars : [
		'cursorDict',
		'objCount',
		'objectDict',
		'refreshCounter',
		'screenExtent',
		'screenRedrawRatio'
	],
	#category : #TUIO
}

{ #category : #'as yet unclassified' }
TuioDemo class >> bannedunderInternationalLaw [
" Never needed, and bad form even if Tuio classes have been accidentally broken"
" Can do serious damage"
" Still... useful if classes are modified to destruction "
OSCServer allSubInstancesDo: [:each | each become: String new].
TuioListener  allSubInstancesDo: [:each | each become: String new].
OSCParser  allSubInstancesDo: [:each | each become: String new].
TuioVisibleCursor allInstancesDo: [:each | each delete].
TuioVisibleCursor allInstancesDo: [:each | each become: String new].
TuioObject allInstancesDo: [:each | each become: String new].
TuioVisibleObject allInstancesDo: [:each | each become: String new].
TransformationMorph allInstancesDo: [:each | each delete].
TransformationMorph allInstancesDo: [:each | each become: String new].
TuioClient flush.
TuioClient allInstancesDo:[:each | each become: String new].
Utilities garbageCollectAndReport.
]

{ #category : #'as yet unclassified' }
TuioDemo class >> leakTest [
" Everything is properly finalized released and terminated.
  It just takes time for everything to be garbage collected ."

| junk |
junk := WeakSet new.
TuioClient allInstancesDo: [:each | junk add: each ].
OSCServer allInstancesDo: [:each | junk add: each ].
TuioListener allSubInstancesDo: [:each | junk add: each ].
OSCParser  allSubInstancesDo: [:each | junk add: each ].
TuioVisibleCursor allInstancesDo: [:each | junk add: each ].
TuioCursor allInstancesDo: [:each | junk add: each ].
TuioVisibleObject allSubInstancesDo: [:each | junk add: each ].
TuioObject allInstancesDo: [:each | junk add: each ].
TransformationMorph allInstancesDo: [:each | junk add: each ].
^ junk
]

{ #category : #'event responses' }
TuioDemo >> addTuioCursor:  sessionId [ 

	| circ |
	sessionId ifNil: [ ^nil].	
	self cursorDict 
			at: sessionId 
			ifAbsent: [ self cursorDict at: sessionId put: (circ := TuioVisibleCursor new ).
	   					circ extent: (30@30).
	   					circ openInWorld.
	 					^ nil ].

]

{ #category : #'event responses' }
TuioDemo >> addTuioObject: sessionId classId: classId [
	| viz |
	classId ifNil: [^nil].
	self objectDict 
		at: classId 
		ifAbsent: [ viz := TuioVisibleObject new beRed.
				viz textBe: classId asString.
				self objectDict at:classId put: viz] .
								       
]

{ #category : #accessing }
TuioDemo >> cursorDict [
		cursorDict ifNil: [ ^ cursorDict := Dictionary new].
		^cursorDict
]

{ #category : #accessing }
TuioDemo >> cursorDict: anObject [
	cursorDict := anObject
]

{ #category : #initialize }
TuioDemo >> initialize [
	super initialize.
	refreshCounter := 0.
	screenRedrawRatio := 200. "How often to do a full screen redraw? Not very often,".
	self screenExtent: World extent. "How much of the screen do  we want to display fiducials?".	
]

{ #category : #accessing }
TuioDemo >> objectDict [
	objectDict ifNil: [ ^ objectDict := Dictionary new].
	^objectDict
	
]

{ #category : #accessing }
TuioDemo >> objectDict: anObject [
	objectDict := anObject
]

{ #category : #actions }
TuioDemo >> refresh [
	refreshCounter := refreshCounter + 1. 
	refreshCounter > screenRedrawRatio 
		ifTrue: [self restore. refreshCounter := 0]
]

{ #category : #'event responses' }
TuioDemo >> removeTuioCursor: sessionId [ 	
	| circle |
	circle := self cursorDict removeKey: sessionId ifAbsent: [ ^nil].
	circle delete.
  
	
	
]

{ #category : #'event responses' }
TuioDemo >> removeTuioObject: sessionId classId: classId [
	| visRect |
	visRect := self objectDict removeKey: classId ifAbsent: [^nil].
	visRect delete.
		
	
]

{ #category : #actions }
TuioDemo >> restore [
World  restoreMorphicDisplay. 

]

{ #category : #accessing }
TuioDemo >> screenExtent [
	^ screenExtent
]

{ #category : #accessing }
TuioDemo >> screenExtent: anObject [
	screenExtent := anObject
]

{ #category : #actions }
TuioDemo >> start [
	super start.
	
]

{ #category : #actions }
TuioDemo >> stop [
super stop.
Morph new removeAllMorphsIn: TuioVisibleCursor allInstances.			
TuioVisibleCursor allInstancesDo: [:each | each delete].
TuioVisibleObject  allInstancesDo: [:each | each delete].
Smalltalk garbageCollectMost.


]

{ #category : #'event responses' }
TuioDemo >> updateTuioCursor: aCursor withSessionId: sessionId [
	| circle  |
	cursorDict at: sessionId ifAbsent:[  "self restore." ^nil].
	circle := cursorDict at: sessionId .
	circle position: (((aCursor x) @(aCursor y) ) * self screenExtent).

]

{ #category : #'event responses' }
TuioDemo >> updateTuioObject:  tuioObject withClassId:  classId [ 
	| square |
	square := self objectDict at: classId ifAbsent: [^nil].
	square angle: tuioObject angle.
	square textBe: classId asString.
	square position: ((( tuioObject x) @ (tuioObject y)) * self screenExtent).
	

]
