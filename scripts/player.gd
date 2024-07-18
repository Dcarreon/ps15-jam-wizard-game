extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var move_state: StateMachine = $MoveState
@onready var animation_state: StateMachine = $AnimationState

func _ready() -> void:
	pass