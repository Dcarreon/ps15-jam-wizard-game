extends "res://scripts/state.gd"

@export var player: CharacterBody2D
@onready var state_machine : StateMachine = %PlayerStateMachine

func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)

func _input(event):
	if event.is_action_released("ui_accept"):
		state_machine._change_state(state_machine.fly_state)

func _process(delta: float) -> void:
	player.move_and_collide(player.velocity * delta)

func _physics_process(delta: float) -> void:
	var direction := player.global_position.direction_to(player.get_global_mouse_position())
	player.velocity = player.velocity.move_toward(direction * player.velocity.length(), player.acceleration * delta)
	player.velocity = lerp(player.velocity, Vector2.ZERO, player.deceleration)
	player._animation_follows_mouse()

	if is_zero_approx(player.velocity.length()): # the length of a vector is equal to its current speed
		state_machine._change_state(state_machine.idle_state)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)
	set_process_input(true)

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)