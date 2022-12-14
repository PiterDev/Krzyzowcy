extends Node2D

export var tilemap_width := 31
export var tilemap_height := 18

export var house_amount: int = 7

export var min_house_width: int = 2
export var min_house_height: int = 2

export var max_house_width: int = 7 
export var max_house_height: int = 7

export var rooftop_autotile_id := -1
export var alt_rooftop_autotile_id := -1

export(PackedScene) var enemy_scene
export(PackedScene) var bullet

onready var building_tilemap := $Tilemaps/TilemapBuildings as TileMap

var ammo_placed := false

func generate_houses() -> void:
	place_road()
	building_tilemap.clear()
	for i in house_amount:
		
		var obstructed := false
		var rand_pos_x := randi() % (tilemap_width) + 3
		var rand_pos_y := randi() % (tilemap_height) +  3
		var rand_width := randi() % max_house_width + min_house_width
		var rand_height := randi() % max_house_height + min_house_height

		for x in range(rand_pos_x, rand_pos_x+rand_width+1):
			for y in range(rand_pos_y, rand_pos_y+rand_height+1):
				var tiles_to_check := [
					building_tilemap.get_cell(x, y), 
					building_tilemap.get_cell(x+1, y),
					building_tilemap.get_cell(x-1, y),
					building_tilemap.get_cell(x, y+1),
					building_tilemap.get_cell(x, y-1)
					]
				
				for tile in tiles_to_check:
					if tile == rooftop_autotile_id or tile == alt_rooftop_autotile_id:
						obstructed = true
						break
				if obstructed: 
					break

			if obstructed: 
				break
		if obstructed:
			continue
		
		var new_enemy: KinematicBody2D = enemy_scene.instance()
		new_enemy.position = building_tilemap.map_to_world(Vector2(rand_pos_x-2, rand_pos_y))
		
		var chosen_autotile := rooftop_autotile_id if randf() > 0.5 else alt_rooftop_autotile_id
		for x in range(rand_pos_x, rand_pos_x+rand_width):
			for y in range(rand_pos_y, rand_pos_y+rand_height):
				building_tilemap.set_cell(x, y, chosen_autotile)
				building_tilemap.update_bitmask_area(Vector2(x, y))

		var corners := [
			Vector2(rand_pos_x, rand_pos_y), Vector2(rand_pos_x+(rand_width-1), rand_pos_y+(rand_height-1)),
			Vector2(rand_pos_x, rand_pos_y+(rand_height-1)), Vector2(rand_pos_x+(rand_width-1), rand_pos_y+(rand_height-1))
		]
		
		var patrol_points := []
		for corner in corners:
			patrol_points.append(building_tilemap.map_to_world(corner))

		# new_enemy.patrol_path = patrol_points
		if randf() > 0.25:
			$Enemies.add_child(new_enemy)
		else:
			new_enemy.free()
			new_enemy = null
	
	place_prefabs()
	clear_last()
	building_tilemap.update_dirty_quadrants() 

func place_prefabs() -> void:
	for x in tilemap_width:
		for y in tilemap_height:
			if building_tilemap.get_cell(x, y) == -1:
				if randf() > 0.99:
					$Tilemaps/TilemapPrefabs.set_cell(x, y, randi()%4)
					if randf() > 0.4 and not ammo_placed:
						var new_bullet = bullet.instance()
						new_bullet.position = building_tilemap.map_to_world(Vector2(x, y))
						add_child(new_bullet)
						ammo_placed = true


func place_road() -> void:
	var road_pos_x := randi()%tilemap_width
	for x in 4:
		for y in tilemap_height+1:
			$Tilemaps/TilemapGround.set_cell(road_pos_x+x, y, 0)
			$Tilemaps/TilemapGround.update_bitmask_area(Vector2(road_pos_x+x, y))

func mass_murder() -> void:
	for enemy in $Enemies.get_children():
		enemy.queue_free()

func generate() -> void:
	mass_murder()
	generate_houses()
	
func _ready() -> void:
	randomize()
	generate()

	

func clear_last() -> void:
	for y in tilemap_height+1:
		building_tilemap.set_cell(tilemap_width, y, -1)
		building_tilemap.update_bitmask_area(Vector2(tilemap_width, y))

		
