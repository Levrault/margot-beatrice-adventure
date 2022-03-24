extends ParallaxLayer

const IDLE_STATE := ["idle"]

export var x_speed := 6
export var y_speed := 4

var velocity := Vector2.ZERO


func _ready():
	Events.connect("player_moved", self, "_on_Player_moved")


func _process(delta):
	motion_offset += velocity * delta


func _on_Player_moved(player) -> void:
	var player_velocity:Vector2 = player.state_machine.get_node("Move").velocity

	if player_velocity == Vector2.ZERO:
		velocity = Vector2.ZERO
		return

	velocity = Vector2(x_speed * sign(player_velocity.x) * -1, y_speed * sign(player_velocity.y) * -1)
