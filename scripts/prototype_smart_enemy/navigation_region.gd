extends NavigationRegion2D

@export var actor : Enemy
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	navigation_polygon.agent_radius = 50
	bake_navigation_polygon()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
