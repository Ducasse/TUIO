"
See the comment in TuioClient for more information.
I am a program which creates a purely textual dump to the Transcript of creation, removal, and update events for numbered fiducial marker objects and cursors, as relayed by TuioClient.

TuioObject and TuioCursor objects are used to reify the relevant information for objects and cursors, and are passed to me as arguments of the messages updateTuioCursor: withSessionId: and updateTuioObject:with ClassId:. 

I can be run using ""TuioDump new start"". This will create and start the TuioClient and OSC server automatically.

To make sure all garbage created by the OSC/TUIO processes is cleaned up, terminate me using ""stop"".

I can be run at the same time as TuioDemo but it is fairly pointless, since printing to the transcript is very slow and will make TuioDemo crawl like a hamster in treacle.

In order to have any events to dump in the first place,  you need to have downloaded and be running
Reactivision from http://mtg.upf.edu/reactable/?software. You  will  need a webcam or other suitable video camera. You can then  download and printoff some fiducial markers from the same site, and wave them around in front of your camera (or even better build your own light table).


"
Class {
	#name : #TuioDump,
	#superclass : #TuioListener,
	#category : #Tuio
}

{ #category : #'event responses' }
TuioDump >> addTuioCursor:  sessionId [
 
	Transcript show: 'Adding cursor with session id: ', sessionId printString ; cr.

]

{ #category : #'event responses' }
TuioDump >> addTuioObject: sessionId classId: classId [
	
	Transcript show: 'Adding object with fiducial id: ', classId printString ; cr.
  
]

{ #category : #actions }
TuioDump >> refresh [
	Transcript show: 'Refresh' ; cr.

]

{ #category : #'event responses' }
TuioDump >> removeTuioCursor: sessionId [ 	

	Transcript show: 'REMOVING cursor with session id: ', sessionId printString ; cr.
	
]

{ #category : #'event responses' }
TuioDump >> removeTuioObject: sessionId classId: classId [

	Transcript show: 'REMOVING object with fiducal id: ', classId printString ; cr.
]

{ #category : #actions }
TuioDump >> start [
	Transcript show: 'started'; cr
]

{ #category : #actions }
TuioDump >> stop [ 

	Transcript show: 'Stopped' ; cr
]

{ #category : #accessing }
TuioDump >> tuioClient [
	^ tuioClient
]

{ #category : #accessing }
TuioDump >> tuioClient: anObject [
	tuioClient := anObject
]

{ #category : #'event responses' }
TuioDump >> updateTuioCursor: aCursor withSessionId: sessionId [
	
	Transcript show: aCursor printString
	

]

{ #category : #'event responses' }
TuioDump >> updateTuioObject:  tuioObject withClassId:  classId [ 
	
	Transcript show:  tuioObject printString

]
