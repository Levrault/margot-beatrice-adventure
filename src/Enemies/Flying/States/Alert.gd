extends State


func enter(msg: Dictionary = {}) -> void:
	$ExclamationPoint.anim.connect("animation_finished", self, "_on_Animation_finished")
	$ExclamationPoint.show()
	$ExclamationPoint.anim.play("show")


func exit() -> void:
	$ExclamationPoint.anim.disconnect("animation_finished", self, "_on_Animation_finished")
	$ExclamationPoint.hide()


func _on_Animation_finished(anim_name: String) -> void:
	_state_machine.transition_to("Follow")
