"
I am an object that ties together a rectangleMorph instance,  a TextMorph used to label me,
and a TransformationMorph that allows me to be  totated though any angle. I implement a small part of the Morph protocol such as position: and delete.

I am used to represent a numbered Reactivision fiducial marker (see the comment in TuioClient for more information).

Maybe I should have been subclassed from RectangleMorph?

---

SD: should clean a bit the code
	openInWorld in initialize
	real name for accessors.

"
Class {
	#name : #TuioVisibleObject,
	#superclass : #Object,
	#instVars : [
		'rect',
		'text',
		'trans'
	],
	#category : #TUIO
}

{ #category : #accessing }
TuioVisibleObject >> angle: radians [
	self trans angle: radians
	
]

{ #category : #actions }
TuioVisibleObject >> beInvisible [
	self rect beTransparent
]

{ #category : #actions }
TuioVisibleObject >> beRed [
	self rect color: Color red.
]

{ #category : #actions }
TuioVisibleObject >> delete [
	self text delete.
	self rect delete.
	self trans ifNotNil: [ self trans delete.
						 self trans: nil.]
]

{ #category : #initialize }
TuioVisibleObject >> initialize [
	"note from SD: putting the openInWorld in initialize method is a bad idea"

	| label font1 tm |
	super initialize.
	label := 'id'.
	font1 := TextFontReference
		toFont: (StrikeFont familyName: 'Accuny' size: 48).
	tm := StringMorph new contents: (label asText addAttribute: font1).
	self rect: BorderedMorph new openInWorld.
	self text: tm.
	self rect addMorphCentered: text.
	self trans: (TransformationMorph new asFlexOf: rect).
	self trans openInWorld
]

{ #category : #accessing }
TuioVisibleObject >> position: aPoint [
	rect position:aPoint.
	trans position:aPoint
]

{ #category : #accessing }
TuioVisibleObject >> rect [
	^ rect
]

{ #category : #accessing }
TuioVisibleObject >> rect: anObject [
	rect := anObject
]

{ #category : #accessing }
TuioVisibleObject >> rotationCenter [
	^ trans rotationCenter
]

{ #category : #accessing }
TuioVisibleObject >> rotationCenter: aPoint [ 
	trans rotationCenter: aPoint
]

{ #category : #accessing }
TuioVisibleObject >> text [
	^ text
]

{ #category : #accessing }
TuioVisibleObject >> text: anObject [
	text := anObject
]

{ #category : #accessing }
TuioVisibleObject >> textBe: anObject [
	text contents: anObject asString.
]

{ #category : #accessing }
TuioVisibleObject >> trans [
	^ trans
]

{ #category : #accessing }
TuioVisibleObject >> trans: anObject [
	trans := anObject
]
