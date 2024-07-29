extends "res://scripts/state.gd"

@export var player: CharacterBody2D
@onready var state_machine : StateMachine = %PlayerStateMachine

func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)

func _input(event):
	pass

func _process(delta: float) -> void:
	player.move_and_collide(player.velocity * delta)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)
	set_process_input(true)

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
