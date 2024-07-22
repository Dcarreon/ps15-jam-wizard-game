class_name Enemy
extends CharacterBody2D

#@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite : Polygon2D = $Polygon2D
@onready var ray_cast : RayCast2D = $RayCast2D
@onready var collision : CollisionShape2D = $CollisionShape2D

@onready var state_machine : StateMachine = $EnemyStateMachine
@onready var enemy_wander_state: Node = $EnemyStateMachine/EnemyWanderState
@onready var enemy_follow_state: Node = $EnemyStateMachine/EnemyFollowState
@onready var enemy_attack_state: Node = $EnemyStateMachine/EnemyAttackState

@export var max_speed : float = 400
@export var acceleration : float = 300
@export var vision_range : float = 1000
@export var vision_angle : float = 45
@export var hearing_range : float = 600
@export var target : CharacterBody2D
@export var attack_range : float = 20

var direction = Vector2.ZERO

func _ready() -> void:
	enemy_wander_state.found_target.connect(state_machine._change_state.bind(enemy_follow_state))
	enemy_follow_state.lost_target.connect(state_machine._change_state.bind(enemy_wander_state))

func _process(delta: float) -> void:
	queue_redraw()
	var look_direction = velocity * max_speed
	_look_at(look_direction, delta)
	
func _physics_process(_delta: float) -> void:
	if target:
		self.ray_cast.target_position = self.target.global_position - self.get_global_position()
		#print(ray_cast.target_position.distance_to(ray_cast.position))

func _look_at(_direction : Vector2, delta : float):
	var desired_angle = get_global_position().angle_to_point(_direction)
	var current_angle = desired_angle#lerp_angle(sprite.rotation, desired_angle, 0.02)
	collision.rotation = current_angle
	sprite.rotation = current_angle
	
func sense_target():
	var vector_to_target = (target.global_position - self.global_position).normalized()
	var front = Vector2.from_angle(sprite.rotation).normalized()
	var angle_to_target = front.angle_to(vector_to_target)
	
	var target_distance = ray_cast.target_position.distance_to(ray_cast.position)
	#print(rad_to_deg(angle_to_target))
	# can see the target
	if target_distance < vision_range and not ray_cast.is_colliding():
		if angle_to_target < deg_to_rad(vision_angle) and angle_to_target > deg_to_rad(-(vision_angle)):
			return true
	# can "feel/hear" the target
	if target_distance < hearing_range:
		return true
	return false

##-------------------------------
##            DEBUG
##-------------------------------
func _draw() -> void:
	var vector_to_target = ray_cast.target_position - ray_cast.position
	vector_to_target = vector_to_target.normalized()
	var front = Vector2.from_angle(sprite.rotation).normalized()
	draw_line(ray_cast.position, front.rotated(deg_to_rad(vision_angle)) * self.vision_range, Color.GREEN, 1.0)
	draw_line(ray_cast.position, front.rotated(deg_to_rad(-(vision_angle))) * self.vision_range, Color.RED, 1.0)
