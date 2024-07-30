extends CanvasLayer

@export var game_timer : CustomTimer 
@onready var timer_label: Label = $TimerLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_timer.last_ten.connect(_on_last_ten)
	timer_label.text = str(game_timer.get_time_left(true))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	timer_label.text = str(game_timer.get_time_left(true))

func _on_last_ten():
	pass
