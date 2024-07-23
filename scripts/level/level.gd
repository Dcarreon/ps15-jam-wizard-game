extends StaticBody2D

@onready var shape : Polygon2D = $Polygon2D
@onready var collision : CollisionPolygon2D = $CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision.polygon = shape.polygon