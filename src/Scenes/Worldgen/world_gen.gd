extends Node2D

export var tilemap_width := 31
export var tilemap_height := 18

export var house_amount: int = 7

export var min_house_width: int = 2
export var min_house_height: int = 2

export var max_house_width: int = 7 
export var max_house_height: int = 7

export var rooftop_autotile_id := -1


export(PackedScene) var enemy_scene

onready var building_tilemap := $Tilemaps/TilemapBuildings as TileMap

func generate_houses() -> void:
	place_road()
	building_tilemap.clear()
	for i in house_amount:
		
		var obstructed := false
		var rand_pos_x := randi() % (tilemap_width) + 1
		var rand_pos_y := randi() % (tilemap_height) +  1
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
					if tile == rooftop_autotile_id:
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
		

		for x in range(rand_pos_x, rand_pos_x+rand_width):
			for y in range(rand_pos_y, rand_pos_y+rand_height):
				building_tilemap.set_cell(x, y, rooftop_autotile_id)
				building_tilemap.update_bitmask_area(Vector2(x, y))

		var corners := [
			Vector2(rand_pos_x, rand_pos_y), Vector2(rand_pos_x+(rand_width-1), rand_pos_y+(rand_height-1)),
			Vector2(rand_pos_x, rand_pos_y+(rand_height-1)), Vector2(rand_pos_x+(rand_width-1), rand_pos_y+(rand_height-1))
		]
		
		var patrol_points := []
		for corner in corners:
			print(building_tilemap.map_to_world(corner))
			patrol_points.append(building_tilemap.map_to_world(corner))

		# new_enemy.patrol_path = patrol_points
		if randf() > 0.5:
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
					print("Placing prefab")
					$Tilemaps/TilemapPrefabs.set_cell(x, y, randi()%4)

func place_road() -> void:
	var road_pos_x := randi()%tilemap_width
	for x in 4:
		for y in tilemap_height+1:
			$Tilemaps/TilemapGround.set_cell(road_pos_x+x, y, 0)
			$Tilemaps/TilemapGround.update_bitmask_area(Vector2(road_pos_x+x, y))

func _ready() -> void:
	generate_houses()
	

func clear_last() -> void:
	for y in tilemap_height+1:
		building_tilemap.set_cell(tilemap_width+1, y, -1)
		building_tilemap.update_bitmask_area(Vector2(tilemap_width, y))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		generate_houses()
