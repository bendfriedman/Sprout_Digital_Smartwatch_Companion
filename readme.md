# 🌱 Sprout — Digital Smartwatch Companion

A smartwatch app built in **Processing** featuring **Sprout**, a digital plant‑companion that motivates you to move more, eat better, and take responsibility. You keep Sprout alive and thriving by exercising, choosing healthier food, and checking in — so caring for the companion and caring for yourself become the same loop.

> University project for a Human‑Computer Interaction course. The brief: design an ergonomic, self‑explaining smartwatch app that realises three behaviour goals — **movement**, **nutrition coaching**, and **responsibility training** — with a fully hand‑built UI.

---

## Concept

Sprout is a small plant creature living on your wrist. It can't take care of itself — it depends on *you*. Move and it grows; eat well and it flourishes; neglect it and it wilts. Because Sprout is literally a plant, the metaphor is self‑explanatory: a plant thrives on activity and good nutrition, exactly the behaviour the app encourages. No tutorial required — the interaction explains itself.

The standout mechanic is a **"Days without meat"** streak: every meat‑free day grows the streak and visibly strengthens Sprout, turning the abstract goal of "eat more vegetables, less meat" into a tangible, rewarding ritual.

---

## Features

Ten functions, covering all three required behaviour areas (the brief asks for a minimum of eight):

### 🏃 Movement
- **Set step goal** — define a daily step target.
- **Log workout** — start/stop a workout via gesture with a live timer.
- **Live vital updates** — automatic heart‑rate alert during a workout ("Take a break — your pulse: 135 bpm").
- **View progress history** — daily rings and bars for exercise, hydration, and sleep.

### 🥦 Nutrition coach
- **Set nutrition goal** — define an eating target (e.g. meat‑free days per week).
- **Set hydration goal** — define a daily water target.
- **Log meal** — quick meal check‑in (meat‑free / vegetarian) that feeds the streak.

### 🌟 Responsibility trainer
- **Log mood** — touch‑based daily check‑in (traffic‑light: good / okay / low).
- **Log sleep** — gesture‑based sleep logging (bed → wake time).
- **View streak** — the "Days without meat" streak and Sprout's growth state; feeding and caring for the companion.

Every action gives immediate **feedback** — a button sound, a success cue, and a reaction from Sprout — so the user always knows an action registered (see `data/sounds/`).

---

## Tech stack & constraints

- **Engine:** [Processing](https://processing.org/) (Java mode)
- **Target device:** Apple Watch Series 1 dimensions — **312 × 390 px**
- **Allowed libraries only:** `minim`, `SimpleSpeech`, `FreeTTS`, `CMUSphinx`
  - `minim` — audio playback for button/success sounds and microphone level.
  - `FreeTTS` / `SimpleSpeech` — text‑to‑speech (Sprout can speak).
  - `CMUSphinx` — offline speech recognition for voice check‑ins (small `yes`/`no` vocabulary).
- **Hand‑built UI:** all interface elements (buttons, sliders, tiles) are coded from scratch. **No external UI frameworks** are used — this is a hard requirement of the assignment.

---

## Architecture

The app is built around a lightweight **screen state machine**, so each function is an isolated, self‑contained screen and `draw()` stays trivial.

```
mousePressed() ─▶ ScreenManager ─▶ currentScreen.handleTouch(x, y)
                                      └▶ updates data + plays sound + may switchTo()
draw()         ─▶ ScreenManager ─▶ currentScreen.update() + .display()
```

**Core classes**

| Class | Responsibility |
|-------|----------------|
| `ScreenManager` | Holds all screens, tracks `currentScreen`, switches between them (`registerScreen`, `switchTo`, `render`). |
| `Screen` (abstract) | Base for every screen: `display()`, `handleTouch()`, `update()`, `onEnter()`. |
| `HubScreen`, `WorkoutScreen`, … | One concrete screen per function; each owns its own UI elements. |

Adding a feature = one new `Screen` subclass + one `registerScreen(...)` line. The scaffold itself is never touched again.

Planned supporting classes as the build grows: a self‑coded `UIElement`/`Button` hierarchy, a `Sprout` companion class (state + animation), an `AppState` data model (separating data from rendering), a central `Theme` for colours and touch‑target sizes, and a `SoundManager` wrapping `minim`.

---

## Project structure

```
Sprout_Digital_Smartwatch_Companion/
├── Sprout_Digital_Smartwatch_Companion.pde   # main tab: setup(), draw(), mousePressed()
├── Screen.pde                                # abstract screen base
├── ScreenManager.pde                         # screen state machine
├── HubScreen.pde                             # central 4‑tile navigation hub
├── data/
│   ├── images/                               # sprites and icons
│   └── sounds/                               # feedback & narration audio
└── readme.md
```

> In Processing, each `.pde` file is a separate tab and all tabs compile together as one sketch.

---

## Getting started

1. Install [Processing](https://processing.org/download).
2. Install the required libraries (`minim` via *Sketch → Import Library → Add Library*; `SimpleSpeech` / `FreeTTS` / `CMUSphinx` into your Processing `libraries/` folder).
3. Clone this repository:
   ```bash
   git clone git@github.com:bendfriedman/HCI---Digital-Smartwatch-Companion.git
   ```
4. Open `Sprout_Digital_Smartwatch_Companion.pde` in Processing and press **Run** (▶).

The sketch window opens at 312 × 390 px, simulating the watch face. Interact with the mouse as you would with touch.

---

## HCI design rationale

The design is grounded in established usability principles — useful both as a design guide and for the project writeup.

**Gestalt laws.** The 4‑tile hub uses *proximity* and *common region* to group related actions; consistent shapes, colours, and the recurring green frame use *similarity* so the interface reads as one coherent system; progress rings and the weekday streak row rely on *continuity* to convey ongoing state.

**Fitts's law.** Touch targets are large and placed toward screen edges/corners to minimise acquisition time on a small display. Minimum target sizes live in one central `Theme` definition for consistency.

**Hicks's law.** Each screen offers few, clearly distinct choices (e.g. the meal check‑in is a small set of options, not free text), keeping decision time low — essential on a watch‑sized screen.

**Nielsen's 5 usability components.**
- *Learnability* — the plant metaphor and icon‑first layout are self‑explanatory; no tutorial needed.
- *Efficiency* — common logs are one or two taps; gesture and voice shortcuts speed frequent actions.
- *Memorability* — a consistent hub‑and‑spoke structure and shared visual language make the app easy to return to.
- *Errors* — confirmation steps and a touch fallback for voice input prevent and recover from mistakes.
- *Satisfaction* — Sprout's reactions, growth, and streaks make healthy behaviour rewarding.

**Multimodal input.** The app deliberately demonstrates three input modalities suited to a small touchscreen: **touch** (mood, water), **gesture** (workout, sleep), and **voice** (Sprout check‑ins via CMUSphinx) — each chosen to fit its task.

---

## Authors

Team project (max. 2 students) — Human‑Computer Interaction course.

- Ben Friedman ([@bendfriedman](https://github.com/bendfriedman))
- *Add teammate here*

---

*Built with Processing. Sprout says thanks for moving today.* 🌱
