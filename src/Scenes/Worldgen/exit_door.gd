extends Sprite


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_Area2D_body_entered(body:Node) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene("res://Scenes/Menu/Win.tscn")
