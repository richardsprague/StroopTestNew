# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

StroopTestNew is a native iOS app implementing the Stroop Effect psychological test. Users see colored cards with color names in contrasting colors and must tap the button matching the actual color (not the word). Written entirely in **Objective-C** using **UIKit + Storyboards** with no external dependencies.

**Current version:** 1.43.1 | **Deployment target:** iOS 16.0 | **Tested on:** iOS 26

## Build & Run

- Open `StroopTestNew.xcodeproj` in Xcode
- Build target is named **Stroop** (not "StroopTestNew")
- Build from command line: `xcodebuild -project StroopTestNew.xcodeproj -scheme StroopTestNew -sdk iphonesimulator build`
- Run tests: `xcodebuild -project StroopTestNew.xcodeproj -scheme StroopTestNew -sdk iphonesimulator test` (test target exists but tests are placeholder only)
- No package manager dependencies — pure Apple frameworks (UIKit, CoreData, Foundation)

## Architecture (MVC)

**App flow:** `STAppDelegate` → `STSceneDelegate` → `STViewController` (home) → `STSceneVC` (active test) → `STScoreVC` (results)

Key classes in `StroopTestNew/`:
- **STSceneDelegate** — UIScene lifecycle, owns the `UIWindow`
- **STViewController** — Main screen, creates `STTest` and presents test modally
- **STSceneVC** — Runs active test, uses `STSceneProtocol` delegate to report score changes back
- **STScene** — Model for one test round: holds an `STCard`, score, elapsed time
- **STCard** — Card model with a color and shuffled color name array for selection buttons
- **STColors** — Color abstraction (red, green, blue); the canonical color type used throughout
- **STSettings** — Settings constants (defined in `STSettings.h`)
- **STSettingsVC** — Settings screen, displays version number
- **STScoreVC** — Results history via `NSFetchedResultsController` bound to Core Data
- **STAppDelegate** — Core Data stack setup using `NSPersistentContainer`
- **StroopData** — Core Data entity (date, score, duration, playMode, comment)

**Play modes:** Mode 0 = score target (default 3), Modes 1/2/3 = timer (15s/30s/60s)

## Core Data

- Model: `ensembioStroop.xcdatamodeld` (at project root)
- Entity: `StroopData` with fields: date, score (Int32), duration (Double), playMode (Int16), comment
- MOC helper: `StroopData+MOC` category
- Storage via `NSPersistentContainer` (migrated from `UIManagedDocument`)

## UI Resources

- Main UI: `Base.lproj/MainStoryboard.storyboard`
- Assets: `Stroop/Images-2.xcassets`
- Launch: `LaunchScreen.storyboard`

## Conventions

- All classes use `ST` prefix
- Custom views (`STCardView`, `STSelectionsView`) do custom drawing
- CSV export supported via file sharing (enabled in Info.plist)
- Bundle ID: `com.ensembio.stroop`
