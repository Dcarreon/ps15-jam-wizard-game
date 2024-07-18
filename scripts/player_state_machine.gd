extends "res://scripts/state_machine.gd"

@onready var idle_state : State = $PlayerIdleState
@onready var fly_state : State = $PlayerFlyState
@onready var deceleration_state : State = $PlayerDecelerationState

func _ready() -> void:
	_change_state(state)

func _change_state(new_state: State):
	if state is State:
		state._exit_state()	
	new_state._enter_state()
	state = new_state
