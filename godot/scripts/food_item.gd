class_name FoodItem
extends Area2D
## A piece of food. The player collects it by touching it.

signal collected

const RADIUS: float = 14.0


func _ready() -> void:
	var shape: CircleShape2D = CircleShape2D.new()
	shape.radius = RADIUS
	var collision: CollisionShape2D = CollisionShape2D.new()
	collision.shape = shape
	add_child(collision)
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collected.emit()
		queue_free()


func _draw() -> void:
	draw_circle(Vector2.ZERO, RADIUS, Color("#c93a3a"))
	draw_circle(Vector2(-4.0, -4.0), 4.0, Color("#f08a8a"))
