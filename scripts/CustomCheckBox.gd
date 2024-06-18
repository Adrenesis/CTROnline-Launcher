extends Button


func _ready():
	$CheckBox.connect("toggled", self, "custom_toggled")

func custom_toggled(p_pressed):
	self.pressed = p_pressed

const DISABLED_COLOR := Color(0.5, 0.5, 0.5, 0.5)

func set_disabled(p_disabled):
	self.disabled = p_disabled
	if disabled:
		self.modulate = DISABLED_COLOR
	else:
		self.modulate = Color.white
#	print(self)
