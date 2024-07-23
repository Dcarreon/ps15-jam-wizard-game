extends "res://scripts/state.gd"

@export var actor : Enemy
@onready var ray_cast : RayCast2D = $"../../RayCast2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _enter_state() -> void:
	ray_cast.set_enabled(true)
	print("wander state")
	set_process(true)
	set_physics_process(true)

func _exit_state() -> void:
	ray_cast.set_enabled(false)
	set_process(false)
	set_physics_process(false)
