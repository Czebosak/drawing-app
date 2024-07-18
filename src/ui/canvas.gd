class_name Canvas extends SubViewport

@onready var texture_rect: TextureRect = $TextureRect

func new_image(width: int, height: int, color: Color):
	var image := Image.create(width, height, false, Image.FORMAT_RGBA8)
	image.fill(color)
	return image

func load_image(image: Image):
	texture_rect.texture = ImageTexture.create_from_image(image)

func draw(pos: Vector2, color: Color):
	var image = texture_rect.texture.get_image()
	image.set_pixelv(pos, color)
	texture_rect.texture = ImageTexture.create_from_image(image)

var last_mouse_pos: Vector2i

func draw_at_mouse_pos(color: Color):
	var mouse_pos = get_rel_mouse_pos()
	
	if mouse_pos == last_mouse_pos:
		return
	
	if mouse_pos[mouse_pos.min_axis_index()] <= 0 or mouse_pos.x >= size.x or mouse_pos.y >= size.y:
		return
	
	if last_mouse_pos == Vector2i(0, 0):
		draw(mouse_pos, color)
	else:
		var points = bresenham_line(last_mouse_pos, mouse_pos)
		
		for point in points:
			draw(point, color)
	
	last_mouse_pos = mouse_pos


func bresenham_line(start: Vector2i, end: Vector2i) -> Array:
	var points = []
	
	var dx = abs(end.x - start.x)
	var dy = abs(end.y - start.y)
	
	# Determine the step direction for x and y
	var sy = -1 if start.y > end.y else 1
	var sx = -1 if start.x > end.x else 1
	
	# Calculate the error term
	var err = dx - dy
	
	while true:
		# Append the current point to the list of points
		points.append(start)
		
		# Break the loop if the end point is reached
		if start.x == end.x and start.y == end.y:
			break
		
		# Calculate the double error term
		var e2 = 2 * err
		
		# Adjust the error term and the current point
		if e2 > -dy:
			err -= dy
			start.x += sx
		
		if e2 < dx:
			err += dx
			start.y += sy
	
	return points

func get_rel_mouse_pos() -> Vector2i:
	return get_viewport().get_mouse_position()

