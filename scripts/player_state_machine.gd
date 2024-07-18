extends "res://scripts/state_machine.gd"

@onready var idle_state : State = $PlayerIdleState
@onready var fly_state : State = $PlayerFlyState
@onready var deceleration_state : State = $PlayerDecelerationState