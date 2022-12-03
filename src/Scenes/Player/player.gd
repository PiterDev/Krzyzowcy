extends KinematicBody2D

export var walk_speed := 230.0
var velocity := Vector2.ZERO
var accel := 0.7

export(PackedScene) var bullet
export(PackedScene) var ammo_refill


func _ready() -> void:
	$Spotted.hide()
	Globals.connect("player_detected", self, "_player_detected")
	Globals.connect("player_undetected", self, "_player_undetected")

func _player_detected() -> void:
	print("Entered")
	$Spotted.global_rotation_degrees = 0
	# $Spotted/AnimationPlayer.stop()
	# $Spotted/AnimationPlayer.seek(0.0)
	$Spotted2.play()

	$Spotted.show()

func _player_undetected() -> void:
	print("Exited")
	# $Spotted/AnimationPlayer.stop()
	# $Spotted/AnimationPlayer.seek(0.0)
	$Spotted.hide()
	# $Spotted2.play()

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())# TODO: Smooth Rotation
	global_rotation_degrees += 7
	var direction := Vector2.ZERO

	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	direction = direction.normalized()

	velocity = lerp(velocity, direction * walk_speed, accel)

	velocity = move_and_slide(velocity)
	
	if direction != Vector2.ZERO:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Walk")
	else:
		print("Not walking")
		$AnimationPlayer.stop(false)
	
	#Tomek tu był
	if Input.is_action_just_pressed("mouse_left") and Globals.ammo > 0:
		shoot()
		$"Shoot1".play()
	if Globals.ammo == 0:
		# print("no ammo")
		pass
		
		
func shoot():  #shoot and remove ammo from magazine
	Globals.ammo -= 1
	# bullet
	for bullet_pos in $Sprite.get_children():
		if not bullet_pos is Position2D: continue 
		var spawn_pos: Vector2 = bullet_pos.global_position
		var new_bullet: Area2D = bullet.instance()
		new_bullet.global_transform = bullet_pos.global_transform
		owner.add_child(new_bullet)
		


