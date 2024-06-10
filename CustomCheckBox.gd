extends Button


func _ready():
	$CheckBox.connect("toggled", self, "custom_toggled")

func custom_toggled(p_pressed):
	self.pressed = p_pressed
