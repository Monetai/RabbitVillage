class_name MainGame
extends Node2D

@onready var farm_map: TileMap = $Ground
@onready var obs_map: TileMap = $Obstacle
@onready var nav_region: NavigationRegion2D = $NavigationRegion2D
@onready var ui: CanvasLayer = $UI

@onready var rabbit_node: Node2D = $RabbitNode
@onready var crotte_node: Node2D = $CrotteNode

# Tool
@onready var vacuum: Vacuum = $ToolList/Vacuum
@onready var farm_cursor: Node2D = $ToolList/FarmCursor
@onready var dynamite: Node2D = $ToolList/Dynamite

# TileList
var mountain_tiles : Array[Vector2i]
var farm_tiles : Array[Vector2i]

enum TOOL {
	FARM,
	DESTROY,
	VACUUM,
	NONE
}

var farm_price: int = 400
var destroy_price: int = 400

var tool_selected : TOOL = TOOL.NONE
var tile_selected := Vector2i(-10, -10)

func _ready() -> void:
	TileManager.free_tilemap = farm_map
	TileManager.obs_tilemap = obs_map
	ui.tool_selected.connect(on_tool_selected)
	Stats.rabbit_count = rabbit_node.get_child_count()
	refresh_tile_list()
	
func refresh_tile_list():
	mountain_tiles = obs_map.get_used_cells(0).filter(func(x): return !x in obs_map.get_used_cells_by_id(0, 1, Vector2.ZERO, 1))
	farm_tiles = farm_map.get_used_cells(0).filter(func(x): return !x in obs_map.get_used_cells(0))
	nav_region.call_deferred("bake_navigation_polygon")

func check_price():
	if tool_selected == TOOL.FARM:
		return Stats.crotte_count >= farm_price
	elif tool_selected == TOOL.DESTROY:
		return Stats.crotte_count >= destroy_price
	
	
func on_tool_selected(tool: String):
	farm_cursor.visible = false
	vacuum.visible = false
	dynamite.visible = false
	get_tree().call_group("farm", "toggle_radius", false)
	match(tool):
		"farm":
			farm_cursor.visible = true			
			tool_selected = TOOL.FARM
			get_tree().call_group("farm", "toggle_radius", true)
		"vacuum":
			vacuum.visible = true
			tool_selected = TOOL.VACUUM
		"destroy":
			dynamite.visible = true
			tool_selected = TOOL.DESTROY
	

func check_farm_position(selected_tile: Vector2i):
	pass
	var cells = [
		selected_tile,
		selected_tile + Vector2i(0, -1),
		selected_tile + Vector2i(1, -1),
		selected_tile + Vector2i(1, 0),
		selected_tile + Vector2i(-1,0),
		selected_tile + Vector2i(-1,1),
		selected_tile + Vector2i(0,1),
	]
	return cells.all(func(x): return x in farm_tiles)

func _process(delta: float) -> void:
	if tool_selected == TOOL.NONE:
		return
		
	match(tool_selected):
		TOOL.FARM:
			var tile : Vector2i = farm_map.local_to_map(get_global_mouse_position())
			if check_farm_position(tile):
				tile_selected = tile
				farm_cursor.global_position = farm_map.map_to_local(tile)
			else:
				pass
		TOOL.DESTROY:
			var tile : Vector2i = obs_map.local_to_map(get_global_mouse_position())
			if tile in mountain_tiles:
				tile_selected = tile
				dynamite.global_position = obs_map.map_to_local(tile)
			else:
				pass
		TOOL.VACUUM:
			vacuum.global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			print(tile_selected)
			match(tool_selected):
				TOOL.FARM:
					if check_price():
						print(tile_selected)
						obs_map.set_cell(0, tile_selected, 1, Vector2.ZERO, 1)
						Stats.crotte_count -= farm_price
						refresh_tile_list()
					else:
						print("Error: not enough poop")
				TOOL.DESTROY:
					if check_price():
						obs_map.erase_cell(0, tile_selected)
						Stats.crotte_count -= destroy_price
						await get_tree().create_timer(0.1).timeout
						refresh_tile_list()
						dynamite.global_position = Vector2(-100, -100)
					else:
						print("Error: Not enought Poop")
				TOOL.VACUUM:
					vacuum.start()
		else:
			match(tool_selected):
				TOOL.FARM:
					pass
				TOOL.DESTROY:
					pass
				TOOL.VACUUM:
					vacuum.stop()
		
			
