class_name Player
extends CharacterBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_object : CollisionShape2D = $CollisionShape2D
@onready var state_machine : StateMachine = $PlayerStateMachine

@export var max_speed : float = 10000
@export var acceleration : float = 800
@export var deceleration : float  = 0.05 # Percentage

var max_health : int 
var health : int 

enum damage_type {
	FALLING
}

var collision : KinematicCollision2D

func _ready() -> void:
	max_health = 3
	health = 3

func _process(delta: float) -> void:
	collision = move_and_collide(velocity * delta)
	
func _physics_process(_delta: float) -> void:
	pass

func _animation_follows_mouse() -> void:
	if global_position.x < get_global_mouse_position().x :
		sprite.flip_h = true
	elif global_position.x > get_global_mouse_position().x:
		sprite.flip_h = false
	
	var angle_to_mouse := global_position.angle_to_point(get_global_mouse_position())
	if angle_to_mouse > deg_to_rad(90):
		angle_to_mouse = deg_to_rad(180) - angle_to_mouse
	if angle_to_mouse < deg_to_rad(-90):
		angle_to_mouse = deg_to_rad(-180) - angle_to_mouse

	if angle_to_mouse < deg_to_rad(-61):
		sprite.play("up")
	elif angle_to_mouse < deg_to_rad(-31):
		sprite.play("up_forward")
	elif angle_to_mouse < deg_to_rad(31) and angle_to_mouse > deg_to_rad(-31):
		sprite.play("forward")
	elif angle_to_mouse > deg_to_rad(31):
		sprite.play("down_forward")
	if angle_to_mouse > deg_to_rad(61):
		sprite.play("down")

func _player_damaged(type: int):
	state_machine._change_state(state_machine.no_input_state)
	match type:
		0: #FALLING
			velocity = Vector2.ZERO
			health = health - 1
			sprite.play("falling")

func _on_animated_sprite_2d_animation_finished() ->void:
	var anim_name : String = sprite.animation
	print(anim_name)
	match anim_name:
		"falling":
			get_tree().reload_current_scene()