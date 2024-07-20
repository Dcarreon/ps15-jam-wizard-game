extends "res://scripts/state_machine.gd"

@export var enemy : Enemy 
@onready var wander_state : State = $EnemyWanderState
@onready var follow_state : State = $EnemyFollowState
@onready var attack_state : State = $EnemyAttackState

func _ready() -> void:
	_change_state(state)

func _change_state(new_state: State):
	if state is State:
		state._exit_state()	
	new_state._enter_state()
	state = new_state
