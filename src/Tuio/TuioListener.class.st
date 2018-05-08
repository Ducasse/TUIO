"
I am the abstract superclass of TuioDemo and TUIoDump. 

I define the protocol for tangible user interface applications that make use of the Reactivision computer vision system for tracking cheap paper  fiducial markers.

(See the comment in TuioClient for more information).

The simplest way to create new tangible user interface applications is to subclass me.

My initialize message  starts up the TuioClient and registers me to receive multicasts sent by the Tuioclient. 

My stop message is essential for de-registering, shutting everything down and generally tidying up.

Once I have registered myself with the sole instance of TuiClient, it will send me messages to with updated information about any tuioCursors and TuioObjects using updateTuioCursor: withSessionId: and updateTuioObject:with ClassId:. 

These messages use instances of  TuioCursor and TuiObject as arguments. Thes objects reify information about cursors and numbered fiducial markers and their many assiocated paramaters (e.g. position, angle etc))

See TuiDemo and TUIDump for examples of how to use my protocol.
"
Class {
	#name : #TuioListener,
	#superclass : #Object,
	#instVars : [
		'tuioClient'
	],
	#category : #Tuio
}

{ #category : #'event responses' }
TuioListener >> addTuioCursor: sessionId [ 
	self subclassResponsibility


]

{ #category : #'event responses' }
TuioListener >> addTuioObject: sessionId classId: classId [
	self subclassResponsibility
      
]

{ #category : #actions }
TuioListener >> refresh [
	 self subclassResponsibility
]

{ #category : #'event responses' }
TuioListener >> removeTuioCursor: sessionId [ 	
	 self subclassResponsibility
]

{ #category : #'event responses' }
TuioListener >> removeTuioObject: sessionId classId: classId [
	 self subclassResponsibility
	
]

{ #category : #actions }
TuioListener >> start [
	self tuioClient 
		when: #addTuioObject
		send: #addTuioObject:classId:
		to: self.
	self tuioClient 
		when: #removeTuioObject
		send: #removeTuioObject:classId:
		to: self.
	self tuioClient 
		when: #addTuioCursor
		send: #addTuioCursor:
		to: self.
	self tuioClient 
		when: #removeTuioCursor
		send: #removeTuioCursor:
		to: self.
	self tuioClient 
		when: #updateTuioObject
		send: #updateTuioObject:withClassId:
		to: self.
	self tuioClient 
		when: #updateTuioCursor
		send: #updateTuioCursor:withSessionId:
		to: self.
	self tuioClient 
		when: #refresh
		send: #refresh
		to: self.
		
	self tuioClient start.
]

{ #category : #actions }
TuioListener >> stop [
	self tuioClient ifNil: [^nil].
	self tuioClient removeActionsWithReceiver: self.
	self tuioClient stop.  	
	self tuioClient: nil.
	Smalltalk garbageCollectMost.


]

{ #category : #accessing }
TuioListener >> tuioClient [
	^ tuioClient ifNil: [ tuioClient := TuioClient singleInstance ]
]

{ #category : #accessing }
TuioListener >> tuioClient: anObject [
	tuioClient := anObject
]

{ #category : #'event responses' }
TuioListener >> updateTuioCursor: aCursor withSessionId: sessionId [
	 self subclassResponsibility

]

{ #category : #'event responses' }
TuioListener >> updateTuioObject:  tuioObject withClassId:  classId [ 
	 self subclassResponsibility
	
]
