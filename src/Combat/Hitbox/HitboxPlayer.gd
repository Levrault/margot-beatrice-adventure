extends Hitbox


func _ready() -> void:
	Events.connect("player_character_changed", self, "_on_Player_character_changed")


func _on_Player_character_changed() -> void:
	self.collider_name = Character.hitboxes[Character.selected]


func _on_Area_entered(damage_source: Area2D) -> void:
	if damage_source is DamageSourcePassThrough and owner.state_machine.state_name == "Dash":
		return
	._on_Area_entered(damage_source)
