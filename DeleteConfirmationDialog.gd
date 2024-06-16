extends ConfirmationDialog



func _ready():
	get_ok().self_modulate = Color("c8eaff")
	get_cancel().self_modulate = Color("c8eaff")
	get_ok().text = ""
	get_cancel().text = ""
	
	get_ok().rect_min_size = Vector2(100.0, 50.0)
	get_cancel().rect_min_size = Vector2(100.0, 50.0)
	var ok_label = Label.new()
	ok_label.text = "OK"
	var cancel_label = Label.new()
	cancel_label.text = "Cancel"
	ok_label.align = Label.ALIGN_CENTER
	ok_label.valign = Label.VALIGN_CENTER
	cancel_label.align = Label.ALIGN_CENTER
	cancel_label.valign = Label.VALIGN_CENTER
	ok_label.anchor_top = 0.0
	ok_label.anchor_left = 0.0
	ok_label.anchor_right = 1.0
	ok_label.anchor_bottom = 1.0
	cancel_label.anchor_top = 0.0
	cancel_label.anchor_left = 0.0
	cancel_label.anchor_right = 1.0
	cancel_label.anchor_bottom = 1.0
	get_ok().add_child(ok_label)
	get_cancel().add_child(cancel_label)

