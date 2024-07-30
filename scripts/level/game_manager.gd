class_name GameManager
extends Node

@export var signal_bus : SignalBus
@export var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	signal_bus.falling_area_entered.connect(_on_falling_area_entered)
	signal_bus.boost_upgrade_entered.connect(_on_boost_upgrade_entered)

func _on_falling_area_entered(body: Node2D):
	print("game manager falling area script")
	if body.name == "Player":
		print("body identified as Player")
		player._player_damaged(player.damage_type.FALLING)

func _on_boost_upgrade_entered(body: Node2D):
	if body.name == "Player":
		player.boost_upgrade = true
		player.spawn_point = body.global_position
