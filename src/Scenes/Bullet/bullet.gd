extends Area2D

export var speed := 2250

func _physics_process(delta):
	position += transform.x * speed * delta



func _on_Bullet_body_entered(body:Node) -> void:
	if body.is_in_group("Enemy"):
		body.queue_free()
		queue_free()
