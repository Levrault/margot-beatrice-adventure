extends RayCast2D
class_name Laser

const MIN_BEAM_WIDTH := 2
const MAX_BEAM_WIDTH := 4
const BEAM_DURATION := .5

onready var tween := $Tween
onready var beam := $Beam
onready var casting_particle := $CastingParticle
onready var casting_particle2 := $CastingParticle2
onready var beam_particle := $BeamParticle
onready var damage_source_shape := $DamageSource/CollisionShape2D
onready var static_body_shape := $StaticBody2D/CollisionShape2D


func _ready() -> void:
	beam.points[1] = Vector2.ZERO

	tween.interpolate_property(
		beam, "width", MIN_BEAM_WIDTH, MAX_BEAM_WIDTH, BEAM_DURATION, Tween.EASE_IN, Tween.EASE_IN
	)
	tween.interpolate_property(
		beam,
		"width",
		MAX_BEAM_WIDTH,
		MIN_BEAM_WIDTH,
		BEAM_DURATION,
		Tween.EASE_OUT,
		Tween.EASE_IN,
		BEAM_DURATION
	)
	tween.start()


func _physics_process(delta: float) -> void:
	var cast_point := cast_to
	force_raycast_update()

	if not is_colliding():
		return

	cast_point = to_local(get_collision_point())
	casting_particle.global_rotation = get_collision_normal().angle()
	casting_particle.position = cast_point

	beam.points[1] = cast_point
	beam_particle.position = cast_point * .5
	beam_particle.process_material.emission_box_extents.x = cast_point.length() * .5
	damage_source_shape.position.x = cast_point.length() * .5
	damage_source_shape.shape.extents.x = cast_point.length() * .5
	static_body_shape.position.x = cast_point.length() * .5
	static_body_shape.shape.extents.x = cast_point.length() * .5
	set_physics_process(false)
