extends "res://scripts/state.gd"

signal player_in_range
signal lost_target

@onready var actor: smartEnemy = $"../.."
@onready var ray_cast : RayCast2D = $"../../RayCast2D"
@onready var navigation_agent: NavigationAgent2D = $"../../NavigationAgent2D"
@onready var ray_direction: Node2D = $"../../RayDirection"

var target_lost_timer
var collision : KinematicCollision2D

var interest_array : PackedFloat32Array
var danger_array : PackedInt32Array
var context_array : PackedFloat32Array

var nav_path_next_pos : Vector2

func _ready() -> void:
	danger_array.resize(ray_direction.number_of_rays)
	danger_array.fill(0)
	
	context_array.resize(ray_direction.number_of_rays)
	context_array.fill(0)
	
	interest_array.resize(ray_direction.number_of_rays)
	interest_array.fill(0)
	
	set_process(false)
	set_physics_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !is_instance_valid(actor.target):
		lost_target.emit()
	
	target_setup()
	
	var target_distance = ray_cast.target_position.distance_to(ray_cast.position)
	if target_distance <= actor.attack_range:
		player_in_range.emit()
		
	if actor.sense_target() and navigation_agent.is_target_reachable():
		target_lost_timer = 0
		
	if not actor.sense_target() or not navigation_agent.is_target_reachable() :
		target_lost_timer += delta
		if target_lost_timer >= actor.target_memory:
			lost_target.emit()
			return
				
	#print(interest_array)
	#print(danger_array)
	#print(context_array)	
		
	if navigation_agent.is_target_reached():
		navigation_agent.set_velocity(Vector2.ZERO)
		
func _process(delta: float) -> void:
	var desired_velocity : Vector2 = await actor.get_best_direction(nav_path_next_pos) * actor.max_speed
	var steering_force = desired_velocity - actor.velocity
	actor.velocity = actor.velocity + (steering_force * 12 * delta)
	actor.move_and_collide(actor.velocity * delta)

func target_setup():
	await get_tree().physics_frame
	if actor.target:
		nav_path_next_pos = navigation_agent.get_next_path_position()
		navigation_agent.target_position = actor.target.global_position
	
func _enter_state() -> void:
	var actor_radius = actor.collision.shape.radius * actor.scale.x
	var target_radius = actor.target.collision_object.shape.radius * actor.target.scale.x
	navigation_agent.target_desired_distance = actor_radius + target_radius + 20
	
	target_lost_timer = 0
	navigation_agent.connect("velocity_computed", Callable(self, "_on_velocity_computed"))
	ray_cast.set_enabled(true)
	call_deferred("target_setup")
	set_process(true)
	set_physics_process(true)
	#print("follow state")

func _exit_state() -> void:
	navigation_agent.disconnect("velocity_computed", Callable(self, "_on_velocity_computed"))
	ray_cast.set_enabled(false)   
	set_process(false)
	set_physics_process(false) 
