extends Node2D
## Main scene script: builds the room, runs one round and shows the HUD.
##
## One round: the platform stops on each floor in turn. Fetch the food from
## the ledge and get back on the platform before the light turns red and the
## platform leaves. Every floor costs hunger; food restores it.

const COLOR_BACKGROUND: Color = Color("#2b2a28")
const COLOR_WALL: Color = Color("#4a4742")
const COLOR_SHAFT: Color = Color("#1a1917")
const COLOR_SLAB: Color = Color("#8a857a")
const LAMP_POSITION: Vector2 = Vector2(800.0, 130.0)
const LAMP_RADIUS: float = 20.0

var _platform: ShaftPlatform
var _player: Player
var _ledge: Ledge
var _food: FoodItem
var _hud_label: Label
var _message_label: Label

var _floor_number: int = Rules.START_FLOOR
var _hunger: int = Rules.MAX_HUNGER
var _food_collected: int = 0
var _round_over: bool = false


func _ready() -> void:
	InputSetup.register()
	_build_room()
	_build_hud()

	_player = Player.new()
	_player.position = Vector2(300.0, Rules.ROOM_FLOOR_Y - Player.SIZE.y * 0.5)
	add_child(_player)

	_platform = ShaftPlatform.new()
	add_child(_platform)
	_platform.begin_arrival(_floor_number)

	_spawn_floor_content()
	_update_hud()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"restart"):
		get_tree().reload_current_scene()
		return
	_update_hud()
	queue_redraw()


func _physics_process(delta: float) -> void:
	if _round_over:
		return

	# The platform moves first, then carries the player standing on it.
	var was_riding: bool = _platform.has_rider(_player)
	var moved: float = _platform.advance(delta)
	if was_riding:
		_player.position.y += moved

	if _platform.started_leaving_this_frame and not was_riding:
		_end_round("You missed the platform.")
	elif _platform.exited_this_frame:
		_on_platform_exited(was_riding)
	elif _player.position.y > float(Rules.SCREEN_HEIGHT) + 300.0 and not was_riding:
		_end_round("You fell down the shaft.")


func _on_platform_exited(was_riding: bool) -> void:
	if not was_riding:
		_end_round("You missed the platform.")
		return

	_floor_number += 1
	_hunger -= Rules.HUNGER_LOSS_PER_FLOOR
	if _floor_number > Rules.TOTAL_FLOORS:
		_end_round("You reached the dark below. Round complete!")
		return
	if _hunger <= 0:
		_end_round("You starved on floor %d." % (_floor_number - 1))
		return

	var jump: float = _platform.begin_arrival(_floor_number)
	_player.position.y += jump
	_spawn_floor_content()


func _spawn_floor_content() -> void:
	if is_instance_valid(_ledge):
		_ledge.queue_free()
	if is_instance_valid(_food):
		_food.queue_free()

	var layout: FloorLayout = FloorLayout.from_floor(_floor_number)
	var ledge_top: float = Rules.ROOM_FLOOR_Y - float(layout.ledge_height)

	_ledge = Ledge.new()
	_ledge.position = Vector2(float(layout.ledge_x), ledge_top + Rules.LEDGE_THICKNESS * 0.5)
	add_child(_ledge)

	_food = FoodItem.new()
	_food.position = Vector2(float(layout.ledge_x), ledge_top - FoodItem.RADIUS - 6.0)
	_food.collected.connect(_on_food_collected)
	add_child(_food)


func _on_food_collected() -> void:
	_food_collected += 1
	_hunger = mini(_hunger + Rules.FOOD_HUNGER_RESTORE, Rules.MAX_HUNGER)


func _end_round(message: String) -> void:
	_round_over = true
	_player.set_physics_process(false)
	_message_label.text = "%s\nFood collected: %d\nPress R to restart" % [message, _food_collected]


