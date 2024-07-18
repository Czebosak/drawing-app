extends ScrollContainer

func _ready():
	_update()

func _update():
	custom_minimum_size = $MarginContainer.size
