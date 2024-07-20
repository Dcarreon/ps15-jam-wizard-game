extends RayCast2D
@onready var actor : Enemy = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_exception(actor.target)
