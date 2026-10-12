class_name Rules
extends RefCounted
## Tunable game rules, kept separate from graphics.
## Keep this file in sync with docs/rules.md.

const SCREEN_WIDTH: int = 1280
const SCREEN_HEIGHT: int = 720

## Y coordinate of the top surface of the room floor.
const ROOM_FLOOR_Y: float = 600.0
const SHAFT_LEFT: float = 520.0
const SHAFT_RIGHT: float = 760.0

const PLATFORM_WIDTH: float = 236.0
const PLATFORM_THICKNESS: float = 16.0
const PLATFORM_SPEED: float = 300.0

const TOTAL_FLOORS: int = 333
const START_FLOOR: int = 1

const MAX_HUNGER: int = 5
const HUNGER_LOSS_PER_FLOOR: int = 1
const FOOD_HUNGER_RESTORE: int = 2

## Seconds the platform stays stopped on the first and on the last floor.
const STOP_TIME_TOP: float = 14.0
const STOP_TIME_BOTTOM: float = 5.0
## The light turns red this many seconds before the platform leaves.
const WARNING_TIME: float = 2.0

const LEDGE_WIDTH: float = 140.0
const LEDGE_THICKNESS: float = 14.0


## Returns how long the platform stays stopped on the given floor.
## The time shrinks linearly with depth, so pressure grows toward the bottom.
static func stop_time_for_floor(floor_number: int) -> float:
	var depth: float = float(floor_number - 1) / float(TOTAL_FLOORS - 1)
	return lerpf(STOP_TIME_TOP, STOP_TIME_BOTTOM, clampf(depth, 0.0, 1.0))
