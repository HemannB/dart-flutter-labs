# ⚔️ QuestLog

> A gamified habit tracker built to study Flutter and Dart from scratch.

This project is part of the [`dart-flutter-lab`](https://github.com/seuuser/dart-flutter-lab) repository — a personal learning lab for exploring the Flutter/Dart ecosystem through real, functional apps.

---

## 🎯 Purpose

QuestLog exists to learn by doing. Instead of isolated exercises, this project covers real-world Flutter development: state management, local persistence, navigation, theming, animations and Android configuration — all in a single cohesive app.

---

## 💡 Concept

QuestLog turns daily habits into RPG quests. The user sets up goals, logs progress throughout the day and earns XP and pop culture badges as rewards.

The gamification is intentionally simple and fun:
- Complete your water goal → **+80 XP**
- Wake up on time 7 days in a row → **"Wake Up, Neo" badge** 🎬
- Finish a book → **"One Does Not Simply Stop Reading" badge** 🧙
- Level up and watch your profile grow over time

Badges follow a **cinema / gaming / pop culture** theme — Lord of the Rings, The Matrix, Skyrim and more.

---

## 📱 MVP Features

| Screen | Description |
|--------|-------------|
| **Splash** | Animated intro screen with logo and tagline |
| **Onboarding** | 4-step setup: welcome → profile → schedule → done |
| **Home** | Daily quest cards for all 3 active goals |
| **Profile** | XP bar, level, streaks, badges earned and locked |

### Goals

**💧 Water**
- Calculates daily goal from weight and sex (35ml/kg male, 31ml/kg female)
- User logs each glass throughout the day
- Progress bar updates in real time
- Streak and XP on daily completion

**⏰ Wake up early**
- User sets a target wake-up time
- Checks in when awake to confirm
- Weekly and monthly streaks unlock badges

**📚 Reading**
- Tracks pages read per day against a daily goal
- Tracks current book progress (current page / total pages)
- XP on daily goal hit, bonus XP on book completion

### XP System

| Action | XP |
|--------|----|
| Water goal completed | +80 |
| Woke up on time | +50 |
| Daily reading goal hit | +60 |
| Book finished | +200 |
| 7-day streak | +150 |
| Badge unlocked | +100 |

Level formula: `level × 200 XP` per level — scales progressively.

### Badges (9 total)

| Badge | Trigger | Reference |
|-------|---------|-----------|
| Hydration Wizard | 7 days water streak | Lord of the Rings |
| Precious Hydration | 30 days water streak | Gollum |
| Not All Who Wander Are Dehydrated | 100 total water days | Tolkien |
| Wake Up, Neo | 7 days wakeup streak | The Matrix |
| Hey, You're Finally Awake | 30 days wakeup streak | Skyrim |
| The Early Bird Gets the Dragon | 90 days wakeup streak | Skyrim / Dovahkiin |
| One Does Not Simply Stop Reading | First book finished | Lord of the Rings |
| Read the Damn Manual | 30 days reading streak | Sci-fi |
| Knowledge Is Power, Guardian | 5 books finished | Destiny |

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.29 / Dart 3.11 |
| State management | Riverpod 2.x (`Notifier` + `NotifierProvider`) |
| Local database | Hive + hive_flutter |
| Navigation | go_router (`ShellRoute` + bottom nav) |
| Animations | flutter_animate |
| Progress UI | percent_indicator |
| Code generation | build_runner + hive_generator |

---

## 🗂️ Project Structure

```
lib/
├── main.dart                        # Entry point — Hive init, ProviderScope
├── app.dart
├── core/
│   ├── constants.dart               # XP values, badge IDs, Hive box names
│   ├── theme.dart                   # Material 3 dark theme (AppTheme)
│   └── router.dart                  # go_router config + MainShell
├── models/
│   ├── user_profile.dart            # User data + XP/level logic
│   ├── user_profile.g.dart          # Generated Hive adapter
│   ├── goal.dart                    # Goal model (water, wakeup, reading)
│   ├── goal.g.dart
│   ├── goal_log.dart                # Daily log entries
│   ├── goal_log.g.dart
│   └── badge.dart                   # BadgeDefinition + BadgeRegistry (static)
├── services/
│   └── hive_service.dart            # All CRUD + streak calculation
├── providers/
│   └── goals_provider.dart          # Riverpod notifiers for all 3 goals
└── screens/
    ├── splash/
    │   └── splash_screen.dart
    ├── onboarding/
    │   └── onboarding_screen.dart   # 4-step PageView
    ├── home/
    │   └── home_screen.dart         # Goal cards + XP bar
    └── profile/
        └── profile_screen.dart      # Stats + streaks + badges grid
```

---

## 🧠 Key Flutter/Dart Concepts Covered

- **Hive** — NoSQL local storage, TypeAdapters, `HiveObject`, code generation with `build_runner`
- **Riverpod** — `Notifier`, `NotifierProvider`, `ConsumerWidget`, `ConsumerStatefulWidget`, `ref.watch` vs `ref.read`
- **go_router** — declarative routing, `ShellRoute`, `GoRoute`, `redirect`, `context.go()`
- **Material 3** — `ThemeData`, `ColorScheme`, `NavigationBar`, `CardThemeData`
- **flutter_animate** — chaining `.animate()`, `.fadeIn()`, `.slideY()`, `.scale()` with delays
- **PageView** — multi-step form with `PageController`
- **Async patterns** — `async/await`, `Future`, state updates after async ops
- **Computed properties** — XP level logic entirely in the model as getters
- **Android Gradle (Kotlin DSL)** — `build.gradle.kts`, Java version config, desugaring

---

## 🚀 Running the project

### Prerequisites
- Flutter 3.29+
- Dart 3.7+
- Android device or emulator (min SDK 21)

### Setup

```bash
# Clone the repo
git clone https://github.com/seuuser/dart-flutter-lab.git
cd dart-flutter-lab/questlog

# Install dependencies
flutter pub get

# Run on connected device
flutter run
```

> The Hive adapters (`.g.dart` files) are already committed — no need to run `build_runner` unless you change the models.

### If you change a model

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 🗺️ Roadmap

- [ ] Goal configuration screens (glass volume, wake time, current book)
- [ ] Push notifications for water reminders (`flutter_local_notifications`)
- [ ] Native alarm for wake-up goal (`alarm` package)
- [ ] Weekly progress chart (`fl_chart`)
- [ ] Custom badge artwork (pop culture illustrations)
- [ ] Sleep goal
- [ ] Exercise goal
- [ ] Weekly challenge system (combo quests)
- [ ] Android home screen widget

---

## 📸 Screenshots

> Coming soon — badge artwork in progress.

---

## 📄 License

MIT — feel free to use this as a study reference.

---

*"Not all those who wander are unfocused."*