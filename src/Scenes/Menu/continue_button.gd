extends Button



func _on_Button_pressed() -> void:
	Globals.ammo = 3
	get_tree().change_scene("res://Game.tscn")
