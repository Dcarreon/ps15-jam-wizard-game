extends "res://scripts/state.gd"

@export var player : CharacterBody2D

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	pass

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)