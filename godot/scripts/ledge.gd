class_name Ledge
extends StaticBody2D
## A small ledge in a room. It carries the food and must be jumped onto.


func _ready() -> void:
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = Vector2(Rules.LEDGE_WIDTH, Rules.LEDGE_THICKNESS)
	var collision: CollisionShape2D = CollisionShape2D.new()
	collision.shape = shape
	add_child(collision)


func _draw() -> void:
	var size: Vector2 = Vector2(Rules.LEDGE_WIDTH, Rules.LEDGE_THICKNESS)
	draw_rect(Rect2(-size * 0.5, size), Color("#8a857a"))
