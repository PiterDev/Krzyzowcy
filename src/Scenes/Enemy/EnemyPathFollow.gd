extends PathFollow2D

export(int) var time_seconds := 5

func _ready() -> void:
	var path_tween := create_tween()
	unit_offset = 0
	path_tween.tween_property(self, "unit_offset", 1, time_seconds)