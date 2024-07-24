extends StaticBody2D

@onready var line : Path2D = $Path2D
@onready var collision_object : CollisionPolygon2D = $CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("static_collisions")
	var points : PackedVector2Array = line.curve.get_baked_points()

	collision_object.polygon = points