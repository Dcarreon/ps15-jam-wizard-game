class_name boundry_maker
static func get_boundry(image : Image, width : int, height: int) -> PackedVector2Array:
	var boundries : PackedVector2Array
	for y in height:
		for x in width:
			var cur_pixel = image.get_pixel(x, y)
			if cur_pixel.a != 0.0:
				var left_p = image.get_pixel(x - 1, y)
				var right_p = image.get_pixel(x + 1, y) 
				var up_p = image.get_pixel(x, y - 1)
				var down_p = image.get_pixel(x, y + 1) 
				if left_p.a == 0.0 or right_p.a == 0.0 or up_p.a == 0.0 or down_p.a == 0.0:
					boundries.append(Vector2(x,y))
	return boundries
	
static func get_boundry_collision(boundry : PackedVector2Array, image_width : int, image_height : int, sprite_scale : Vector2) -> StaticBody2D:
	var map_boundry := StaticBody2D.new()
	for p in boundry:
		var point = Vector2(p.x - image_width/2, p.y - image_height/2) * sprite_scale
		var collider = CollisionShape2D.new()
		var shape = CircleShape2D.new()
		shape.radius = 2
		collider.shape = shape
		collider.global_position = point
		map_boundry.add_child(collider)
	return map_boundry
