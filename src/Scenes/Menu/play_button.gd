extends Button




func _on_Button_pressed() -> void:
	get_tree().change_scene("res://Game.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_Button3_pressed():
	get_tree().change_scene("res://Scenes/Menu/About.tscn")
	
