extends "res://scripts/state.gd"

@export var player: CharacterBody2D

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _process(delta: float) -> void:
	player.velocity = lerp(player.velocity, Vector2.ZERO, 0.02)
	player.velocity = _round_vec2_to_whole(player.velocity)
	player.move_and_collide(player.velocity, delta)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)

func _round_vec2_to_whole(vector: Vector2) -> Vector2:
	if vector.x < 0:
		vector.x = ceil(vector.x)
	elif vector.x > 0:
		vector.x = floor(vector.x)
	if vector.y < 0:
		vector.y = ceil(vector.y)
	elif vector.y > 0:
		vector.y = floor(vector.y)
	
	return vector