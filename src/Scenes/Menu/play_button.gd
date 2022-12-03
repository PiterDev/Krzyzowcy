extends Button




func _on_Button_pressed() -> void:
	get_tree().change_scene("res://Game.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
