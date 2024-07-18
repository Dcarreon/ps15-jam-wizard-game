extends "res://scripts/state.gd"

@export var player: CharacterBody2D

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _process(delta: float) -> void:
	player.move_and_collide(player.velocity, delta)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)
