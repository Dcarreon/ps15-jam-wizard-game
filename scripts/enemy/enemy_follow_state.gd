extends "res://scripts/state.gd"

signal player_in_range
signal lost_target

@onready var actor: Enemy = $"../.."
@onready var ray_cast : RayCast2D = $"../../RayCast2D"
@onready var navigation_agent: NavigationAgent2D = $"../../NavigationAgent2D"

var target_lost_timer

var collision : KinematicCollision2D

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !is_instance_valid(actor.target):
		lost_target.emit()
	
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
			
	if navigation_agent.is_target_reached():
		navigation_agent.set_velocity(Vector2.ZERO)
		
	
	target_setup()
		
	var current_agent_position = actor.global_position
	var next_path_position = navigation_agent.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * actor.max_speed       
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		actor.velocity = _on_velocity_computed(new_velocity)

func _process(delta: float) -> void:
	actor.move_and_collide(actor.velocity * delta)


func _on_velocity_computed(safe_velocity):
	actor.velocity = safe_velocity

func target_setup():
	await get_tree().physics_frame
	if actor.target:
		navigation_agent.target_position = actor.target.global_position
		
func _enter_state() -> void:
	navigation_agent.target_desired_distance = actor.collision.shape.radius + actor.target.collision_object.shape.radius * 8
	#print(navigation_agent.target_desired_distance)
	navigation_agent.max_speed = actor.max_speed
	target_lost_timer = 0
	navigation_agent.connect("velocity_computed", Callable(self, "_on_velocity_computed"))
	#actor = await $"../.."
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
