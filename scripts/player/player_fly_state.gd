extends "res://scripts/state.gd"

@export var player: CharacterBody2D
@onready var state_machine : StateMachine = %PlayerStateMachine

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		state_machine._change_state(state_machine.deceleration_state)

func _process(delta: float) -> void:
	player.move_and_collide(player.velocity * delta)

func _physics_process(delta: float):
	var direction := player.global_position.direction_to(player.get_global_mouse_position())
	player.velocity = player.velocity.move_toward(direction * player.max_speed, player.acceleration * delta)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)
