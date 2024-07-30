extends Node2D

@export var attack : PackedScene
@export var _target : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var proj = attack.instantiate()
		proj.target = _target
		add_child.call_deferred(proj)
