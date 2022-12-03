extends KinematicBody2D

export var walk_speed := 230.0
var velocity := Vector2.ZERO
var accel := 0.7

export(PackedScene) var bullet
	

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position()) # TODO: Smooth Rotation
	var direction := Vector2.ZERO

	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	direction = direction.normalized()

	velocity = lerp(velocity, direction * walk_speed, accel)

	velocity = move_and_slide(velocity)
	

	
	#Tomek tu był
	if Input.is_action_just_pressed("mouse_left") and Globals.ammo > 0:
		shoot()
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

