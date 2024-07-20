extends CharacterBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var state_machine : StateMachine = $PlayerStateMachine

@export var max_speed : float = 800
@export var acceleration : float = 1000
@export var deceleration : float  = 0.02 # Percentage

func _ready() -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("accept pressed")
		state_machine._change_state(state_machine.fly_state)
	if event.is_action_released("ui_accept"):
		print("accept released")
		state_machine._change_state(state_machine.deceleration_state)

func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
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

	print(angle_to_mouse)
