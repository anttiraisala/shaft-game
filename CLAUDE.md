# Project instructions

## Language

Everything in this repository is written in English: code, comments, UI text, documentation, configuration, tests, data, commit messages, file and branch names. Chat with the maintainer happens in the language the maintainer writes in (usually Finnish). Do not add localization unless explicitly asked.

## Godot code

- Godot 4.2 or newer, standard build, GDScript only.
- Static typing everywhere. The project setting `untyped_declaration` is an error.
- Game rules live in small separate types (`godot/scripts/rules.gd` and similar), not in graphics code. `docs/rules.md` is the source of truth and must match the code.
- Floor generation uses the custom 16-bit xorshift in `floor_rng.gd`, never Godot's random number generator, so the Commodore 64 version can reproduce it.

## Every commit

Before committing, make sure the documentation is up to date in the same change:

- `README.md` (status, how to run, repository layout)
- `docs/project-plan.md` (roadmap and decisions)
- `docs/rules.md` (rules, if gameplay or the generator changed)
- Test vectors in `shared/test-vectors/` if the generator changed (regenerate with `tools/generate_test_vectors.py`)

After pushing, print the commands the maintainer runs on their own computer to update their local copy:

```
cd <path to>/shaft-game
git pull origin master
```

and, if they have no copy yet:

```
git clone https://github.com/anttiraisala/shaft-game.git
```

The default branch is `master`.
