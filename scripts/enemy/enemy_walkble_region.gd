extends NavigationRegion2D

@onready var static_collisions: Node = $"../StaticCollisions"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#var full_area : PackedVector2Array
	#var areas_parent = static_collisions.get_children()
	#for instance:StaticBody2D in areas_parent:
		#var path : Path2D = instance.get_node("Path2D")
		#var points : PackedVector2Array = path.curve.get_baked_points()
		#full_area.append_array(points)
		#bake_navigation_polygon()
		#
	#if !full_area.is_empty():
		#var new_navigation_mesh = NavigationPolygon.new()
		#new_navigation_mesh.add_outline(full_area)
		#NavigationServer2D.bake_from_source_geometry_data(new_navigation_mesh, NavigationMeshSourceGeometryData2D.new());
		#navigation_polygon = new_navigation_mesh

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
