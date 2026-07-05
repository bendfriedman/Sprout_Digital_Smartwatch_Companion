# 🌱 Sprout — Digital Smartwatch Companion

A smartwatch app built in **Processing** featuring **Sprout**, a digital plant‑companion that motivates you to move more, eat better, and take responsibility. You keep Sprout alive and thriving by exercising, choosing healthier food, and checking in — so caring for the companion and caring for yourself become the same loop.

> University project for a Human‑Computer Interaction course. The brief: design an ergonomic, self‑explaining smartwatch app that realises three behaviour goals — **movement**, **nutrition coaching**, and **responsibility training** — with a fully hand‑built UI.

---

## Concept

Sprout is a small plant creature living on your wrist. It can't take care of itself — it depends on *you*. Move and it grows; eat well and it flourishes; neglect it and it wilts. Because Sprout is literally a plant, the metaphor is self‑explanatory: a plant thrives on activity and good nutrition, exactly the behaviour the app encourages. No tutorial required — the interaction explains itself.

A standout mechanic is a **"Days without meat"** streak: every meat‑free day grows the streak and visibly strengthens Sprout, turning the abstract goal of "eat more vegetables, less meat" into a tangible, rewarding ritual.

---

## Features

Functions covering all three required behaviour areas (the brief asks for a minimum of eight):

### 🏃 Movement
- **Set step goal by voice** — speak your target ("ten thousand") on the Goals screen; recognised offline and applied instantly.
- **Workout logging with live vital alert** — double‑tap to start/pause a running timer; a simulated heart rate rises during the workout and, once it crosses the limit, fires a repeating "take a break" alert (Sprout switches to its alert sprite). Pausing resets the pulse.
- **Progress overview** — a step ring plus three live status bars (exercise, hydration, sleep), each filled from its current value against its goal; paged navigation to the streak view.

### 🥦 Nutrition coach
- **Vegetarian check‑in by voice** — Sprout asks "Did you only eat vegetarian today?"; say "yes" (leaf) or "no" (red x). A weekly Mon–Sun row shows the history, and each vegetarian day grows the streak.
- **Log hydration** — water tracking with ± and preset (1000/1500/2000 ml) buttons.
- **"Days without meat" streak** — coaching loop that grows Sprout; the live count is shown on the streak screen's star.

### 🌟 Responsibility trainer
- **Feed / water Sprout** — tap the watering can; Sprout reacts (sad → happy) with an animated rain effect and a water sound.
- **Log sleep (shake‑to‑wake)** — "asleep" on entry; shake the wrist (rapid movement) to wake. Records sleep → wake times, with a moon/sun swap for the state.
- **View streak** — Sprout's growth state and the live meat‑free streak count.

Every action gives immediate **feedback** — button/water sounds, on‑screen reaction from Sprout, and (via FreeTTS) the option for Sprout to speak.

---

## Input modalities

The app deliberately uses four input styles suited to a small touchscreen:

- **Touch** — hand‑built tiles and buttons with rectangle hit‑testing.
- **Voice** — offline speech recognition (CMUSphinx) with a small fixed grammar: step goals on the Goals screen and yes/no for the vegetarian check‑in.
- **Swipe** — right‑swipe to go back, left‑swipe to page forward (e.g. Progress → Streak); a visible back/forward arrow mirrors each gesture for discoverability.
- **Gesture** — double‑tap to start/pause the workout timer; shake‑to‑wake on the sleep screen (both simulated with mouse input, since the desktop has no accelerometer).

---

## Tech stack & constraints

