extends Control


func _process(delta) -> void:
	rect_scale.x = owner.look_direction
	$VBoxContainer/WordToPoint/Value.text = (
		"(%s, %s)"
		% [get_parent().target_point_world.x, get_parent().target_point_world.y]
	)
	$VBoxContainer/Velocity/Value.text = (
		"(%s, %s)"
		% [get_parent().velocity.x, get_parent().velocity.y]
	)
	$VBoxContainer/Position/Value.text = (
		"(%s, %s)"
		% [owner.global_position.x, owner.global_position.y]
	)

	var target_direction = (get_parent().target_point_world - owner.global_position).normalized()
	$VBoxContainer/TargetDirection/Value.text = "%s" % target_direction
	$VBoxContainer/Distance/Value.text = "%s" % owner.global_position.distance_to(target_direction)
