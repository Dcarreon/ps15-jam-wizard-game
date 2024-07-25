extends "res://scripts/state.gd"

@export var player: CharacterBody2D
@onready var state_machine : StateMachine = %PlayerStateMachine

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _input(event):
	if event.is_action_released("ui_accept"):
		state_machine._change_state(state_machine.fly_state)

func _process(delta: float) -> void:
	player._animation_follows_mouse()
	player.move_and_collide(player.velocity * delta)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)
