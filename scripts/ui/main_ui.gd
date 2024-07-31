extends CanvasLayer

@export var game_timer : CustomTimer 
@onready var timer_label : Label = $TimerLabel
@export var signal_bus : SignalBus
@onready var credits: Sprite2D = $credits
@onready var score_timer_pos: Marker2D = $ScoreTimerPos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	credits.hide()
	game_timer.last_ten.connect(_on_last_ten)
	timer_label.text = str(game_timer.get_time_left(true))
	
	process_mode = PROCESS_MODE_ALWAYS # working even when sceneTree is paused

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	timer_label.text = str(game_timer.get_time_left(true))

func _on_last_ten():
	pass


func _on_reset_button_up() -> void:
	signal_bus.reset_button_pressed.emit()

func _on_win():
	timer_label.global_position = score_timer_pos.global_position
	credits.visible = true
