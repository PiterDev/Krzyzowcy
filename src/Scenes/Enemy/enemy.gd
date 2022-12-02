extends KinematicBody2D

onready var raycast := $RayCast2D as RayCast2D

func _ready():
	pass

func _on_Area2D_body_entered(body: PhysicsBody2D):
	var sees_player := false
	
	raycast.cast_to(body.position)
