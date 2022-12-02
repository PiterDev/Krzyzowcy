extends KinematicBody2D

export var walk_speed := 230.0
var velocity := Vector2.ZERO
var accel := 0.7
var ammo := 3

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position()) # TODO: Smooth Rotation
	var direction := Vector2.ZERO

	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	direction = direction.normalized()

	velocity = lerp(velocity, direction * walk_speed, accel)

	velocity = move_and_slide(velocity)
	
	#Tomek tu był
	if Input.is_action_just_pressed("mouse_left") and ammo > 0:
		
		shoot()
		
func shoot():
	ammo -= 1
	print("shoot")
	
	
	
	
