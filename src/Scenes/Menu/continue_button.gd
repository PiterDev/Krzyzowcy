extends Button



func _on_Button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Globals.ammo = 3
	get_tree().change_scene("res://Game.tscn")
