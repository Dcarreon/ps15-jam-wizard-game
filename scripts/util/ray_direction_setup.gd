extends Node2D

@export var number_of_rays : int
@onready var enemy: smartEnemy = $".."

var directions : PackedVector2Array = ([Vector2(0, -1), Vector2(1, -1), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), Vector2(-1, -1), Vector2(-1, 0), Vector2(-1, -1)])
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_ready() -> void:
	var angle = 0
	var angle_interval := 360.0 / number_of_rays
	while angle <= 360 - angle_interval:
		var ray := RayCast2D.new()
		ray.add_exception(enemy)
		ray.add_exception(enemy.target)
		ray.target_position = Vector2(0,-1).rotated(deg_to_rad(angle))
		ray.target_position = ray.target_position
		#directions.append(ray.target_position)
		add_child(ray)
		ray.target_position = ray.target_position * 70
		angle += angle_interval
		
func get_directions():
	return directions



func fill():
	var angle = 0
	while angle <= 360:
		var ray := RayCast2D.new()
		ray.add_exception(enemy)
		ray.add_exception(enemy.target)
		ray.target_position = Vector2(0,-1).rotated(deg_to_rad(angle))
		ray.target_position += ray.target_position/2
		ray.target_position = ray.target_position.floor()
		#directions.append(ray.target_position)
		add_child(ray)
		ray.target_position = ray.target_position * 60
		angle += 45
#target_positon = previus_target_position  - target_positon_next
