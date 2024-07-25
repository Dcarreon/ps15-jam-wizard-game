extends "res://scripts/state.gd"

signal found_target

@export var actor : Enemy
@export var change_direction_time : float = 1.0
@onready var ray_cast : RayCast2D = $"../../RayCast2D"
@onready var navigation_agent: NavigationAgent2D = $"../../NavigationAgent2D"

var collision : KinematicCollision2D
var navigation_next_random = Vector2.ZERO
var direction_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	
func _process(delta: float) -> void:
	collision = actor.move_and_collide(actor.velocity * delta)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	actor.velocity = Vector2.ZERO
	#direction_timer += delta
	#
	#var current_agent_position = ray_cast.global_position
	#var next_path_position = navigation_agent.get_next_path_position()
	#var new_velocity = current_agent_position.direction_to(next_path_position) * actor.max_speed   
	#
	#if navigation_agent.avoidance_enabled:
		#navigation_agent.set_velocity(new_velocity)
	#else:
		#actor.velocity = _on_velocity_computed(new_velocity)
	navigation_agent.target_position = actor.target.global_position
	if actor.sense_target() and navigation_agent.is_target_reachable():
		found_target.emit()
	print_debug("wandering")	
		
func _enter_state() -> void:	
	ray_cast.set_enabled(true)
	navigation_agent.connect("velocity_computed", _on_velocity_computed)
	navigation_agent.connect("target_reached", _on_target_reached)
	call_deferred("actor_setup")
	print("wander state")
	set_process(true)
	set_physics_process(true)
	navigation_agent.target_position = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * actor.max_speed

func _exit_state() -> void:
	print("out of wander state")
	ray_cast.set_enabled(false)
	navigation_agent.disconnect("velocity_computed", _on_velocity_computed)
	navigation_agent.disconnect("target_reached", _on_target_reached)
	set_process(false)
	set_physics_process(false)
	
func actor_setup():
	await get_tree().physics_frame
	if actor.target: 
		navigation_agent.target_desired_distance = 150
		navigation_agent.target_position = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * actor.max_speed
	
func _on_velocity_computed(safe_velocity):
	#actor.velocity = safe_velocity
	pass
	
func _on_target_reached():
	print("wander reached")
	navigation_agent.target_position = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * actor.max_speed
