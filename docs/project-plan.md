# Project Plan

Status: ideation. Nothing here is final; it records everything discussed so far.

## 1. Concept

The player rides a food platform down through a tower of cells. Each cell holds a few prisoners. Food is limited and the upper floors take what they want, so the lower floors get less. The player's choices about eating, sharing and leaving food decide how the run feels.

The source of inspiration is the film *The Platform* (*El hoyo*, 2019). Names, characters and visuals must be original before release.

## 2. Presentation

- 2D, side view.
- The platform travels top to bottom through the shaft.
- The screen mainly shows one room at a time. The rooms above and below are partly visible at the screen edges, so the player can see who is waiting below before the platform arrives.
- The current floor number is always visible.

## 3. Core loop

1. The platform stops on a floor for a limited time.
2. The player leaves the platform, solves a small room puzzle to reach food, and returns before the platform departs.
3. The player decides what to eat, what to carry on, and what to share with the floors below.
4. The platform moves on. Whatever was left in the room has consequences (see section 5).

## 4. Floors and rounds

- There are 333 floors, numbered from the top. Below the last floor is a huge dark empty space.
- A round starts on some floor, and the numbers count up toward 333. The starting floor is random, as in a monthly reshuffle: the same round plays very differently high up (plenty of food, easy) and low down (scraps, survival).
- At the bottom the platform enters the dark space, where a results screen can show who ate, who went hungry and what came back. It then shoots upward at high speed and stops at floor 0. The fast ascent past the floor numbers is a strong visual reward or punishment at the end of a round.

## 5. Food as resource and moral choice

- Food is physical: it has to be carried, cut and sent down.
- A hunger meter keeps the player moving. Weak players jump lower and move slower.
- Food is limited relative to the number of floors below. An even split is not enough for everyone, so the player has to prioritize.
- **Leftover rule:** food left in a room after the platform departs makes the room either burning hot or freezing cold. A short warning (frost on the walls, glowing grates, a humming sound) tells the player which way it will go. The effect hurts whoever is in the room, and it grows with the amount of food left behind. Small leftovers are an annoyance; large ones are deadly.
- Options for what decides hot or cold: readable (for example meat and soup heat, fish and ice cream cool) for the puzzle mode, and random for the hardest levels.
- Leftovers can also be a tool: heat melts ice or burns a rope, cold freezes a puddle into a step or blocks a door.

## 6. Items

At the start of a round the player picks one item. Each item defines a puzzle style:

- **Knife:** cuts portions, ropes and crates; also a weapon. Cuts are permanent.
- **Book:** pages contain hints for the floor puzzles. The pages can be torn out and used as a bridge or kindling, but the hints are then lost.
- **Rope:** hang under the platform, lower food downward, swing across gaps or reach high shelves.
- **Lamp or mirror:** light is valuable on the dark lower floors; share it or keep it.
- **Magnet:** pulls metal objects such as cans from far away.

Items can be traded with the floor below, but then the player lacks the tool.

## 7. The message item

The central goal is to carry one untouched dessert to the bottom and send it back up as a message that the system can change. It must never be left in a room (heat or cold ruins it). The tension is constant: eat it, protect it, or defend it from others.

## 8. Puzzle types

1. **Timing:** fetch the food and get back before the platform leaves.
2. **Route:** obstacles in the room that an item helps to cross.
3. **Weight:** the platform only stops if its load is suitable, so food and items must be balanced.
4. **Social:** the resident of a floor needs something, and the player decides whether to help.
5. **Memory:** the round repeats on a new floor, and the player can fix what they missed before.

## 9. Lights

Two lights, red and green, appear on the platform and on the shaft walls.

- Green: the platform is stopped and the player can act.
- Red: the platform is about to leave; everything the player wants must be aboard, and leftovers start to take effect.
- The green time varies by floor: long high up, short low down, so the pressure rises without an extra timer.
- Optional twist: on some floors the light is broken or switches at the wrong time, and the player must read the platform's sound or vibration.

Note: the exact meaning of the lights in the film was not verified. The meaning above is the game's own design and does not need to match it.

## 10. Other ideas

- A hidden morality score that affects the ending (did you help or take?).
- Co-op: two players on a floor who must decide whether to share.
- A girl riding the platform as a roaming NPC: either someone the player protects, or a mirror whose behavior depends on what the player did before.
- Atmosphere: gray concrete, light fading with depth, the hum of the platform. Colors get colder and darker with depth, while the red and green lights stand out.

## 11. Art direction

- Concept sketches were drawn in chat as pencil-style black-and-white SVG and as flat color SVG for ten rooms and situations (top floor, middle floor, deep floor, hot room, cold room, red light, green light, rope puzzle, dark bottom, ascent to zero).
- Photorealistic concept images need an image generator. A base prompt plus ten scene prompts were written for that purpose, and they avoid names and imagery from the film.

## 12. Technical decisions

- **Engine:** Godot 4, standard build (not the .NET build).
- **Language:** GDScript with static typing. Set the project setting for untyped declarations to Error so untyped code cannot run.
- **Web:** use Godot's web export and publish it from CI (for example GitHub Pages). Build output is not committed.
- **Commodore 64:** a separate implementation, not a port of the code. It follows the same rules. Constraints: 16 colors, 8 sprites, 64 KB memory, so one room at a time is the right design. Floors are generated from a seed number instead of stored. Hot and cold read well as color, and red and green are in the C64 palette. Toolchain to be chosen later (for example cc65 or KickAssembler).
- **Shared floor generation:** do not use Godot's built-in random number generator. Define a simple custom algorithm (for example a 16-bit xorshift) in the rules document and implement it in both versions. Keep test vectors (seed to expected floor data) in the shared folder, and test both versions against them.
- Rules (food, temperature, lights, floors) live in small separate types in the Godot code (enums and resources) so they stay independent from graphics and can be mirrored on the C64.
- Platform, room and player are separate scenes that communicate through signals.

## 13. Repository structure (single repository)

```
shaft-game/
├── README.md
├── docs/                 design, rules, concept art, prompts
│   └── rules.md          single source of truth for the rules
├── shared/
│   └── test-vectors/     seed to expected floor data
├── godot/                Godot 4 project
├── c64/                  C64 source, build script, graphics
├── tools/                helper scripts
└── .github/workflows/    CI builds
```

Conventions:

- Default branch is `master`, with short-lived feature branches.
- Release tags are per target, for example `godot-v0.1.0` and `c64-v0.1.0`. Releases attach the `.prg`, `.d64` and web build.
- CI runs only the build for the target whose folder changed.
- Each target has its own `.gitignore` section.

## 14. Roadmap

1. Lock the rules on paper in `docs/rules.md`.
2. Build a minimal Godot prototype: one room, a moving platform, a jumping player and a visible floor number.
3. Add food, then temperature, then the lights, one at a time.
4. Define the shared random number algorithm and the test vectors.
5. Expand the Godot version into a full game and publish the web build.
6. Build the C64 version using the same rules and seeds.

## 15. Open questions

- Is the food sharing mainly a calculation and optimization puzzle, or an emotional choice with no right answer?
- Is the hot/cold effect readable or random, and for which difficulty levels?
- The game's own name, characters and visual identity.
- Licensing and the final C64 toolchain.
