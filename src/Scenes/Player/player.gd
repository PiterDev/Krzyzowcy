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
	
	if Input.is_action_just_pressed("mouse_right") and ammo_in_weapon == 0 and ammo > 0: #sprawdza czy klikasz rpm czy ammo w broni to 0 i czy masz ammo żeby przeładować
		reload()

	
	if Input.is_action_just_pressed("mouse_left") and ammo_in_weapon == 1: #sprawdza czy klikasz lpm i czy masz ammo w broni
		shoot()
	if ammo == 0:
		print("no ammo")
		
		
func shoot():  #strzela i odejmuje ammo z broni
	ammo_in_weapon -= 1
	print("shoot")
	
func reload(): #ustawia ammo w broni  na 1 i odejmuje 1 z ogólnego stocka broni
	ammo -= 1
	ammo_in_weapon = 1
	print("reload")
	
	
