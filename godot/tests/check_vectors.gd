extends SceneTree
## Checks the GDScript floor generator against the shared test vectors.
##
## Run from the repository root:
##   godot --headless --path godot --script res://tests/check_vectors.gd
## The process exits with code 0 when every row matches, otherwise with 1.

const VECTOR_FILE: String = "../shared/test-vectors/floor_layout.csv"


func _init() -> void:
	var path: String = ProjectSettings.globalize_path("res://").path_join(VECTOR_FILE)
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Cannot open test vector file: %s" % path)
		quit(1)
		return

	var checked: int = 0
	var failures: int = 0
	while not file.eof_reached():
		var line: String = file.get_line().strip_edges()
		if line.is_empty() or line.begins_with("#"):
			continue
		var columns: PackedStringArray = line.split(",")
		if columns.size() != 8:
			push_error("Bad row: %s" % line)
			failures += 1
			continue
		if not _row_matches(columns):
			push_error("Mismatch on floor %s" % columns[0])
			failures += 1
		checked += 1

	print("Checked %d floors, %d failures." % [checked, failures])
	quit(1 if failures > 0 or checked == 0 else 0)


func _row_matches(columns: PackedStringArray) -> bool:
	var floor_number: int = columns[0].to_int()
	var seed_value: int = FloorRng.seed_for_floor(floor_number)
	var state_1: int = FloorRng.next_state(seed_value)
	var state_2: int = FloorRng.next_state(state_1)
	var state_3: int = FloorRng.next_state(state_2)
	var layout: FloorLayout = FloorLayout.from_floor(floor_number)
	var on_left_expected: bool = columns[5].to_int() == 1
	return (
		seed_value == columns[1].to_int()
		and state_1 == columns[2].to_int()
		and state_2 == columns[3].to_int()
		and state_3 == columns[4].to_int()
		and layout.on_left == on_left_expected
		and layout.ledge_x == columns[6].to_int()
		and layout.ledge_height == columns[7].to_int()
	)
