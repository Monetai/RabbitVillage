# TileManager
extends Node

## Gerer les tilemap ainsi que les operations sur celles ci

var obs_tilemap : TileMap
var free_tilemap : TileMap

func get_farm_tile(farm: Farm):
	var tile_list = []
	var free_tiles = free_tilemap.get_used_cells(0)
	var obs_tiles = obs_tilemap.get_used_cells_by_id(0, 1, Vector2.ZERO, 2)
	
	var tiles = free_tiles.filter(func(x): return x not in obs_tiles)
	
	for tile in tiles:
		var t_pos = free_tilemap.map_to_local(tile)
		if farm.global_position.distance_to(t_pos) <= farm.radius:
			tile_list.append(tile)
		
	print(tile_list)
	return tile_list

func refresh_farm_production():
	var total_production
	var temp_farm_list = {}
	var farm_list = get_tree().get_nodes_in_group("farm")
	
	for farm in farm_list:
		temp_farm_list[farm] = get_farm_tile(farm)
	
	print("Get farm tile list done")
	
	for farm in temp_farm_list.keys():
		for other_farm in temp_farm_list.keys():
			if other_farm == farm: 
				continue
			# Filtrage des tiles selon les autres fermes
			temp_farm_list[farm] = temp_farm_list[farm].filter(func(x): return !x in temp_farm_list[other_farm])
		
				
		
