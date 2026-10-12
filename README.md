# Shaft Game

A 2D side-view puzzle-platformer set in a vertical concrete shaft. A heavy steel platform loaded with food descends through hundreds of stacked cells. You ride it, decide what to eat, what to share and what to leave behind, and try to deliver one untouched dessert as a message to the top.

The game is inspired by the 2019 Spanish film *The Platform* (*El hoyo*). It must grow its own names, characters and visual identity before any public release.

## Status

Prototype v0.1: a basic playable loop in Godot. Everything beyond that is still ideas. See [docs/project-plan.md](docs/project-plan.md) for the concept, mechanics and roadmap, and [docs/rules.md](docs/rules.md) for the exact rules.

What works today:

- One room with a shaft and a moving platform with a green and red signal light.
- Run and jump, fetch the food from the ledge and get back on the platform in time.
- Hunger, floor counter (1 to 333) and a restart key.
- Floor layouts generated from the floor number with a 16-bit xorshift generator, verified against shared test vectors.

## How to run

1. Install Godot 4.2 or newer (the standard build, not the .NET build).
2. Open the `godot/` folder as a project (Import, select `godot/project.godot`) and press F5.

Controls: A/D or arrow keys to move, Space/W/Up to jump, R to restart.

The project treats untyped GDScript declarations as errors. If the editor reports one, add the missing type.

### Check the shared test vectors

```
godot --headless --path godot --import
godot --headless --path godot --script res://tests/check_vectors.gd
```

The second command prints `Checked 333 floors, 0 failures.` when the GDScript generator matches the reference vectors. To regenerate the vectors: `python3 tools/generate_test_vectors.py`.

## Repository layout

```
docs/        design, rules and plans
shared/      data shared by all versions (test vectors)
godot/       Godot 4 project
tools/       helper scripts
c64/         planned: Commodore 64 version
```

## Targets

- **Godot 4** (standard build, GDScript with static typing). Primary version.
- **Web** build, produced by the Godot web export (planned).
- **Commodore 64** version, a separate implementation that follows the same rules (planned).

All targets live in this single repository.

## Language rule

Everything in this repository (code, comments, UI text, documentation, configuration, tests, data, commit messages, file and branch names) is written in English.
