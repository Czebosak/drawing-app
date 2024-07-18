extends Control

@onready var camera := $ViewportContainer/Viewport/Camera as Camera2D
@onready var canvas = $ViewportContainer/Viewport/CanvasContainer/Canvas as Canvas

@export var zoom_amount := Vector2(0.1, 0.1)

var dragging := false
var drawing := false

# Temporary
func _ready():
	var image = canvas.new_image(128, 128, Color(1.0, 1.0, 1.0, 1.0))
	canvas.load_image(image)
	
	await get_tree().process_frame
	center_camera()
	center_camera_zoom()

func _process(_delta):
	if Input.is_action_pressed("draw"):
		canvas.draw_at_mouse_pos(Color(0.0, 0.0, 0.0, 1.0))

var _last_mouse_pos := 0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			dragging = false if dragging else true
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if drawing:
				drawing = false
				Input.use_accumulated_input = true
			else:
				drawing = true
				Input.use_accumulated_input = false
				canvas.draw_at_mouse_pos(Color(0.0, 0.0, 0.0, 1.0))
		elif event.pressed:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					camera.zoom += zoom_amount
				MOUSE_BUTTON_WHEEL_DOWN:
					camera.zoom -= zoom_amount
	elif event is InputEventMouseMotion:
		if dragging:
			camera.position -= event.relative
		elif drawing:
			canvas.draw_at_mouse_pos(Color(0.0, 0.0, 0.0, 1.0))
			return
		canvas.last_mouse_pos = Vector2i(0, 0)

func center_camera():
	camera.position = size / 2.0

func center_camera_zoom():
	var ratio = min(size.x / canvas.size.x, size.y / canvas.size.y)
	camera.zoom *= ratio * 0.7
