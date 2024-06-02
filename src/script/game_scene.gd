class_name MainGame
extends Node2D

@onready var farm_tile: TileMap = $Ground
@onready var obs_map: TileMap = $Obstacle
@onready var nav_agent: NavigationRegion2D = $NavigationRegion2D
@onready var ui: CanvasLayer = $UI

@onready var rabbit_node: Node2D = $RabbitNode
@onready var crotte_node: Node2D = $CrotteNode

# Tool
@onready var vacuum: Vacuum = $ToolList/Vacuum
@onready var farm_cursor: Node2D = $ToolList/FarmCursor
@onready var dynamite: Node2D = $ToolList/Dynamite

enum TOOL {
	FARM,
	DESTROY,
	VACUUM,
	NONE
}

var tool_selected : TOOL = TOOL.NONE

func _ready() -> void:
	TileManager.free_tilemap = farm_tile
	TileManager.obs_tilemap = obs_map
	ui.tool_selected.connect(on_tool_selected)
	Stats.rabbit_count = rabbit_node.get_child_count()
	
	
func on_tool_selected(tool: String):
	var reset_position = Vector2(-100, -100)
	farm_cursor.global_position = reset_position
	vacuum.global_position = reset_position
	dynamite.global_position = reset_position
	match(tool):
		"farm":
			tool_selected = TOOL.FARM
		"vacuum":
			tool_selected = TOOL.VACUUM
		"destroy":
			tool_selected = TOOL.DESTROY
	

func _process(delta: float) -> void:
	if tool_selected == TOOL.NONE:
		return
		
	#tool_node[tool_selected].global_position = get_global_mouse_position()
	match(tool_selected):
		TOOL.FARM:
			pass
		TOOL.DESTROY:
			var tile : Vector2i = obs_map.local_to_map(get_global_mouse_position())
			if tile in obs_map.get_used_cells(0):
				dynamite.global_position = obs_map.map_to_local(tile)
		TOOL.VACUUM:
			vacuum.global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print(event)
		if event.is_pressed():
			match(tool_selected):
				TOOL.FARM:
					pass
				TOOL.DESTROY:
					pass
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
		
			
