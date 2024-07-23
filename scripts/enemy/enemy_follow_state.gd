extends "res://scripts/state.gd"

signal player_in_range
signal lost_target

@export var actor : Enemy
@onready var ray_cast : RayCast2D = $"../../RayCast2D"
@onready var navigation_agent: NavigationAgent2D = $"../../NavigationAgent2D"

var collision : KinematicCollision2D

func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame
	if actor.target:
		navigation_agent.target_position = actor.target.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !is_instance_valid(actor.target):
		lost_target.emit()
	
	var target_distance = ray_cast.target_position.distance_to(ray_cast.position)
	if target_distance <= actor.attack_range:
		player_in_range.emit()
	if not actor.sense_target():
		lost_target.emit()
		
	
	navigation_agent.target_position = actor.target.global_position
	var current_agent_position = ray_cast.global_position
	var next_path_position = navigation_agent.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * actor.max_speed       
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	
	actor.move_and_slide()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	actor.velocity = safe_velocity

#func _process(delta: float) -> void:
	#var target_distance = ray_cast.target_position.distance_to(ray_cast.position)
	#if target_distance <= actor.attack_range:
		#player_in_range.emit()
	#if not actor.sense_target():
		#lost_target.emit()
	#actor.velocity = actor.velocity.move_toward(actor.direction.normalized() * actor.max_speed, actor.acceleration * delta)
	#collision = actor.move_and_collide(actor.velocity * delta)
#
#func _physics_process(delta: float):
	## dumb path finding
	#if collision:
		#if ray_cast.is_colliding():
			#actor.direction = actor.velocity.bounce(collision.get_normal() + ray_cast.position)
		#else:
			#actor.direction = await path_finder(actor.velocity, 150)
	#else:
		#if ray_cast.is_colliding():
			#actor.direction = await path_finder(actor.velocity, 75)
		#else:
			#actor.direction = actor.global_position.direction_to(actor.target.get_global_position())
	##print_debug("following")
		
func _enter_state() -> void:
	ray_cast.set_enabled(true)
	set_process(true)
	set_physics_process(true)
	print("follow state")

func _exit_state() -> void:
	ray_cast.set_enabled(false)
	set_process(false)
	set_physics_process(false)

## work in progress
func path_finder(desired_mov_point, range):
	print("start searching path")
	var temp_ray_1 = RayCast2D.new()
	temp_ray_1.position = actor.position
	temp_ray_1.target_position = desired_mov_point
	temp_ray_1.exclude_parent = true
	add_child(temp_ray_1)
	var angular_range_increase = 5
	while true:
		print("searching path")
		temp_ray_1.position = actor.position
		# reset the ray to the cur_direction without rotation
		temp_ray_1.target_position = desired_mov_point.normalized() * range
		temp_ray_1.target_position = temp_ray_1.target_position.rotated(deg_to_rad(angular_range_increase))
		if not temp_ray_1.is_colliding():
			return temp_ray_1.target_position
		temp_ray_1.target_position = desired_mov_point
		temp_ray_1.target_position = temp_ray_1.target_position.rotated(-sign(deg_to_rad(angular_range_increase)))
		if not temp_ray_1.is_colliding():
			print("path found") 
			var res = temp_ray_1.target_position
			temp_ray_1.queue_free()
			return res
		angular_range_increase += angular_range_increase
