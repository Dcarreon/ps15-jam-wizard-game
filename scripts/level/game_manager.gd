class_name GameManager
extends Node

@export var signal_bus : SignalBus
@export var player : CharacterBody2D
@export var game_timer : CustomTimer

@onready var main_ui: CanvasLayer = $"../MainUI"
@onready var play: Node = $"../Play"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	signal_bus.falling_area_entered.connect(_on_falling_area_entered)
	signal_bus.boost_upgrade_entered.connect(_on_boost_upgrade_entered)
	signal_bus.health_upgrade_entered.connect(_on_health_upgrade_entered)
	signal_bus.enemy_touched.connect(_on_enemy_touched)
	
	signal_bus.enemy_death.connect(_on_enemy_death)
	signal_bus.reset_button_pressed.connect(reset_game)
	
	game_timer.timeout.connect(_on_game_timer_timeout)
	game_timer.start()
	
	process_mode = PROCESS_MODE_ALWAYS # working even when sceneTree is paused
	
func _on_falling_area_entered(body: Node2D):
	print("game manager falling area script")
	if body.name == "Player":
		print("body identified as Player")
		player._player_damaged(player.damage_type.FALLING)

func _on_boost_upgrade_entered(body: Node2D):
	if body.name == "Player":
		player.boost_upgrade = true
		player.spawn_point = body.global_position

func _on_health_upgrade_entered(body: Node2D):
	if body.name == "Player":
		player._health_upgrade()
		player.spawn_point = body.global_position

func _on_enemy_touched(body: Node2D):
	if body.name == "Player":
		player._player_damaged(player.damage_type.FALLING)
	else:
		print("player not found")
		
func _on_game_timer_timeout() -> void:
	reset_game()

func reset_game() -> void:
	play.set_process(false)
	play.set_physics_process(false)
	get_tree().reload_current_scene()

func _on_enemy_death() -> void:
	play.get_tree().paused = true
	game_timer.stop()
	main_ui._on_win()

func _on_game_ready() -> void:
	play.get_tree().paused = false
