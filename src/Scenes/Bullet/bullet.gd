extends Area2D

export var speed := 800
onready var blood := preload("res://Scenes/Blood.tscn")
var hit := false

func _physics_process(delta):
	if hit: return
	position += transform.x * speed * delta



func _on_Bullet_body_entered(body:Node) -> void:
	if hit: return
	if body.is_in_group("Enemy"):
		body.queue_free()
		var new_blood := blood.instance()
		add_child(new_blood)
		new_blood.global_position = body.global_position
		new_blood.emitting = true
		hit = true
		$AudioStreamPlayer.play()


		$Sprite.hide()
		yield(get_tree().create_timer(1.2), "timeout")

		queue_free()
