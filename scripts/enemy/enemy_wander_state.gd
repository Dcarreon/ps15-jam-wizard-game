extends "res://scripts/state.gd"

@export var actor : Enemy
@export var change_direction_time : float = 1.0
@onready var ray_cast : RayCast2D = $"../../RayCast2D"

var collision
 
signal found_target

var change_direction_timer = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	collision = actor.move_and_collide(actor.velocity * delta)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:	
	change_direction_timer += delta
	actor.velocity = actor.velocity.move_toward(actor.direction.normalized() * actor.max_speed, actor.acceleration * delta)
	
	if collision:
		actor.direction = actor.velocity.bounce(collision.get_normal())
	elif change_direction_timer >= change_direction_time:
		actor.direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
		change_direction_timer = 0
		
	if actor.sense_target():
		found_target.emit()
		
	#print_debug("wandering")	
		
func _enter_state() -> void:
	ray_cast.set_enabled(true)
	print("wander state")
	set_process(true)
	set_physics_process(true)

func _exit_state() -> void:
	ray_cast.set_enabled(false)
	set_process(false)
	set_physics_process(false)
	
