extends Button


const DISABLED_COLOR := Color(0.5, 0.5, 0.5, 0.5)

func set_disabled(p_disabled):
	self.disabled = p_disabled
	if disabled:
		self.modulate = DISABLED_COLOR
	else:
		self.modulate = Color.white
