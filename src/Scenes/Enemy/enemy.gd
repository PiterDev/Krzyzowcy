extends KinematicBody2D

onready var raycast := $RayCast2D as RayCast2D

var player_in_view := false
var player_node: KinematicBody2D
var timer_started := false
export var on_path := true

var detected := false

export(Color) var default_color 
export(Color) var seen_color 
# export(Array, Vector2) var patrol_path := []
# var current_patrol_point: int = 0

var start_pos := Vector2.ZERO

var walk_speed := 100
# signal on_patrol_next_point

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		# $"Spotted".play()
		
		player_in_view = true
		player_node = body

func _on_Area2D_body_exited(body:Node) -> void:
	if body.is_in_group("Player"):
		player_in_view = false
		detected = false
		Globals.emit_signal("player_undetected")

func wall_check(cast_to_global: Vector2) -> bool:
	if not player_in_view: return false
	raycast.cast_to = raycast.to_local(cast_to_global)
	raycast.force_raycast_update()
	if not raycast.is_colliding() or not raycast.get_collider():
		return false
	if raycast.get_collider().is_in_group("Player"):
		return true
	return false

func _process(_delta: float) -> void:
	if not player_in_view: 
		return
	if wall_check(player_node.global_position):
		look_at(player_node.global_position) # TODO: Make it smooth
		$SightOverlay.color = seen_color
		# $Exclamation.show()
		# $Exclamation.global_rotation_degrees = 0
		detected = true
		if not timer_started:
			Globals.emit_signal("player_detected")
			$Timer.start()
			timer_started = true


# func walk_to_point(local_pos: Vector2) -> void:
# 	var walk_target := start_pos + local_pos

# 	var walk_tween := create_tween()
# 	var walk_time := position.distance_to(walk_target)/walk_speed
	
	
# 	var random_rotation: float = randi() % 360
# 	#  TODO: Fix This!!!
	
# 	# look_at(walk_target)
# 	walk_tween.tween_property(self, "rotation_degrees", random_rotation, 1)
# 	walk_tween.tween_property(self, "position", walk_target, walk_time)
# 	walk_tween.play()
# 	walk_tween.connect("finished", self, "_on_Enemy_on_patrol_next_point") 

func _on_Timer_timeout() -> void:
	if wall_check(player_node.global_position):
		get_tree().change_scene("res://Scenes/Menu/Death.tscn")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		# $SightOverlay.color = default_color
		# $Exclamation.hide()
		pass

	timer_started = false

func _on_RotateTimer_timeout() -> void:
	if detected:
		look_at(player_node.global_position)
		return
	var rot_tween := create_tween()
	var random_rotation: float = randi() % 360
	rot_tween.tween_property(self, "rotation_degrees", random_rotation, 1)
	rot_tween.play()


func _ready() -> void:
	rotation_degrees = randi() % 180 + 100
	$RotateTimer.wait_time = randi() % 10 + 2
	$RotateTimer.start()
