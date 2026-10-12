class_name FloorRng
extends RefCounted
## 16-bit xorshift generator (shifts 7, 9, 8).
## Deliberately not Godot's RandomNumberGenerator: the Commodore 64 version
## must be able to reproduce exactly the same numbers from the same seed.
## See docs/rules.md and shared/test-vectors/floor_layout.csv.


## Returns the next generator state. The state must never be zero.
static func next_state(state: int) -> int:
	var x: int = state & 0xFFFF
	x = (x ^ (x << 7)) & 0xFFFF
	x = x ^ (x >> 9)
	x = (x ^ (x << 8)) & 0xFFFF
	return x


## Returns the non-zero generator seed for a floor number.
static func seed_for_floor(floor_number: int) -> int:
	var seed_value: int = (floor_number * 40503 + 1) & 0xFFFF
	if seed_value == 0:
		seed_value = 1
	return seed_value
