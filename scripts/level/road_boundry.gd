extends Sprite2D

var boundries : PackedVector2Array
var map_boundry : StaticBody2D

var texture_image = texture.get_image()
var image_w = texture_image.get_width()
var image_h = texture_image.get_height()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	boundries = boundry_maker.get_boundry(texture_image, image_w, image_h)
	map_boundry = boundry_maker.get_boundry_collision(boundries, image_w, image_h, scale)
	map_boundry.add_to_group("static_collisions")
	map_boundry.set_collision_layer_value(1, true)
	map_boundry.set_collision_layer_value(3, true)
	
	get_node("/root").add_child.call_deferred(map_boundry)
