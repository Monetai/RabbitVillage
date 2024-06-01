class_name MainGame
extends Node2D

@onready var farm_tile: TileMap = $Decors
@onready var obs_map: TileMap = $Obstacles
@onready var nav_agent: NavigationRegion2D = $NavigationRegion2D


var building_selected

func _ready() -> void:
	TileManager.free_tilemap = farm_tile
	TileManager.obs_tilemap = obs_map

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		TileManager.refresh_farm_production()
	#if Input.is_action_just_pressed("click"):
		#var tile : Vector2 = farm_tile.local_to_map(get_global_mouse_position())
		#click_position.global_position = get_global_mouse_position()
		#var tile_pos : Vector2 = farm_tile.map_to_local(tile)
		#position_tuile.global_position = tile_pos
		#print("Changement de position")
		
			
