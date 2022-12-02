extends HBoxContainer

var used_bullet_texture = preload("res://Assets/usedBullet.png")

onready var bullet_texturerect1 = get_node("TextureRect")
onready var bullet_texturerect2 = get_node("TextureRect2")
onready var bullet_texturerect3 = get_node("TextureRect3")

func _process(delta):
	if Globals.ammo == 2:
		bullet_texturerect1.set_texture(used_bullet_texture)
	if Globals.ammo == 1:
		bullet_texturerect2.set_texture(used_bullet_texture)
	if Globals.ammo == 0:
		bullet_texturerect3.set_texture(used_bullet_texture)
