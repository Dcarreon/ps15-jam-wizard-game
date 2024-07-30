extends "res://scripts/state.gd"

@export var player: CharacterBody2D
@onready var state_machine : StateMachine = %PlayerStateMachine

var direction : Vector2
var boost_speed : float 
var boost_accel : float 

func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)

func _input(event):
	if event.is_action_released("boost_key"):
		state_machine._change_state(state_machine.fly_state)

func _process(delta: float) -> void:
	player.move_and_collide(player.velocity * delta)

func _physics_process(delta: float) -> void:
	player.velocity = player.velocity.move_toward(direction * boost_speed, boost_accel * delta)

	if player.collision:
		var collider = player.collision.get_collider()
		if collider.is_in_group("static_collisions"):
			state_machine._change_state(state_machine.fly_state)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)
	set_process_input(true)

	direction = player.global_position.direction_to(player.get_global_mouse_position())

	boost_speed = player.max_speed * 2.0
	boost_accel = player.acceleration * 2.0

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
