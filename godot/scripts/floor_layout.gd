class_name FloorLayout
extends RefCounted
## Describes what a single floor contains, derived only from its floor number.

## True if the ledge with the food is in the left room, false for the right room.
var on_left: bool = true
## Horizontal center of the ledge in pixels.
var ledge_x: int = 0
## Height of the ledge top above the room floor in pixels.
var ledge_height: int = 0


## Builds the layout of a floor. Same floor number always gives the same layout.
static func from_floor(floor_number: int) -> FloorLayout:
	var state_1: int = FloorRng.next_state(FloorRng.seed_for_floor(floor_number))
	var state_2: int = FloorRng.next_state(state_1)
	var state_3: int = FloorRng.next_state(state_2)

	var layout: FloorLayout = FloorLayout.new()
	layout.on_left = (state_1 & 1) == 0
	var room_start: int = 80 if layout.on_left else 840
	layout.ledge_x = room_start + state_2 % 361
	layout.ledge_height = 80 + state_3 % 31
	return layout
