class_name InputSetup
extends RefCounted
## Registers the keyboard actions at runtime, so the project file stays simple.


static func register() -> void:
	_add_key_action(&"move_left", [KEY_A, KEY_LEFT])
	_add_key_action(&"move_right", [KEY_D, KEY_RIGHT])
	_add_key_action(&"jump", [KEY_SPACE, KEY_W, KEY_UP])
	_add_key_action(&"restart", [KEY_R])


static func _add_key_action(action: StringName, keys: Array[Key]) -> void:
	if InputMap.has_action(action):
		return
	InputMap.add_action(action)
	for key: Key in keys:
		var event: InputEventKey = InputEventKey.new()
		event.physical_keycode = key
		InputMap.action_add_event(action, event)
