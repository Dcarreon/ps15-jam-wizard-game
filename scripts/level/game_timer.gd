class_name CustomTimer
extends Node
signal timeout
signal last_ten

@export var wait_time : float
var time_left : float
var cur_state : state = state.pause

enum state {
	start,
	pause,
	end
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_left = wait_time
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match cur_state:
		state.start:
			time_left -= delta
			if time_left <= 0:
				cur_state = state.end
			if time_left > 10 and time_left - delta < 10:
				last_ten.emit()
		state.end:
			timeout.emit()
			
func get_time_left(formated : bool = true):
	return seconds_to_mmss(time_left) if formated else time_left

func start():
	cur_state = state.start
	
func stop():
	cur_state = state.pause
	
func reset():
	time_left = wait_time
	
func seconds_to_mmss(total_seconds: float) -> String:
	#total_seconds = 12345
	var seconds:float = fmod(total_seconds , 60.0)
	var minutes:int   =  int(total_seconds / 60.0) % 60
	var mmss_string:String = "%02d:%05.2f" % [minutes, seconds]
	return mmss_string
