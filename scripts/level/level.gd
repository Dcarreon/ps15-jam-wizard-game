extends StaticBody2D

@onready var line : Path2D = $Path2D
@onready var shape : Polygon2D = $Polygon2D
@onready var collision : CollisionPolygon2D = $CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var points : PackedVector2Array = line.curve.get_baked_points()

	collision.polygon = points
	shape.polygon = points
