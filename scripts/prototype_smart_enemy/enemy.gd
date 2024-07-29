class_name smartEnemy
extends CharacterBody2D

#@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast : RayCast2D = $RayCast2D
@onready var collision : CollisionShape2D = $CollisionShape2D

@onready var state_machine : StateMachine = $EnemyStateMachine
@onready var enemy_wander_state: Node = $EnemyStateMachine/EnemyWanderState
@onready var enemy_follow_state: Node = $EnemyStateMachine/EnemyFollowState
@onready var enemy_attack_state: Node = $EnemyStateMachine/EnemyAttackState
@onready var direction_rays: Node2D = $RayDirection

@export var max_speed : float = 500
@export var acceleration : float = 300
@export var vision_range : float = 600
@export var vision_angle : float = 45
@export var hearing_range : float = 1000
@export var target : CharacterBody2D
@export var attack_range : float = 60
@export var target_memory : float = 2

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprites: Node2D = $Sprites


var direction = Vector2.ZERO
var origin : Vector2

func _ready() -> void:
	origin = global_position
	ray_cast.scale = ray_cast.scale / scale
	enemy_wander_state.found_target.connect(state_machine._change_state.bind(enemy_follow_state))
	enemy_follow_state.lost_target.connect(state_machine._change_state.bind(enemy_wander_state))

	animated_sprite_2d.sprite_frames.add_frame("Front", sprites.get_node("Front").texture, 1, -1)
	animated_sprite_2d.sprite_frames.add_frame("Back", sprites.get_node("Back").texture, 1, -1)
	

func _process(delta: float) -> void:
	#queue_redraw()
	#var look_direction = velocity * max_speed
	#if velocity == Vector2.ZERO and sense_target():
		#look_direction = target.global_position 
	#_look_at(look_direction, delta)
	pass
	
func _physics_process(_delta: float) -> void:
	if target:
		self.ray_cast.target_position = (target.global_position - global_position)
		#print(ray_cast.target_position.distance_to(ray_cast.position))

func sense_target():
	#var vector_to_target = (target.global_position - self.global_position).normalized()
	
	var target_distance = ray_cast.target_position.distance_to(ray_cast.position)
	#print(rad_to_deg(angle_to_target))
	# can see the target
	if target_distance < vision_range and not ray_cast.is_colliding():
		return true
	# can "feel/hear" the target
	if target_distance < hearing_range:
		return true
	return false

##-------------------------------
##            DEBUG
##-------------------------------
#func _draw() -> void:
	#var vector_to_target = ray_cast.target_position - ray_cast.position
	#vector_to_target = vector_to_target.normalized()
	#var front = Vector2.from_angle(sprite.rotation).normalized()
	#draw_line(ray_cast.position, front.rotated(deg_to_rad(vision_angle)) * self.vision_range, Color.GREEN, 1.0)
	#draw_line(ray_cast.position, front.rotated(deg_to_rad(-(vision_angle))) * self.vision_range, Color.RED, 1.0)

func old_get_best_direction(desired_direction : Vector2):
	var _it = 0
	var bigger_index = 0
	var rays := direction_rays.get_children()
	var directions : PackedVector2Array = direction_rays.get_directions()
	var context_array : PackedFloat32Array
	context_array.resize(rays.size())
	
	var interest_array : PackedFloat32Array
	interest_array.resize(rays.size())
	
	var danger_array : PackedInt32Array
	danger_array.resize(rays.size())
	
	for ray:RayCast2D in rays:
		var local_desired_direction = desired_direction - global_position
		var interest_value = local_desired_direction.normalized().dot(directions[_it].normalized())
		interest_array[_it] = interest_value
		var danger_value : int = 0 # values must be bigger than the biggest interest_value
		 
		if ray.is_colliding():
			danger_value = 20
		# only for the first element
		elif _it == 0 and (rays[1].is_colliding() or rays[danger_array.size() - 1].is_colliding()):
			danger_value = 15
		# only fot the last element
		elif _it == danger_array.size() - 1 and (rays[_it - 1].is_colliding() or rays[0].is_colliding()):
			danger_value = 15
		# for the rest
		elif not _it == danger_array.size() - 1 and not _it == 0:
			if rays[_it + 1].is_colliding() or rays[_it - 1].is_colliding():
				danger_value = 15
					
		danger_array[_it] = danger_value
		context_array[_it] = interest_array[_it] - danger_array[_it]
		if context_array[bigger_index] < context_array[_it]:
			bigger_index = _it
		_it += 1
	print("interest: ", interest_array)
	print("danger: ", danger_array)
	print(context_array, " desired index: ", bigger_index)	
	print("direction: ", directions[bigger_index])
	return directions[bigger_index]

func get_best_direction(desired_direction : Vector2):
	var _it = 0
	var bigger_index = 0
	var rays := direction_rays.get_children()
	var directions : PackedVector2Array = direction_rays.get_directions()
	var context_array : PackedFloat32Array
	context_array.resize(directions.size())
	
	var interest_array : PackedFloat32Array
	interest_array.resize(directions.size())
	
	var danger_array : PackedFloat32Array
	danger_array.resize(directions.size())
	
	var colliding_rays : PackedVector2Array
	colliding_rays.clear()
	
	for ray:RayCast2D in rays:
		if ray.is_colliding():
			colliding_rays.append(ray.target_position)
			
	for dir in directions:
		var local_desired_direction = desired_direction - global_position
		var interest_value = local_desired_direction.normalized().dot(directions[_it].normalized())
		interest_array[_it] = interest_value
		for _ray in colliding_rays:
			var danger_value = _ray.normalized().dot(directions[_it].normalized()) * 2
			if danger_value > danger_array[_it]:
				danger_array[_it] = danger_value
				if _it == 0:
					danger_array[_it + 1] = 0.4 * danger_value
					danger_array[danger_array.size() - 1] = 0.4 * danger_value
				if _it == danger_array.size() - 1:
					danger_array[0] = 0.4 * danger_value
					danger_array[_it - 1] = 0.4 * danger_value
		
		context_array[_it] = interest_array[_it] - danger_array[_it]
		if context_array[bigger_index] < context_array[_it]:
			bigger_index = _it
		_it += 1
	#print("interest: ", interest_array)
	#print("danger: ", danger_array)
	#print(context_array, " desired index: ", bigger_index)	
	#print("direction: ", directions[bigger_index])
	return directions[bigger_index]
