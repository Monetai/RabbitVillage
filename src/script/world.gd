class_name MainGame
extends Node2D

@onready var decors_map: TileMap = $Decors
@onready var obs_map: TileMap = $Obstacles
@onready var nav_agent: NavigationRegion2D = $NavigationRegion2D

const farm := Vector2(11, 0)
const pump := Vector2(13,0)

var building_selected


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		# Erase a tile
		var tile : Vector2 = decors_map.local_to_map(get_global_mouse_position())
		decors_map.erase_cell(0, tile)
	elif Input.is_action_just_pressed("build"):
		var tile : Vector2 = decors_map.local_to_map(get_global_mouse_position())
		obs_map.set_cell(0, tile, 0, farm)
		nav_agent.bake_navigation_polygon()
		
			
