extends Sprite

export var up := false

func _process(_delta):
#	print(OS.window_size)
	scale = OS.window_size / 1000
	scale.y = 0.034
	position.x = OS.window_size.x / 2.0
	if up:
		position.y = 20
	else:
		position.y = OS.window_size.y - 19
