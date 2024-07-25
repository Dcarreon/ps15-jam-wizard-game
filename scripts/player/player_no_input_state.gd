extends Node

func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)

func _process(_delta: float) -> void:
	pass

func _phsyics_process(_delta: float) -> void:
	pass

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)