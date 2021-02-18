extends Control

var selected_position := rect_position
var unselected_position := Vector2(
	rect_position.x + ProjectSettings.get_setting("display/window/size/width"), rect_position.y
)

onready var _title := $Container/TitlePanel/MarginContainer/Label
onready var _gems_panel := $Container/GemsPanel
onready var _gems := $Container/GemsPanel/MarginContainer/HBoxContainer/MaxScore
onready var _acorns_panel := $Container/AcornsPanel
onready var _acorns := $Container/AcornsPanel/MarginContainer/HBoxContainer/MaxScore
onready var _carrots_panel := $Container/CarrotsPanel
onready var _carrots := $Container/CarrotsPanel/MarginContainer/HBoxContainer/MaxScore
onready var _description := $ResumePanel/MarginContainer/ResumeText
onready var _tween := $Tween


func _ready() -> void:
	Events.connect("worldmap_level_selected", self, "_on_Worldmap_level_selected")
	Events.connect("worldmap_level_hidden", self, "_on_Worldmap_level_hidden")


func _on_Worldmap_level_selected(data: Dictionary) -> void:
	# _anim.play("show")
	_title.text = tr(data.title)
	_description.bbcode_text = tr(data.description)

	if data.has("gems"):
		_gems.text = "%s" % data.gems
		_gems_panel.show()
	else:
		_gems_panel.hide()

	if data.has("acorns"):
		_acorns.text = "%s" % data.acorns
		_acorns_panel.show()
	else:
		_acorns_panel.hide()

	if data.has("carrots"):
		_carrots_panel.show()
		_carrots.text = "%s" % data.carrots
	else:
		_carrots_panel.hide()

	_tween.interpolate_property(
		self,
		"rect_position",
		unselected_position,
		selected_position,
		.2,
		Tween.TRANS_LINEAR,
		Tween.TRANS_LINEAR
	)
	_tween.start()


func _on_Worldmap_level_hidden() -> void:
	if rect_position != selected_position:
		return
	_tween.interpolate_property(
		self,
		"rect_position",
		selected_position,
		unselected_position,
		.2,
		Tween.TRANS_LINEAR,
		Tween.TRANS_LINEAR
	)
	_tween.start()
