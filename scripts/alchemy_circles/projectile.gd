class_name Projectile
extends Area2D

var target : CharacterBody2D
var target_local_position : Vector2
var max_speed : float = 700
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_local_position = target.position - global_position
	look_at(target.position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += (target_local_position.normalized() * max_speed * delta)
	
func _on_area_entered(body: Node) -> void:
	hide()
	body.emit_signal("hit")
	queue_free()
