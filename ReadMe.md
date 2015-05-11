# StroopTest OVERALL PROGRAM DESIGN

Settings Constants are kept in STSettings.h

# Classes

* __STScene__: keeps track of the card, which selection buttons are appropriate, the score so far, and the elapsed time.
* __Card__: keeps a Color, plus an NSArray of randomly-ordered color names
* __STScores__: messy! Keeps latestScore, start/end time, duration.  Used by


STViewController.m is where everything starts

* Creates a new "Scene"
* When you press the start button, start an NSTimer that 
* The Start button simultaneously kicks off a modal segue to STSceneVC
* prepareForSegue sends a STTest object, plus a STScene object to STSceneVC

STSceneVC shows the card

STSceneVC.h defines <STSceneProtocol>, which lets the delegate know when the score has increased.

STScoreVC displays a TableView of scores, which it computes itself from a call to NSUserDefaults.




# Change Log
Version 1.2 (Feb2014)

* Results page looks much better: uses custom tableviewcell labels.
* Instructions now uses unwind segue
* All results are saved to a much more efficient Core Data file
* Results are also saved to a real CSV file, easily readable in Excel




Version 1.1 (June2013)
* Shipped in Feb 2014
* UX overhauled for iOS 7
* Results (in JSON form) can be transfered to iTunes for processing on a PC or Mac.







