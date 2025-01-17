extends "res://scripts/state.gd"

signal found_target

@export var actor : Enemy
@onready var ray_cast : RayCast2D = $"../../RayCast2D"
@onready var navigation_agent: NavigationAgent2D = $"../../NavigationAgent2D"

var collision : KinematicCollision2D
var first_execution = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	
func _process(delta: float) -> void:
	collision = actor.move_and_collide(actor.velocity * delta)
	
func _physics_process(_delta: float) -> void:
	target_setup()
	# warning fix
	if first_execution:
		first_execution = false
		return
		
	var current_agent_position = ray_cast.global_position
	var next_path_position = navigation_agent.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * actor.max_speed   
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		actor.velocity = _on_velocity_computed(new_velocity)
	
	if actor.sense_target():
		navigation_agent.target_position = actor.target.global_position
		if navigation_agent.is_target_reachable():
			found_target.emit()
	#print_debug("wandering")	
		
func _enter_state() -> void:
	navigation_agent.target_desired_distance = 100
	actor.velocity = Vector2.ZERO
	ray_cast.set_enabled(true)
	navigation_agent.connect("velocity_computed", Callable(self, "_on_velocity_computed"))
	navigation_agent.connect("target_reached", Callable(self, "_on_target_reached"))
	call_deferred("target_setup")
	#print("wander state")
	set_process(true)
	set_physics_process(true)

func _exit_state() -> void:
	#print("out of wander state")
	ray_cast.set_enabled(false)
	navigation_agent.disconnect("velocity_computed", Callable(self, "_on_velocity_computed"))
	navigation_agent.disconnect("target_reached", Callable(self, "_on_target_reached"))
	set_process(false)
	set_physics_process(false)
	
func target_setup():
	await get_tree().physics_frame
	navigation_agent.target_position = actor.origin
	
func _on_velocity_computed(safe_velocity):
	actor.velocity = safe_velocity
	pass
	
func _on_target_reached():
	pass
	navigation_agent.target_position = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * actor.max_speed
