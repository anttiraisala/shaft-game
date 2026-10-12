class_name Player
extends CharacterBody2D
## The player: runs left and right and jumps. Drawn as a simple rectangle.

const SIZE: Vector2 = Vector2(28.0, 48.0)
const MOVE_SPEED: float = 260.0
const JUMP_VELOCITY: float = -620.0
const GRAVITY: float = 1500.0
const MAX_FALL_SPEED: float = 900.0


func _ready() -> void:
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = SIZE
	var collision: CollisionShape2D = CollisionShape2D.new()
	collision.shape = shape
	add_child(collision)


func _physics_process(delta: float) -> void:
	velocity.x = Input.get_axis(&"move_left", &"move_right") * MOVE_SPEED
	velocity.y = minf(velocity.y + GRAVITY * delta, MAX_FALL_SPEED)
	if is_on_floor() and Input.is_action_just_pressed(&"jump"):
		velocity.y = JUMP_VELOCITY
	move_and_slide()


## Y coordinate of the player's feet.
func feet_y() -> float:
	return position.y + SIZE.y * 0.5


func _draw() -> void:
	var body_rect: Rect2 = Rect2(-SIZE * 0.5, SIZE)
	draw_rect(body_rect, Color("#d9d4c8"))
	draw_rect(Rect2(-6.0, -SIZE.y * 0.5 + 8.0, 12.0, 6.0), Color("#2b2b2b"))
