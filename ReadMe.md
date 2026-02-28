# StroopTest

A native iOS app implementing the [Stroop Effect](https://en.wikipedia.org/wiki/Stroop_effect) psychological test. Users see colored cards with color names in contrasting colors and must tap the button matching the actual color (not the word).

**Current version:** 1.43.1 | **Requires:** iOS 16.0+ | **Tested on:** iOS 26

## How It Works

Cards display a color name (e.g., "RED") drawn in a different color (e.g., blue). The user must tap the button matching the **displayed color**, not the word. The cognitive interference between reading the word and identifying the color is the Stroop Effect.

## Play Modes

- **Score target** (default): reach a target score (default 3)
- **Timed modes**: score as many as possible in 15s, 30s, or 60s

## Features

- Multiple play modes (score target or timed)
- Score history stored in Core Data
- CSV export via file sharing
- Settings for play mode and score target
- Version info displayed in Settings

## Technical Details

- **Language:** Objective-C
- **UI:** UIKit + Storyboards
- **Architecture:** MVC
- **Data:** Core Data (`NSPersistentContainer`)
- **Dependencies:** None (pure Apple frameworks)

## Building

Open `StroopTestNew.xcodeproj` in Xcode and build the **Stroop** target, or from the command line:

```bash
xcodebuild -project StroopTestNew.xcodeproj -scheme StroopTestNew -sdk iphonesimulator build
```

## Change Log

### Version 1.43.1 (Feb 2026)
- Updated for iOS 26
- Version number now displayed in Settings

### Version 1.43.0 (Dec 2025)
- Modernized for iOS 16: UIScene lifecycle, NSPersistentContainer

### Version 1.41.1 (Jul 2020)
- Updated for iOS 13

### Version 1.41 (May 2015)
- Fixed crash in instructions page caused by incorrect STColors

### Version 1.4 (May 2015)
- Recompiled for iOS 8.3
- STColors is now the main color object

### Version 1.3 (Aug 2014)
- Instructions page uses real examples

### Version 1.2 (Feb 2014)
- Improved results page with custom table view cells
- Instructions now uses unwind segue
- All results saved to Core Data
- CSV export support

### Version 1.1 (Jun 2013)
- UX overhauled for iOS 7
- Results transferable to iTunes
