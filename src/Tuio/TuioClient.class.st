"
TUI is a protocol for tangible user interface programming.

TuioClient is a client for reacTIVision, which is ""...an open source, cross-platform computer vision framework for the fast and robust tracking of fiducial markers attached onto physical objects, as well as for multi-touch finger tracking. It was mainly designed as a toolkit for the rapid development of table-based tangible user interfaces (TUI) and multi-touch interactive surfaces.""  - see http://mtg.upf.edu/reactable. To make practical use of this client you will need to download the standalone computer vision application Reactivision for your operating system from http://mtg.upf.edu/reactable/?software. The Reactivision  application works with a webcam or other other suitable camera and transmits OpenSound Control messages via port 3333 to this client.

The system is most easily demonstrated by running instances of the demo class TuioDemo using
 td := TuioDemo new start. This will create and start the sole instance of TuioClient automatically.
Nothing visible will happen unless you are running Reactivision. To terminate and clean up, which is strongly advised, send the message ""stop"" to your instance of TuioDemo.

If you need to run the single Instance of TuioClient directly for any reason, this can be done via ""TuioClient new connect"" or "" TuioClient new start"". This  requests the OSCserver to listen on Port 3333.  The OSC server forks off instances of OSCParser as required, which parse OSC  messages from Reactivision and place them on a shared queue held by OSCServer, The TuioClient forks off a process which reads TUI  messages from the shared queue, 

Depending on the latency of the camera you are using, there is a responsePeriod class message in OSCserver which can be used to set a wait time in milliseconds to stop the OSCServer hogging the processor by repeatedly reading the USP socket when it is empty between messages. In a familiar paradox, setting longer responsePerodsup to a certain limit, will make the system as a whole more responsive.

The TuioClient responds to the six kinds of low-level messages sent out by Reactivision ( more specifically there are three basic message types, set, alive and  fseq, any of which may apply to either cursors or objects). The TuiClient translates these into events in a  high-level application protocol for adding removing and updating objects or cursors, and an optional message for screen refreshes.

The TuioClient notifies any interested parties of these events by sending the appropriate triggerEvent  message to itself whenever these occur.

Classes wishing to make use of TuiClinet should subclass from TuioListener (or imitate it).

There are currently two subclasses of TuiListener, TuiDemo and TuiDump.  TuioDemo creates rectangular labelled morphs on the fly to track numbered fiducial markers, and unmarked circular cursors to track cursors.  TuioDump is a purely textual program which dumps the
creation and removal events with all apramaters to the Transcript.

On an Intel Core Duo Laptop using the built in webcam, TuioDemo can easily track
15 numbered fiducial markers and  60 cursors simultaneously.

However, given  the  speed  limitations of the Transcript, TuioDump will lag behind real time.

In tests to date, the system has no leaks - everything is properly terminated. However it
does take time for the garbage collector to do its work.





 


"
Class {
	#name : #TuioClient,
	#superclass : #Object,
	#instVars : [
		'currentFrame',
		'isRunning',
		'lastFrame',
		'newCursors',
		'newObjects',
		'oscServer',
		'process',
		'retiringCursors',
		'retiringObjects',
		'tagDict'
	],
	#classInstVars : [
		'soleInstance'
	],
	#category : #TUIO
}

