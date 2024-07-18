extends CharacterBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var state_machine : StateMachine = $PlayerStateMachine

@export var max_speed : float = 400
@export var acceleration : float = 500
@export var deceleration : float  = 0.02 # Percentage

func _ready() -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		state_machine._change_state(state_machine.fly_state)
	if event.is_action_released("ui_accept"):
		state_machine._change_state(state_machine.deceleration_state)

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if (velocity == Vector2.ZERO):
		state_machine._change_state(state_machine.idle_state)