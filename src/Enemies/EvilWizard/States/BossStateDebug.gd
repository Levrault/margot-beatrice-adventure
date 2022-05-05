extends Label



func _process(delta):
	text = owner.state_machine.state_name
	rect_scale.x = -1
