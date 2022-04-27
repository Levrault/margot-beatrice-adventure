extends Node


func get_setting(key: String) -> bool:
	if OS.has_feature("debug"):
		if not ProjectSettings.has_setting("game/debug.%s" % key):
			return false
		print_debug("%s is %s" % ["game/debug.%s" % key, ProjectSettings.get_setting("game/debug.%s" % key)])
		return ProjectSettings.get_setting("game/debug.%s" % key)

	if OS.has_feature("release") and ProjectSettings.has_setting("game/release.%s" % key):
		if not ProjectSettings.has_setting("game/release.%s" % key):
			return false
		print_debug("%s is %s" % ["game/release.%s" % key, ProjectSettings.get_setting("game/release.%s" % key)])
		return ProjectSettings.get_setting("game/release.%s" % key)

	if not ProjectSettings.has_setting("game/%s" % key):
		printerr("%s does not exit" % "game/%s" % key)
		return false

	print_debug("%s is %s" % ["game/%s" % key, ProjectSettings.get_setting("game/%s" % key)])
	return ProjectSettings.get_setting("game/%s" % key)