- **Engine:** [Processing](https://processing.org/) (Java mode)
- **Target device:** Apple Watch Series 1 dimensions — **312 × 390 px**
- **Allowed libraries only:** `minim`, `SimpleSpeech`, `FreeTTS`, `CMUSphinx`
  - `minim` — sound playback for button/water feedback and microphone level (live waveform).
  - **`SimpleSpeech`** — a Processing wrapper that bundles **FreeTTS** (speech synthesis — Sprout can speak) and **CMUSphinx** (offline speech recognition — voice goal setting). This single library covers three of the four allowed libs.
- **Hand‑built UI:** all interface elements (tiles, buttons, arrows, page dots) are coded from scratch. **No external UI frameworks** — a hard requirement of the assignment.

---

## Architecture

The app is built around a lightweight **screen state machine**, so each function is an isolated, self‑contained screen and `draw()` stays trivial.

```
mousePressed/Released ─▶ tap / swipe detection ─▶ ScreenManager ─▶ currentScreen
                                                     ├─ handleTouch(x, y)   → switchTo(...) / actions
                                                     └─ onSwipeLeft / goBack → navigation
draw()                ─▶ ScreenManager ─▶ currentScreen.update() + .draw()
listenEvent()         ─▶ currentScreen.onSpeech(recognisedText)
```

**Core classes**

| File | Responsibility |
|------|----------------|
| `ScreenManager` | Holds all screens, tracks `currentScreen` / `currentName`, switches between them (`registerScreen`, `switchTo`, `render`, `goBack`, `onSwipeRight`). |
| `Screen` (abstract) | Base for every screen: `draw()`, `handleTouch()`, `update()`, `onEnter()`, plus shared concrete helpers — `drawBackButton()`/`backPressed()`, `drawPageDots()`, and empty hooks `onSpeech()` / `onSwipeLeft()` that individual screens override. |
| `Rect` | Tiny value type bundling a region's `x, y, w, h` — one source of truth for drawing **and** hit‑testing. |
| `Utils` | Global helpers: `hitRect(...)` (point‑in‑rectangle) and `drawFitted(img, rect)` (draw an image into a box, centred, without distortion). |
| `Theme` | Global colour & layout constants (`ACCENT`, `BG`, `TEXT`, `BORDER_RADIUS`, `SCREEN_PADDING`, `BACK_BOX`, …). |
| `Screen_*` | One concrete screen per function (see below). |

Naming convention: screen classes are prefixed `Screen_` (one `.pde` tab each). Processing only compiles `.pde` files in the sketch root, so subfolders aren't used.

Adding a feature = one new `Screen` subclass + one `registerScreen(...)` line.

**Screens**

- `Screen_Hub` — central 2×2 navigation tiles (companion, goals, log menu, progress).
- `Screen_Sprout` — the companion; watering can + animated rain + Sprout reaction, water sound.
- `Screen_Goals` — set the step goal by voice (mic + waveform + spoken prompt).
- `Screen_LogMenu` — 2×2 menu to the individual loggers.
- `Screen_LogExercise` — workout: double‑tap timer + simulated heart rate with a repeating "take a break" vital alert.
- `Screen_LogFood` — voice vegetarian check‑in (yes/no) with a weekly Mon–Sun leaf/x row that feeds the streak.
- `Screen_LogSleep` — shake‑to‑wake, sleep/wake times, moon → sun.
- `Screen_LogHydration` — water logging with ± and preset buttons.
- `Screen_Progress` — daily progress overview: prepared step‑ring image on top, three code‑drawn status bars below (reusable `drawStatus()` helper), page dots.
- `Screen_Streak` — the "Days without meat" streak; the live count is drawn on the star, with page dots.

---

## Project structure

```
Sprout_Digital_Smartwatch_Companion/
├── Sprout_Digital_Smartwatch_Companion.pde   # main tab: setup(), draw(), tap/swipe + listenEvent(), global state (goals & current values)
├── Screen.pde                                # abstract screen base + shared UI helpers
├── ScreenManager.pde                         # screen state machine + navigation
├── Rect.pde                                  # x/y/w/h value type
├── Utils.pde                                 # hitRect(), drawFitted()
├── Theme.pde                                 # global colour & layout constants
├── Screen_Hub.pde                            # 2×2 navigation hub
├── Screen_Sprout.pde                         # companion / watering screen
├── Screen_Goals.pde                          # voice step‑goal screen
├── Screen_LogMenu.pde                        # logging sub‑menu
├── Screen_LogExercise.pde / _LogFood.pde / _LogSleep.pde / _LogHydration.pde
├── Screen_Progress.pde                       # progress overview
├── Screen_Streak.pde                         # meat‑free streak
└── data/
    ├── images/                               # icons + Sprout sprites (head, happy, sad, content, …)
    ├── sounds/                               # feedback & narration audio (incl. water‑bubbles.mp3)
    ├── sample.config.xml                     # CMUSphinx recogniser configuration
    └── sample.gram                           # JSGF grammar (step‑goal phrases + yes/no)
```

> In Processing, each `.pde` file is a separate tab and all tabs compile together as one sketch.

### Build status

**Complete.** All screens are implemented and wired: Hub, Sprout (watering + reaction), Goals (voice step goal), Log menu, Log Exercise (workout + vital alert), Log Food (voice vegetarian check‑in), Log Sleep (shake‑to‑wake), Log Hydration (± / presets), Progress (step ring + live status bars from `exerciseMin` / `hydrationMl` / `sleepHours` vs. goals), and Streak (live count on the star). Navigation (tap, swipe, back/forward arrows) and audio feedback are in place across the app.

---

## Voice recognition setup

Speech recognition runs **offline** through CMUSphinx (wrapped by SimpleSpeech):

1. Install the **SimpleSpeech** library into your Processing `libraries/` folder (alongside `minim`).
2. `data/sample.gram` holds the JSGF grammar — a small fixed vocabulary: step‑goal phrases (`five … twenty` + `thousand`) plus `yes` / `no` for the vegetarian check‑in. Small vocabularies are far more reliable with Sphinx.
3. `data/sample.config.xml` configures the recogniser. **Its `grammarLocation` must point (absolute `file:///` path) at this sketch's `data` folder** — the most common setup pitfall.

Recognition is gated to the two voice screens: on **Goals** say e.g. *"ten thousand"* to set the step goal; on **Log Food** say *"yes"* / *"no"* for the vegetarian check‑in. Recognised words print to the console (`heard: …`).

---

## Getting started

1. Install [Processing](https://processing.org/download).
2. Install the required libraries (`minim` and `SimpleSpeech`) into your Processing `libraries/` folder.
3. Clone this repository:
   ```bash
   git clone git@github.com:bendfriedman/HCI---Digital-Smartwatch-Companion.git
   ```
4. Open `Sprout_Digital_Smartwatch_Companion.pde` and press **Run** (▶). The window opens at 312 × 390 px; interact with the mouse as you would with touch.

---

## HCI design rationale

The design is grounded in established usability principles.

**Gestalt laws.** The 2×2 hub uses *proximity* and *common region* to group related actions; a consistent green frame, shared tile shapes, and recurring page dots use *similarity* and *continuity* so the interface reads as one coherent system.

**Fitts's law.** Touch targets are large and placed toward screen edges/corners; minimum sizes and padding live centrally in `Theme`.

**Hicks's law.** Each screen offers few, clearly distinct choices (e.g. a small set of step‑goal phrases, not free text), keeping decision time low on a watch‑sized screen.

**Nielsen's 5 usability components.**
- *Learnability* — the plant metaphor and icon‑first layout are self‑explanatory; no tutorial needed.
- *Efficiency* — common actions are one tap; swipe and voice act as accelerators.
- *Memorability* — a consistent hub‑and‑spoke structure and shared visual language make the app easy to return to.
- *Errors* — a visible back/forward arrow accompanies every gesture, and explicit colour/state resets prevent leftover‑state glitches.
- *Satisfaction* — Sprout's reactions, growth, and streaks make healthy behaviour rewarding.

---

## Authors

Team project (max. 2 students) — Human‑Computer Interaction course.

- Ben Friedman ([@bendfriedman](https://github.com/bendfriedman))
- *Add teammate here*

---

*Built with Processing. Sprout says thanks for moving today.* 🌱
