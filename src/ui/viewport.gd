extends Control

@onready var camera := $ViewportContainer/Viewport/ViewportCamera as ViewportCamera
@onready var canvas = $ViewportContainer/Viewport/CanvasContainer/Canvas as Canvas

@export var zoom_amount := Vector2(0.1, 0.1)

var dragging := false
var drawing := false

var _last_mouse_pos := 0


func _ready():
	var image = canvas.new_image(128, 128, Color(1.0, 1.0, 1.0, 1.0)) # Temporary
	canvas.load_image(image)
	
	await get_tree().process_frame
	center_camera()
	center_camera_zoom()


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			dragging = false if dragging else true
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if drawing:
				drawing = false
			elif event.pressed:
				drawing = true
				canvas.draw_at_mouse_pos(Color(0.0, 0.0, 0.0, 1.0))
		elif event.pressed:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					camera.zoom += zoom_amount * camera.zoom
				MOUSE_BUTTON_WHEEL_DOWN:
					camera.zoom -= zoom_amount * camera.zoom
	elif event is InputEventMouseMotion:
		if dragging:
			camera.position -= event.relative / camera.zoom
			camera.last_camera_position = camera.position
		elif drawing:
			canvas.draw_at_mouse_pos(Color(0.0, 0.0, 0.0, 1.0))
			return
		canvas.last_mouse_pos = Vector2i(0, 0)


func center_camera():
	camera.position = size / 2.0
	camera.last_camera_position = camera.position


func center_camera_zoom():
	var ratio = min(size.x / canvas.size.x, size.y / canvas.size.y)
	camera.zoom *= ratio * 0.7


func _on_resized():
	# For some stupid reason the camera moves when resizing windows
	# This is a fix
	camera.position = camera.last_camera_position
