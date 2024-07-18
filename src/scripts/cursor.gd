extends Control

func _ready():
	# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass

func _input(event):
	if event is InputEventMouseMotion:
		position = event.position

func _notification(event):
	if event == NOTIFICATION_WM_MOUSE_ENTER:
		visible = false
	elif event == NOTIFICATION_WM_MOUSE_EXIT:
		visible = false
