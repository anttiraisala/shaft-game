class_name ShaftPlatform
extends StaticBody2D
## The food platform. It arrives from above, stops on a floor, shows a green
## light, switches to a red light shortly before leaving, and then moves down
## and out of the screen.
##
## The platform is moved by the main script through advance(), so that the
## main script can carry the player along in the same physics frame.

enum State { ARRIVING, STOPPED, LEAVING }

const STOP_Y: float = Rules.ROOM_FLOOR_Y + Rules.PLATFORM_THICKNESS * 0.5
const START_Y: float = -40.0
const EXIT_Y: float = float(Rules.SCREEN_HEIGHT) + 80.0
## How far the player's feet may be from the platform top while it is stopped.
const RIDER_TOLERANCE: float = 3.0
## Looser tolerance while the platform moves, because the player may lag a few
## pixels behind it from one physics frame to the next.
const RIDER_TOLERANCE_MOVING: float = 10.0

const LIGHT_GREEN: Color = Color("#3fbf6a")
const LIGHT_RED: Color = Color("#d9342b")
const LIGHT_OFF: Color = Color("#3a3a3a")

## True during the frame when the platform started to leave the floor.
var started_leaving_this_frame: bool = false
## True during the frame when the platform went out of the screen.
var exited_this_frame: bool = false

var _state: State = State.ARRIVING
var _stop_duration: float = Rules.STOP_TIME_TOP
var _stop_timer: float = 0.0


func _ready() -> void:
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = Vector2(Rules.PLATFORM_WIDTH, Rules.PLATFORM_THICKNESS)
	var collision: CollisionShape2D = CollisionShape2D.new()
	collision.shape = shape
	add_child(collision)


## Starts a new arrival from above for the given floor.
## Returns how far the platform jumped, so that a rider can be moved too.
func begin_arrival(floor_number: int) -> float:
	var old_y: float = position.y
	position = Vector2((Rules.SHAFT_LEFT + Rules.SHAFT_RIGHT) * 0.5, START_Y)
	_stop_duration = Rules.stop_time_for_floor(floor_number)
	_state = State.ARRIVING
	_sync_physics_transform()
	return position.y - old_y


## Moves the platform and returns how far it moved vertically.
func advance(delta: float) -> float:
	started_leaving_this_frame = false
	exited_this_frame = false
	var old_y: float = position.y
	match _state:
		State.ARRIVING:
			position.y = minf(position.y + Rules.PLATFORM_SPEED * delta, STOP_Y)
			if position.y >= STOP_Y:
				_state = State.STOPPED
				_stop_timer = _stop_duration
		State.STOPPED:
			_stop_timer -= delta
			if _stop_timer <= 0.0:
				_state = State.LEAVING
				started_leaving_this_frame = true
		State.LEAVING:
			position.y += Rules.PLATFORM_SPEED * delta
			if position.y >= EXIT_Y:
				exited_this_frame = true
	_sync_physics_transform()
	queue_redraw()
	return position.y - old_y


## Returns true if the player stands on top of the platform.
func has_rider(player: Player) -> bool:
	var platform_top: float = position.y - Rules.PLATFORM_THICKNESS * 0.5
	var reach: float = Rules.PLATFORM_WIDTH * 0.5 + Player.SIZE.x * 0.5 - 2.0
	var tolerance: float = RIDER_TOLERANCE if _state == State.STOPPED else RIDER_TOLERANCE_MOVING
	var same_height: bool = absf(player.feet_y() - platform_top) <= tolerance
	return same_height and absf(player.position.x - position.x) < reach


## Color of the signal light: green while there is time to act, red when
## the platform is about to leave, dark while it is still arriving.
func light_color() -> Color:
	match _state:
		State.STOPPED:
			if _stop_timer > Rules.WARNING_TIME:
				return LIGHT_GREEN
			return LIGHT_RED
		State.LEAVING:
			return LIGHT_RED
	return LIGHT_OFF


## Whole seconds left before the platform leaves, or -1 if it is not stopped.
func seconds_left() -> int:
	if _state != State.STOPPED:
		return -1
	return maxi(ceili(_stop_timer), 0)


## Tells the physics server the new position right away. Without this, Godot
## updates a moved static body only after all physics callbacks of the frame,
## and the player would collide with the platform's previous position.
func _sync_physics_transform() -> void:
	PhysicsServer2D.body_set_state(get_rid(), PhysicsServer2D.BODY_STATE_TRANSFORM, global_transform)


func _draw() -> void:
	var half_width: float = Rules.PLATFORM_WIDTH * 0.5
	var half_thickness: float = Rules.PLATFORM_THICKNESS * 0.5
	draw_rect(Rect2(-half_width, -half_thickness, Rules.PLATFORM_WIDTH, Rules.PLATFORM_THICKNESS), Color("#4a4640"))
	draw_circle(Vector2(-70.0, -half_thickness - 5.0), 6.0, Color("#c93a3a"))
	draw_circle(Vector2(-40.0, -half_thickness - 5.0), 6.0, Color("#6aa84f"))
	draw_circle(Vector2(-10.0, -half_thickness - 4.0), 5.0, Color("#d9a441"))
	draw_circle(Vector2(25.0, -half_thickness - 5.0), 6.0, Color("#b5532a"))
	draw_circle(Vector2(60.0, -half_thickness - 4.0), 5.0, Color("#f4b6c8"))