func _build_room() -> void:
	var half_width: float = float(Rules.SCREEN_WIDTH) * 0.5
	var slab_height: float = float(Rules.SCREEN_HEIGHT) - Rules.ROOM_FLOOR_Y
	var slab_y: float = Rules.ROOM_FLOOR_Y + slab_height * 0.5
	var left_width: float = Rules.SHAFT_LEFT
	var right_width: float = float(Rules.SCREEN_WIDTH) - Rules.SHAFT_RIGHT

	_add_static_rect(Vector2(left_width * 0.5, slab_y), Vector2(left_width, slab_height))
	_add_static_rect(Vector2(Rules.SHAFT_RIGHT + right_width * 0.5, slab_y), Vector2(right_width, slab_height))
	# Outer walls keep the player inside the screen.
	_add_static_rect(Vector2(-20.0, 0.0), Vector2(40.0, 4000.0))
	_add_static_rect(Vector2(float(Rules.SCREEN_WIDTH) + 20.0, 0.0), Vector2(40.0, 4000.0))
	# The ceiling stops jumps from leaving the screen.
	_add_static_rect(Vector2(half_width, -20.0), Vector2(float(Rules.SCREEN_WIDTH), 40.0))


func _add_static_rect(center: Vector2, size: Vector2) -> void:
	var body: StaticBody2D = StaticBody2D.new()
	body.position = center
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = size
	var collision: CollisionShape2D = CollisionShape2D.new()
	collision.shape = shape
	body.add_child(collision)
	add_child(body)


func _build_hud() -> void:
	var layer: CanvasLayer = CanvasLayer.new()
	add_child(layer)

	_hud_label = Label.new()
	_hud_label.position = Vector2(24.0, 16.0)
	_hud_label.add_theme_font_size_override(&"font_size", 24)
	layer.add_child(_hud_label)

	_message_label = Label.new()
	_message_label.position = Vector2(240.0, 260.0)
	_message_label.size = Vector2(800.0, 160.0)
	_message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_message_label.add_theme_font_size_override(&"font_size", 32)
	layer.add_child(_message_label)


func _update_hud() -> void:
	var hunger_bar: String = "#".repeat(maxi(_hunger, 0)) + "-".repeat(maxi(Rules.MAX_HUNGER - _hunger, 0))
	_hud_label.text = "Floor %d / %d\nHunger [%s]\nFood collected: %d" % [
		_floor_number, Rules.TOTAL_FLOORS, hunger_bar, _food_collected
	]


func _draw() -> void:
	var screen_width: float = float(Rules.SCREEN_WIDTH)
	var screen_height: float = float(Rules.SCREEN_HEIGHT)
	draw_rect(Rect2(0.0, 0.0, screen_width, screen_height), COLOR_BACKGROUND)
	draw_rect(Rect2(0.0, 0.0, Rules.SHAFT_LEFT, Rules.ROOM_FLOOR_Y), COLOR_WALL)
	draw_rect(Rect2(Rules.SHAFT_RIGHT, 0.0, screen_width - Rules.SHAFT_RIGHT, Rules.ROOM_FLOOR_Y), COLOR_WALL)
	draw_rect(Rect2(Rules.SHAFT_LEFT, 0.0, Rules.SHAFT_RIGHT - Rules.SHAFT_LEFT, screen_height), COLOR_SHAFT)
	draw_rect(Rect2(0.0, Rules.ROOM_FLOOR_Y, Rules.SHAFT_LEFT, screen_height - Rules.ROOM_FLOOR_Y), COLOR_SLAB)
	draw_rect(Rect2(Rules.SHAFT_RIGHT, Rules.ROOM_FLOOR_Y, screen_width - Rules.SHAFT_RIGHT, screen_height - Rules.ROOM_FLOOR_Y), COLOR_SLAB)

	# Floor number painted on the wall.
	var font: Font = ThemeDB.fallback_font
	draw_string(font, Vector2(40.0, 560.0), str(_floor_number), HORIZONTAL_ALIGNMENT_LEFT, -1.0, 96, Color(1.0, 1.0, 1.0, 0.12))

	# Signal lamp on the shaft wall with the seconds left.
	if _platform != null:
		draw_circle(LAMP_POSITION, LAMP_RADIUS + 6.0, Color("#111111"))
		draw_circle(LAMP_POSITION, LAMP_RADIUS, _platform.light_color())
		var seconds: int = _platform.seconds_left()
		if seconds >= 0:
			draw_string(font, LAMP_POSITION + Vector2(-8.0, 56.0), str(seconds), HORIZONTAL_ALIGNMENT_LEFT, -1.0, 28, Color("#d9d4c8"))
