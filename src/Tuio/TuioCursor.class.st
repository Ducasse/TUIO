"
I am used by TuioClient to tie together transmitted  information (such as position) about a cursor that has been seen by a video camera using Reactivision.

TuioClient uses the multicast system to send me an argument via the message updateTuioCursor: withSessionId: to an object that has registered with tuioClient. 

Normally  recipients of such multicasts will be subclasses of TuioListener such as TuiDemo and TuioDump.
I am not designed to be seen directly by the enduser. Applications such as TuioDemo use information from me to create a corresponding Morph.

See TuioListener, TuioClient and TuioDemo for more information.

"
Class {
	#name : #TuioCursor,
	#superclass : #Tuio2DMessage,
	#category : #Tuio
}

{ #category : #accessing }
TuioCursor >> position [

	^ self x @ self y
]

{ #category : #printing }
TuioCursor >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' session Id ';
			 print: self sessionId ;
			 tab;
			 nextPutAll: 'position ';
			 print: (self x @ self y) ;
			 cr.

 
]
