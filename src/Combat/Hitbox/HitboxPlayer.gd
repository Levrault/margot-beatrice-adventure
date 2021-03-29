extends Hitbox


func _ready() -> void:
	Events.connect("player_character_changed", self, "_on_Player_character_changed")


func _on_Player_character_changed() -> void:
	self.collider_name = Character.hitboxes[Character.selected]
