extends "res://scripts/state.gd"

signal found_target

@onready var actor: smartEnemy = $"../.."
@onready var ray_cast : RayCast2D = $"../../RayCast2D"
@onready var navigation_agent: NavigationAgent2D = $"../../NavigationAgent2D"

var collision : KinematicCollision2D
var first_execution = true
var nav_path_next_pos : Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	
func _process(delta: float) -> void:
	var desired_velocity : Vector2 = await actor.get_best_direction(nav_path_next_pos) * (actor.max_speed / 2)
	var steering_force = desired_velocity - actor.velocity
	var move_angle = 1
	if desired_velocity != Vector2.ZERO:
		move_angle = lerp_angle(move_angle, desired_velocity.normalized().angle(), 0.0003)
		print(move_angle)
	if move_angle >= 0 :
		actor.animated_sprite_2d.play("Front")
	else:
		actor.animated_sprite_2d.play("Back")
		
	actor.velocity = actor.velocity + (steering_force*6) * delta 
	actor.move_and_collide(actor.velocity * delta)
	
func _physics_process(_delta: float) -> void:	
	if first_execution:
		first_execution = false
		return
	target_setup()
	# warning fix
	
	if actor.sense_target():
		navigation_agent.target_position = actor.target.global_position
		if navigation_agent.is_target_reachable():
			found_target.emit()
		else:
			target_setup()
	
	#print_debug("wandering")	
		
func _enter_state() -> void:
	navigation_agent.target_desired_distance = 100
	actor.velocity = Vector2.ZERO
	ray_cast.set_enabled(true)
	navigation_agent.connect("target_reached", Callable(self, "_on_target_reached"))
	call_deferred("target_setup")
	print("wander state")
	set_process(true)
	set_physics_process(true)

func _exit_state() -> void:
	#print("out of wander state")
	ray_cast.set_enabled(false)
	navigation_agent.disconnect("target_reached", Callable(self, "_on_target_reached"))
	set_process(false)
	set_physics_process(false)
	
func target_setup():
	await get_tree().physics_frame
	nav_path_next_pos = navigation_agent.get_next_path_position()
	navigation_agent.target_position = actor.origin
	
func _on_target_reached():
	pass
	#navigation_agent.target_position = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * actor.max_speed
