extends LineEdit

signal blocked


func _ready():
	connect("text_changed", self, "_on_Text_changed")
	connect("text_entered", self, "_on_Text_entered")


func _on_Text_changed(new_text: String) -> void:
	owner.form.profile_name = new_text


func _on_Text_entered(new_text: String) -> void:
	owner.form.confirm_button.grab_focus()