{ #category : #flushing }
TuioClient class >> flush [
	soleInstance := nil.
]

{ #category : #'instance creation' }
TuioClient class >> new [
	self error: 'Cannot create with new - use singleInstance'
]

{ #category : #'as yet unclassified' }
TuioClient class >> singleInstance [
	soleInstance ifNil: [ soleInstance := self basicNew ].
	^ soleInstance
]

{ #category : #'event triggering' }
TuioClient >> addObjectListenersFor: anObject withClassId: classId [ 
	self triggerEvent: #addTuioObject
		withArguments: {  anObject. classId }
]

{ #category : #'private-labels' }
TuioClient >> alive2DProfileLabel [

	^ '#bundle/tuio/2Dcur'
]

{ #category : #'private-labels' }
TuioClient >> aliveCommandLabel [

	^ 'alive'.
]

{ #category : #'extracting message parts' }
TuioClient >> classIdFromArray:msgArray [
	 (msgArray size < 4) ifTrue:  [ .^nil].
     ^ msgArray fourth
]

{ #category : #'extracting message parts' }
TuioClient >> commandFromArray:msgArray [
	(msgArray size < 2) ifTrue: [^nil].	
     ^msgArray second
]

{ #category : #'main protocol' }
TuioClient >> connect [
	self oscServer listenOnPort: 3333.
	
]

{ #category : #accessing }
TuioClient >> currentFrame [
	^ currentFrame
]

{ #category : #accessing }
TuioClient >> currentFrame: anObject [
	currentFrame := anObject
]

{ #category : #'object and cursor reification' }
TuioClient >> cursorFromArray: argArray [
	| cursor |
   cursor :=  TuioCursor new.
	cursor sessionId:  argArray third.
	cursor x:  argArray fourth.
	cursor y:  argArray fifth.
	cursor motionAccel:  argArray sixth.
	cursor rotationAccel:  argArray seventh.
	^ cursor.

]

{ #category : #'updating rosters' }
TuioClient >> doFrameChangeFrom:msgArray [
	self lastFrame:(self currentFrame).
	self currentFrame:(self frameFromArray:msgArray).
]

{ #category : #'event triggering' }
TuioClient >> doFrameUpdates:msgArray [
	self doFrameChangeFrom: msgArray.
	(self currentFrame > self lastFrame) ifTrue: [ self triggerEvent: #refresh ].

]

{ #category : #'main protocol' }
TuioClient >> drive [
	| msgArray |
	
	msgArray := self nextMessage.
	
	self processSetCommand:msgArray.
	self processAliveCommand:msgArray.
	self processFseqCommand:msgArray.


]

{ #category : #'main protocol' }
TuioClient >> flush [
	self class flush.

]

{ #category : #'extracting message parts' }
TuioClient >> frameFromArray:msgArray [
	(msgArray size < 3) ifTrue:  [.^0].
      ^msgArray third
]

{ #category : #'private-labels' }
TuioClient >> fseq2DProfileLabel [
	
	^ '/tuio/2Dcur'.
]

{ #category : #'private-labels' }
TuioClient >> fseqCommandLabel [

	^ 'fseq'.
]

{ #category : #'extracting message parts' }
TuioClient >> is: msgArray for: description [
	          | cmd |
			cmd:=  msgArray first.
		     (cmd  findString: description) isZero ifFalse: [ ^ true].
			^ false.
	
]

{ #category : #'extracting message parts' }
TuioClient >> isForCursor:msgArray [	

	^ self is: msgArray for: 'tuio/2Dcur'
]

{ #category : #'extracting message parts' }
TuioClient >> isForObject:msgArray [	

	^ self is: msgArray for: 'tuio/2Dobj'
]

{ #category : #accessing }
TuioClient >> isRunning [
	isRunning ifNil: [ ^ isRunning := false ].
	^ isRunning.
	
]

{ #category : #accessing }
TuioClient >> isRunning: anObject [
	isRunning := anObject
]

{ #category : #accessing }
TuioClient >> lastFrame [
	^ lastFrame
]

{ #category : #accessing }
TuioClient >> lastFrame: anObject [
	lastFrame := anObject
]

{ #category : #accessing }
TuioClient >> newCursors [
	^ newCursors ifNil: [ newCursors := Set new].
]

{ #category : #accessing }
TuioClient >> newCursors: anObject [
	newCursors := anObject
]

{ #category : #accessing }
TuioClient >> newObjects [
	^ newObjects ifNil: [ newObjects := Set new].
]

{ #category : #accessing }
TuioClient >> newObjects: anObject [
	newObjects := anObject
]

{ #category : #'osc server access' }
TuioClient >> nextMessage [

	^ self oscServer nextMessage.
]

{ #category : #'object and cursor reification' }
TuioClient >> objFromArray: argArray [
	| mine |
   mine :=  TuioObject new.
	mine sessionId:  (argArray at:3).
	mine fiducialId:  (argArray at:4).
	mine x:  (argArray at:5).
	mine y:  (argArray at:6).
	mine angle:  (argArray at:7).
	mine movementX:  (argArray at:8).
	mine movementY:  (argArray at:9).
	mine rotationVector:  (argArray at:10).
	mine motionAccel:  (argArray at:11).
	mine rotationAccel:  (argArray at:12).
	^ mine
]

{ #category : #'osc server access' }
TuioClient >> oscServer [
	^ oscServer ifNil: [oscServer := OSCServer new].
]

{ #category : #'osc server access' }
TuioClient >> oscServer: anObject [
	oscServer := anObject
]

{ #category : #accessing }
TuioClient >> process [
	^ process
]

{ #category : #accessing }
TuioClient >> process: anObject [
	process := anObject
]

{ #category : #'main protocol' }
TuioClient >> processAliveCommand:msgArray [
	(((self commandFromArray: msgArray) = 'alive' ) and: [  self currentFrame >= self lastFrame])
		ifTrue: [ (self isForObject:msgArray) 
					ifTrue: [self updateObjectRosterFrom: msgArray. ^nil].
				(self isForCursor:msgArray) 
					ifTrue: [self updateCursorRosterFrom: msgArray. ^nil]].
				

]

{ #category : #'main protocol' }
TuioClient >> processFseqCommand:msgArray [			
	((self commandFromArray: msgArray) = 'fseq' ) 
		ifTrue: [ self doFrameUpdates: msgArray ].
		

]

{ #category : #'main protocol' }
TuioClient >> processSetCommand:msgArray [
	| anObj classId |	
	(((self commandFromArray: msgArray) = 'set' )	and: [  self currentFrame >= self lastFrame])
		 ifTrue: [(self isForObject: msgArray) 
					ifTrue: [ (self tagDict at: msgArray third ifAbsentPut: msgArray fourth ).	
				 		  	anObj := (self objFromArray:msgArray).
							classId := msgArray fourth.
							self addObjectListenersFor: anObj withClassId: classId.
							self updateObjectListenersFor: anObj withClassId: classId .
							^ nil ].
			
				 (self isForCursor: msgArray) 
					 ifTrue: [ self 
								updateCursorListenersFor:  (self  cursorFromArray: msgArray) 
								withSessionId: msgArray third ].
					^ nil].
						
]

{ #category : #'main protocol' }
TuioClient >> removeAllBlobs [
	"Remove all of the blobs"
	
	self setAlive: nil.
]

{ #category : #accessing }
TuioClient >> retiringCursors [
	^ retiringCursors ifNil: [ retiringCursors := Set new].
]

{ #category : #accessing }
TuioClient >> retiringCursors: anObject [
	retiringCursors := anObject
]

{ #category : #accessing }
TuioClient >> retiringObjects [
	^ retiringObjects ifNil: [ retiringObjects := Set new].
]

{ #category : #accessing }
TuioClient >> retiringObjects: anObject [
	retiringObjects := anObject
]

{ #category : #accessing }
TuioClient >> set2D: aBlobId x: x y: y X: X Y: Y m: m [

	"Set the position of the blob on the screen. All values but aBlobId are between 0 and 1.
	
	the values are: x, y 	-> Position
				 	X, Y 	-> Velocity vector (motion speed & direction) 
					m		-> Motion acceleration"
	
	self processSetCommand: {self set2DProfileLabel. self setCommandLabel. aBlobId. x. y. X. Y. m}.
]

{ #category : #'private-labels' }
TuioClient >> set2DProfileLabel [

	^ '4/tuio/2Dcur'
]

{ #category : #accessing }
TuioClient >> set: aBlobId x: x y: y [
	
	"set the position of a static cursor on the screen (without any velocity or motion accelerator)"
	
	self set2D: aBlobId x: x y: y X: 0.0 Y: 0.0 m: 0.0.
]

{ #category : #accessing }
TuioClient >> setAlive: blobIdList [

	"Set blobs from blobIdList to alive and remove the ones that are not in blobIdList."
	
	blobIdList ifNil: [ self processAliveCommand: {self alive2DProfileLabel.  self aliveCommandLabel}. ^ nil].
	
	self processAliveCommand: {self alive2DProfileLabel. self aliveCommandLabel}, blobIdList.
]

{ #category : #'private-labels' }
TuioClient >> setCommandLabel [

	^ 'set'
]

{ #category : #'main protocol' }
TuioClient >> start [
	self isRunning ifTrue: [ ^nil].
	self connect.
	self lastFrame: 0.
	self currentFrame: 0.
	self isRunning: true.	
	self process: ( [[self isRunning] whileTrue: [ self drive]]                               
							forkAt: Processor userBackgroundPriority).
]

{ #category : #'main protocol' }
TuioClient >> stop [
	self isRunning: false.	
	self process terminate.
	self oscServer terminate.
	self oscServer: nil.
	self flush.
	Smalltalk garbageCollectMost.

]

{ #category : #accessing }
TuioClient >> tagDict [
	^ tagDict ifNil: [ tagDict := Dictionary new].
]

{ #category : #accessing }
TuioClient >> tagDict: anObject [
	tagDict := anObject
]

{ #category : #'event triggering' }
TuioClient >> updateCursorListenersFor: aCursor withSessionId: sessId [
	self
		triggerEvent: #updateTuioCursor
		withArguments:
			{aCursor.
			sessId} 
]

{ #category : #'updating rosters' }
TuioClient >> updateCursorRosterFrom:msgArray [
	| oldSurvivors reallyNewArrivals reallyDeadCursors |
	3 to: msgArray size do: [:i | self newCursors add:  (msgArray at:i )].
												
	oldSurvivors  := self retiringCursors select: [: each|  newCursors includes: each].
	reallyNewArrivals := self newCursors reject:  [: each|  oldSurvivors includes: each].

	reallyNewArrivals do:  [:sessId | self triggerEvent: #addTuioCursor with: sessId  ].							 											  
																							
	reallyDeadCursors := self retiringCursors reject: [: each|  newCursors includes: each].
	reallyDeadCursors do: [ :sessId | self triggerEvent: #removeTuioCursor with: sessId].

	self retiringCursors: Set new. "could be nil to hit the lazy initialization properly"
	self retiringCursors addAll: self newCursors.
	self newCursors: Set new.  "could be nil to hit the lazy initialization properly"


]

{ #category : #'event triggering' }
TuioClient >> updateObjectListenersFor: anObject withClassId: classId [
	self
		triggerEvent: #updateTuioObject
		withArguments:
			{anObject.
			classId} 
]

{ #category : #'updating rosters' }
TuioClient >> updateObjectRosterFrom:msgArray [
	|   reallyDeadObjects  classId isRealClassId |

	3 to: msgArray size  do: [:i | self newObjects add: (msgArray at:i ) ].		
	reallyDeadObjects :=  ( self retiringObjects reject: [:each |  self newObjects includes: each]).
	self retiringObjects:reallyDeadObjects.
	self retiringObjects do:  [:sessionId |  
			isRealClassId := true.
			classId := tagDict at: sessionId ifAbsent: [isRealClassId := false. ].
			isRealClassId ifTrue: [ self triggerEvent: #removeTuioObject withArguments: { sessionId . classId  }.
	 							self tagDict removeKey: sessionId  ]].			
              
	self retiringObjects: self  newObjects copy. 
	self newObjects removeAllSuchThat: [:each |  true]. "Remove all?"
]
