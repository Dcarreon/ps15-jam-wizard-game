extends "res://scripts/state.gd"

@export var actor : Enemy
@onready var ray_cast : RayCast2D = $"../../RayCast2D"

var collision : KinematicCollision2D
signal lost_target
func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _process(delta: float) -> void:
	collision = actor.move_and_collide(actor.velocity * delta)

func _physics_process(delta: float):
	actor.direction = actor.global_position.direction_to(actor.target.get_global_position())
	actor.velocity = actor.velocity.move_toward(actor.direction.normalized() * actor.max_speed, actor.acceleration * delta)
	if collision:
		actor.direction = actor.velocity.bounce(collision.get_normal())
	if not actor.sense_target():
		lost_target.emit()
		
	#print_debug("following")
		
func _enter_state() -> void:
	ray_cast.set_enabled(true)
	print("follow state")
	set_process(true)
	set_physics_process(true)

func _exit_state() -> void:
	ray_cast.set_enabled(false)
	set_process(false)
	set_physics_process(false)
