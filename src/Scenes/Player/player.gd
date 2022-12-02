extends KinematicBody2D

export var walk_speed := 230.0
var velocity := Vector2.ZERO
var accel := 0.7
var ammo := 3
var ammo_in_weapon := 1

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position()) # TODO: Smooth Rotation
	var direction := Vector2.ZERO

	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	direction = direction.normalized()

	velocity = lerp(velocity, direction * walk_speed, accel)

	velocity = move_and_slide(velocity)
	
	#Tomek tu był
	
	if Input.is_action_just_pressed("mouse_right") and ammo_in_weapon == 0 and ammo > 0: # checks if you click rpm also checks if you already have ammo in magazine and checks if you have enouhg ammo to reload
		reload()

	
	if Input.is_action_just_pressed("mouse_left") and ammo_in_weapon == 1: #checks if you click lpm 
		shoot()
	if ammo == 0:
		print("no ammo")
		
		
func shoot():  #shoot and remove ammo from magazine
	ammo_in_weapon -= 1
	print("shoot")
	
func reload(): #sets ammo in magazine to 1 and remove one ammo from your overall ammo stock
	ammo -= 1
	ammo_in_weapon = 1
	print("reload")
	
	
