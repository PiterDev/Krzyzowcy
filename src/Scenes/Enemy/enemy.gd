extends KinematicBody2D

onready var raycast := $RayCast2D as RayCast2D

var player_in_view := false
var player_node: KinematicBody2D
var timer_started := false
export var on_path := true

export(Color) var default_color 
export(Color) var seen_color 

func _on_Area2D_body_entered(body: Node) -> void:
	
	if body.is_in_group("Player"):
		
		player_in_view = true
		player_node = body

		

func _on_Area2D_body_exited(body:Node) -> void:
	if body.is_in_group("Player"):
		player_in_view = false
		# $Timer.stop()


		

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
	if wall_check(player_node.global_position) and not timer_started:

		$SightOverlay.color = seen_color
		$Exclamation.show()
		$Exclamation.global_rotation_degrees = 0

		$Timer.start()
		timer_started = true

func _on_Timer_timeout() -> void:
	if wall_check(player_node.global_position):
		print("Player Spotted! Died")
	else:
		$SightOverlay.color = default_color
		$Exclamation.hide()
		$Exclamation.global_rotation_degrees = 0

	timer_started = false
