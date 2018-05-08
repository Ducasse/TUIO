"
The class I am an instance of is just a subclass of CircleMorph. I am used to represent a ReactivisionCursor (see the comment in TuioClient for more information).

I am subclassed simply to make garbage collection simpler after a Reactivision session, as many instances of me can get created.


"
Class {
	#name : #TuioVisibleCursor,
	#superclass : #CircleMorph,
	#category : #TUIO
}
