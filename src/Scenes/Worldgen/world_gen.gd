extends Node2D

export var tilemap_width := 31
export var tilemap_height := 18

export var house_amount: int = 7

export var min_house_width: int = 2
export var min_house_height: int = 2

export var max_house_width: int = 7 
export var max_house_height: int = 7

export var rooftop_autotile_id := -1

onready var building_tilemap := $Tilemaps/TilemapBuildings as TileMap

func generate_houses() -> void:
	building_tilemap.clear()
	for i in house_amount:
		
		var obstructed := false
		var rand_pos_x := randi() % (tilemap_width)
		var rand_pos_y := randi() % (tilemap_height)
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
		
		for x in range(rand_pos_x, rand_pos_x+rand_width):
			for y in range(rand_pos_y, rand_pos_y+rand_height):
				building_tilemap.set_cell(x, y, rooftop_autotile_id)
				building_tilemap.update_bitmask_area(Vector2(x, y))
	building_tilemap.update_dirty_quadrants() 

func _ready() -> void:
	generate_houses()
	clear_last()

func clear_last() -> void:
	for y in tilemap_height+1:
		building_tilemap.set_cell(tilemap_width+1, y, -1)
		building_tilemap.update_bitmask_area(Vector2(tilemap_width, y))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		generate_houses()

func _on_Area2D_body_entered(body:Node) -> void:
	pass # Replace with function body.
