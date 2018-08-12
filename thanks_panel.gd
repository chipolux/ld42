extends Panel

signal resume
signal reset


func _input(event):
	if not visible:
		return
	elif event is InputEventKey and event.pressed and event.scancode == KEY_R:
		get_tree().set_pause(false)
		emit_signal("reset")
	elif event is InputEventKey:
		get_tree().set_pause(false)
		emit_signal("resume")