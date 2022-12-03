extends Area2D



func _on_AmmoRefill_body_entered(body:Node) -> void:
	if body.is_in_group("Player"):
		Globals.ammo = 3
		queue_free()
